% Function to create polling table considering all the ONUs.
% Example: polling_table = create_polling_table(4,20*ones(1,4),15000,1e9)

function polling_table = create_polling_table(onu_no,onu_olt_dist,grant_size,link_speed)
    c = 2*1e5;                                                          % speed of light in fiber (2 x 10^5 km/s)
    polling_table = zeros(onu_no,4);
    % filling up the polling table columns
    polling_table(:,1) = [1:1:onu_no]';                                 % 1. onu index
    polling_table(:,2) = 2*onu_olt_dist'/c;                             % 2. ONU-OLT round-trip-time
    polling_table(:,3) = grant_size'*8/link_speed;                      % 3. grant size (Bytes) transmission time
    polling_table(:,4) = polling_table(:,2) + polling_table(:,3);       % 4. total time
end
