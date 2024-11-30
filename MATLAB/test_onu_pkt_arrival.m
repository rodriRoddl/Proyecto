clc,clear,close all;
format longG

lambda = 0.5;                                           % network load [0,1]
onus = 4;                                               % number of ONUs
onu_load = lambda/onus;                                 % load per ONU
R = 1e9;                                                % total datarate (1 Gbps)
R_B = R/8;                                              % total byte rate (1 Byte = 8 bits)
R_o = onu_load*R_B                                      % byte rate per ONU

avg_pkt_rate = R_o/803;                                 % average packet arrival rate (avg. pkt length = 803)
arr_times = exprnd(1/avg_pkt_rate,1,100000);            % packet inter-arrival times (exponential distributed)
%arr_times = 1/avg_pkt_rate*ones(1,100000);
pkt_size = randi([64,1542],1,100000);                   % uniformly distributed packet size (bytes)
%pkt_size = 803*ones(1,100000);
rate = sum(pkt_size)/sum(arr_times)


x = exprnd(1/4,1,1000);
B1 = 2*rand(1,size(x,2));
r = sum(B1)/sum(x)
B2 = ones(1,size(x,2));
r = sum(B2)/sum(x);

x = 1/4*ones(1,1000);
B1 = 2*rand(1,size(x,2));
r = sum(B1)/sum(x)
B2 = ones(1,size(x,2));
r = sum(B2)/sum(x)

t = exprnd(1/8,1,10000);
B1 = rand(1,size(t,2));
r = sum(B1)/sum(t);
B2 = 0.5*ones(1,size(t,2));
r = sum(B2)/sum(t);

t = 1/8*ones(1,10000);
B1 = rand(1,size(t,2));
r = sum(B1)/sum(t);
B2 = 0.5*ones(1,size(t,2));
r = sum(B2)/sum(t);