close all
clear all
clc

team_names = {'Predictions', 'FederationS', 'FedIPC', 'WirelessAI'};

load('array_ap_stas.mat')

figure
for i = 1 : length(team_names)
    load(['error_' team_names{i} '.mat'])
    bss_error{i} = err;
    results_2_sta{i} = err(array_ap_stas(1:length(err),2) == 2);
    results_3_sta{i} = err(array_ap_stas(1:length(err),2) == 3);
    results_4_sta{i} = err(array_ap_stas(1:length(err),2) == 4);  
    results_2_ap{i} = err(array_ap_stas(1:length(err),1) == 2);
    results_3_ap{i} = err(array_ap_stas(1:length(err),1) == 3);
    results_4_ap{i} = err(array_ap_stas(1:length(err),1) == 4);
    results_5_ap{i} = err(array_ap_stas(1:length(err),1) == 5);
    results_6_ap{i} = err(array_ap_stas(1:length(err),1) == 6);
    cdfplot(abs(bss_error{i}))
    hold on
end
ylabel('CDF')
xlabel('Error (Mbps)')
set(gca,'fontsize',16)
grid on
grid minor
legend(team_names)

%%
figure
for i = 2 : length(team_names)
x1 = results_2_sta{i};
x2 = results_3_sta{i};
x3 = results_4_sta{i};
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
subplot(1,3,i-1)
boxplot(x, g)
xlabel('N STAs')
ylabel('Error (Mbps)')
title(team_names{i})
grid on 
grid minor 
set(gca,'fontsize',16)
end

%%
figure
for i = 2 : length(team_names)
x1 = results_2_ap{i};
x2 = results_3_ap{i};
x3 = results_4_ap{i};
x4 = results_5_ap{i};
x5 = results_6_ap{i};
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); ...
    3*ones(length(x4), 1); 4*ones(length(x5), 1)];
subplot(1,3,i-1)
boxplot(x, g)
xlabel('N APs')
ylabel('Error (Mbps)')
title(team_names{i})
grid on 
grid minor 
set(gca,'fontsize',16)
end

%boxplot([results_2_sta{1}; results_3_sta{1}; results_4_sta{1}])