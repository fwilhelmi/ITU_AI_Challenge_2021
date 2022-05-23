close all
clear all
clc

%%
disp('Processing the baseline predictions (SFCTMN) ...')

% Path to folders containing output and input files
output_path = ['output_simulator_2021/output_11ax_sr_simulations_test.txt'];
predictions_path = 'baseline_sfctmn/output_test/';

team_name = 'baseline';

% Get predictions into an array
cd(predictions_path)
files_dir = dir('*.mat');
num_files = length(files_dir);
cd ..
cd ..
pred = [];
for k = 1 : num_files
    file_name = files_dir(k).name;
    load(file_name)
    pred = [pred; throughput(1)];
end

%%
% Convert the content of each file to an array 
data_output = fopen(output_path);
A = textscan(data_output,'%s','Delimiter',';');
% Iterate for each subscenario
err = [];
counter = 1;
for i = 1 : length(A{1})
    if counter < length(pred)
        % Read scenario id
        line_val = A{1}(i);
        if contains(line_val,'KOMONDOR')   
            row = 1;
        else
            if (row == 1) % per-STA throughput
                split1 = strsplit(line_val{1},',');
                val = str2double(split1);  
                err = [err; sum(val)-pred(counter)];
                counter = counter + 1;
            end
            row = row + 1;
        end
    end
end
fclose(data_output);
fclose('all');

%% Plot the results
figure
histogram(abs(err))
ylabel('# counts')
xlabel('Error (Mbps)')
set(gca,'fontsize',16)
grid on
grid minor

figure
cdfplot(abs(err))
ylabel('CDF')
xlabel('Error (Mbps)')
set(gca,'fontsize',16)
grid on
grid minor

disp(['Average error: ' num2str(mean(abs(err))) ' Mbps'])
output_filename = ['error_' num2str(team_name) '.mat'];
save(output_filename, 'err')

% if SUBMISSION_MODE == 1 || SUBMISSION_MODE == 2 || SUBMISSION_MODE == 3
%     
%     figure
%     histogram(abs(persta_err))
%     ylabel('# counts (per-STA)')
%     xlabel('Per-STA Error (Mbps)')
%     set(gca,'fontsize',16)
%     grid on
%     grid minor
% 
%     figure
%     cdfplot(abs(persta_err))
%     ylabel('CDF (per-STA)')
%     xlabel('Per-STA Error (Mbps)')
%     set(gca,'fontsize',16)
%     grid on
%     grid minor
% 
%     disp(['Average per-STA error: ' num2str(mean(abs(persta_err))) ' Mbps'])
%     output_filename = ['persta_err_' num2str(team_name) '.mat'];
%     save(output_filename, 'persta_err')
% 
% end