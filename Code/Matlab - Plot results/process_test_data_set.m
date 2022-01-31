close all
clear all
clc

disp('Processing the test dataset ...')

% Path to folders containing output and input files
output_path = ['output_simulator_2021/output_11ax_sr_simulations_test.txt'];

% Convert the content of each file to an array 
data_output = fopen(output_path);
A = textscan(data_output,'%s','Delimiter',';');
B = str2double(A{:});

% Iterate for each subscenario
str = [];
for i = 1 : length(A{1})    
    % Read scenario id
    line = A{1}(i);
    if contains(line,'KOMONDOR')   
        row = 1;
        str = [str; line];
    else
        if (row == 1) % per-STA throughput
            str = [str; num2str(0)];
        elseif (row == 2) % AP interference
            str = [str; line];
        elseif (row == 3) % per-STA RSSI
            str = [str; line];
        elseif (row == 4) % per-STA SINR
            str = [str; line];
        end
        row = row + 1;
    end
end
fclose(data_output);
fclose('all');

% Save as a text file
fid2 = fopen('test_dataset.txt','w');
fprintf(fid2,'%s\n', str{:});
fclose(fid2);