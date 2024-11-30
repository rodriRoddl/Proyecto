% Function to generate the timestamps of the packet arrival at ONUs.
% It can produce timestamps following deterministic, exponential, uniform,
% generalized Pareto, gamma, and Gaussian.
% example: pkt_arr_time = onu_pkt_arr_times('deterministic',1/4,nan,10)
%          pkt_arr_time = onu_pkt_arr_times('exponential',1/4,nan,10)
%          pkt_arr_time = onu_pkt_arr_times('uniform',1/4,1/2,10)
%          pkt_arr_time = onu_pkt_arr_times('Gaussian',1/4,1/8,10)

function pkt_arr_time = pkt_arr_times(type,par1,par2,max_pkts,varargin)
    if(strcmp(type,'deterministic'))
        avg_arr_time = par1;
        pkt_arr_time = avg_arr_time*ones(1,max_pkts);

    elseif(strcmp(type,'exponential'))
        avg_arr_time = par1;
        pkt_arr_time = exprnd(avg_arr_time,1,max_pkts);

    elseif(strcmp(type,'uniform'))
        min_arr_time = par1;
        max_arr_time = par2;
        pkt_arr_time = min_arr_time + (max_arr_time - min_arr_time)*rnd(1,max_pkts);

    elseif(strcmp(type,'GP'))
        k = par1;
        sigma = par2;
        theta = 0;          % minimum value for time is 0
        pkt_arr_time = gprnd(k,sigma,theta,1,max_pkts);

    elseif(strcmp(type,'gamma'))
        a = par1;
        b = par2;
        pkt_arr_time = gamrnd(a,b,1,max_pkts);

    elseif(strcmp(type,'Gaussian'))
        mean = par1;
        variance = par2;
        pkt_arr_time = mean + variance*abs(randn(1,max_pkts));

    end
end 