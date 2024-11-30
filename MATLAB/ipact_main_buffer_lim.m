%% Interleaved Polling Adaptive Cycle Time (IPACT) for 1G-EPON
% This is a state-space model-based simulation. The ONUs are assumed to have limited buffer. 
% Copyright @ Sourav Mondal, souravmondal003@gmail.com
clc, clear, close all;

%Lambda = 0.05:0.05:1.0;                                     % network load [0,1]
Lambda = 0.1:0.1:1.0;
%Lambda = 0.9;
onu_no = 16;                                                % total number of ONUs
c = 2.04218*1e5;                                            % speed of light in fiber (2 x 10^5 km/s)
onu_buff = 10e3;                                            % ONU buffer size (10 KBytes)
grant_reqst_size = 64;                                      % grant or request message size (64 bytes)
onu_max_grant = 11000;                                      % ONU maximum grant size (bytes)
onu_olt_dist = 20*ones(1,onu_no);                           % OLT-ONU distance (km)
%onu_olt_dist = 20*rand(1,onu_no);
avg_pkt_delay_all = zeros(1,size(Lambda,2));
avg_pkt_trx_delay_all = zeros(1,size(Lambda,2));
polling_cycles = zeros(1,size(Lambda,2));

R_p = 2488e6;                                               % total uplink datarate (in bps) = 2488 Mbps
R_pb = R_p/8;                                               % total uplink datarate (in Bps)
R_o = 1244e6;                                               % max ONU uplink datarate (in bps) = 1244 Mbps
R_ob = R_o/8;                                               % max ONU uplink datarate (in Bps)

pkt_sz_min = 64;                                            % Ethernet packet size - minimum
pkt_sz_max = 4542;                                          % Ethernet packet size - maximum
pkt_sz_avg = (pkt_sz_min + pkt_sz_max)/2;
max_pkts = 1e3;                                             % maximum number of packets per ONU
T_guard = 5e-6;                                             % guard time for each ONU

