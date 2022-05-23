clear 
clc

%% Generate the data
% Generate constants 
constants_sfctmn_framework
% Set specific configurations
configuration_system       

% Generate wlans object according to the input file
folder_path = 'input_files_ai_challenge';

%% Compute the throughput with the SFCTMN framework
cd(folder_path)
files_dir = dir('*.csv');
num_files = length(files_dir);
cd ..
for k = 1 : num_files
   file_name = files_dir(k).name;
    % Generate the WLAN
    wlans = generate_wlan_from_file([folder_path '/' file_name], false, false, 1, [], []);
    % Call the SFCTMN framework
    [throughput] = function_main_sfctmn(wlans);    
    % Save the throughput
    save(['./output_test/throughput_' file_name '.mat'],'throughput')
end