for k = 1:1:size(Lambda,2)
    lambda = Lambda(k);                                     % current load
    onu_load = lambda;                                      % load per ONU
    R_eff = onu_load*R_ob;                                  % datarate per ONU (in Bps)
    avg_pkt_rate = R_eff/pkt_sz_avg;                        % average packet arrival rate (avg. pkt length = 803 Bytes)

    onu_pkt_arr_times = zeros(onu_no,max_pkts);             % packet inter-arrival times in ONUs
    onu_pkt_sizes = zeros(onu_no,max_pkts);                 % packet sizes in the ONUs
    onu_pkt_tx_times = zeros(onu_no,max_pkts);              % packet transmission start times from ONUs
    olt_pkt_rx_times = zeros(onu_no,max_pkts);              % packet reception times at OLTs
    onu_pkt_drop_count = zeros(1,onu_no);                   % packet drop count of each ONU
    olt_grant_tx_times = zeros(1,onu_no);                   % times to send grants from OLTs
    onu_grant_arr_times = zeros(1,onu_no);                  % times when ONUs receive grant messages

    %onu_grant_req = onu_max_grant*ones(1,onu_no);          % initialize all ONUs with max grant
    onu_grant_req = zeros(1,onu_no);                        % initialize all ONUs with zero grant
    polling_table = create_polling_table(onu_no,onu_olt_dist,onu_grant_req,R_p);       % initializing polling table

    %% noting the arrival times and sizes of packets at all ONUs
    for o = 1:1:onu_no
        pkt_arr_time = pkt_arr_times('exponential',1/avg_pkt_rate,nan,max_pkts);
        onu_pkt_arr_times(o,:) = cumsum(pkt_arr_time);      % cumulatively add packet inter-arrival times
        onu_pkt_sizes(o,:) = randi([64,1542],1,max_pkts);
        rate = sum(onu_pkt_sizes(o,:))/sum(pkt_arr_time);   % just for check with R_o
    end

    current_time = 0;                                       % initializing the simulation time
    packets_processed = 0;                                  % no. of packets processed
    polling_cycle_no = 0;                                   % counter for polling cycles

    %% packet simulation starts here
    while(packets_processed < onu_no*max_pkts)              % iteratively create polling cycles until all packets are processed
        [~,onu_schd_indx] = sort(polling_table(:,4));       % sorting ONUs by total latency

        % calculating grant scheduling times at OLT and arrival times at ONUs
        olt_time_cursor = current_time;
        onus_granted = 0;
        for o = 1:1:size(onu_schd_indx,1)
            ok = onu_schd_indx(o);                          % current ONU
            if(onus_granted == 0)
                olt_grant_tx_times(ok) = olt_time_cursor;
                onu_grant_arr_times(ok) = olt_grant_tx_times(ok) + onu_olt_dist(ok)/c;
                onus_granted = onus_granted + 1;
            else
                bk = onu_schd_indx(o-1);                    % previous ONU
                olt_grant_tx_times(ok) = olt_grant_tx_times(bk) + polling_table(bk,4) + (grant_reqst_size/R_pb)+ T_guard - polling_table(ok,2);
                olt_time_cursor = olt_grant_tx_times(ok);
                onu_grant_arr_times(ok) = olt_grant_tx_times(ok) + onu_olt_dist(ok)/c;
                onus_granted = onus_granted + 1;
            end
        end

        for o = 1:1:size(onu_schd_indx,1)                           % send grant messages to ONUs in time-sorted order
            ok = onu_schd_indx(o);
            onu_time_cursor = onu_grant_arr_times(ok);              % forwarding time cursor
            [~,buff_pkt_idx] = find(onu_pkt_tx_times(ok,:) == 0);   % index of packets lying in buffer

            buff_usage = 0;                                         % to calculate occupied buffer
            pending_buff = 0;                                       % for the remaining packets

            for j = 1:1:size(buff_pkt_idx,2)
                jk = buff_pkt_idx(j);

                if(onu_pkt_arr_times(ok,jk) > onu_grant_arr_times(ok))    % if the packet didn't arrive before grant_time, we break out
                    onu_grant_req(ok) = min(pending_buff+grant_reqst_size,onu_max_grant);  % updating grant request for next polling cycle
                    break;
                else
                    buff_usage = buff_usage + onu_pkt_sizes(ok,jk);
                end

                if(buff_usage > onu_grant_req(ok))            % if the packet is beyond current grant size, then do not sent now
                    pending_buff = pending_buff + onu_pkt_sizes(ok,jk);
                    if(j == size(buff_pkt_idx,2))
                        onu_grant_req(ok) = min(pending_buff+grant_reqst_size,onu_max_grant);  % updating grant request for next polling cycle
                        break;
                    else
                        continue;
                    end
                end

                packets_processed = packets_processed + 1;

                if(buff_usage > onu_buff)                     % if the ONU buffer is overflown, the packet is dropped
                    onu_pkt_tx_times(ok,jk) = nan;
                    olt_pkt_rx_times(ok,jk) = nan;
                    onu_pkt_drop_count(ok) = onu_pkt_drop_count(ok) + 1;
                    continue;
                end

                % all checks passed - now transmit the packet
                onu_time_cursor = onu_time_cursor + onu_pkt_sizes(ok,jk)/R_pb;
                onu_pkt_tx_times(ok,jk) = onu_time_cursor;
                olt_pkt_rx_times(ok,jk) = onu_pkt_tx_times(ok,jk) + onu_olt_dist(ok)/c;

            end                % end of transmission of existing packets in buffer
        end                    % end of current polling cycle

        current_time = olt_grant_tx_times(ok) + polling_table(ok,4) + (grant_reqst_size/R_pb) + T_guard;   % taking the current_time to the end
        % updating the polling table
        polling_table(:,3) = onu_grant_req/R_p;
        polling_table(:,4) = polling_table(:,2) + polling_table(:,3);
        polling_cycle_no = polling_cycle_no + 1;                                 % updating the polling cycle counter

    end                 % end of processing of all packets

    polling_cycles(k) = polling_cycle_no;
    onu_pkt_delay = onu_pkt_tx_times - onu_pkt_arr_times;       % calculating the delay of each packet in all ONUs
    onu_pkt_delay(isnan(onu_pkt_delay)) = 0;                    % replacing all the NaN values with 0
    avg_pkt_delay_onu = mean(onu_pkt_delay,2);
    avg_pkt_delay_all(k) = mean(avg_pkt_delay_onu,"all");

    onu_pkt_trx_delay = olt_pkt_rx_times - onu_pkt_arr_times;   % calculating the total Tx delay of each packet
    onu_pkt_trx_delay(isnan(onu_pkt_trx_delay)) = 0;                    % replacing all the NaN values with 0
    avg_pkt_trx_delay_onu = mean(onu_pkt_trx_delay,2);
    avg_pkt_trx_delay_all(k) = mean(avg_pkt_trx_delay_onu,"all");
    total_drops = sum(onu_pkt_drop_count);                      % Total de paquetes perdidos en todas las ONUs

fprintf('Total de paquetes perdidos: %d\n', total_drops);
end         % end of simulation for a given lambda

%% calling function to make all plots
plot_results(Lambda,polling_cycles,avg_pkt_delay_all,avg_pkt_trx_delay_all);













