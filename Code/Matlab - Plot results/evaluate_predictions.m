close all
clear all
clc

%%
disp('Processing the test dataset ...')

% Path to folders containing output and input files
output_path = ['output_simulator_2021/output_11ax_sr_simulations_test.txt'];
predictions_path = 'predictions_participants/';
team_name = 'fedipc';

SUBMISSION_MODE = 3; % 0: average tpt / 1: per-STA tpt / 2: per-STA tpt original format

% predictions - 0
% FederationS - 1
% WirelessAI - 2
% fedipc - 3

% Get predictions into an array
file_path = [predictions_path team_name '.txt'];
if SUBMISSION_MODE == 0 || SUBMISSION_MODE == 3
    predictions = fopen(file_path);
    A = textscan(predictions,'%s');
    pred = str2double(A{:}); 
elseif SUBMISSION_MODE == 1
    fid = fopen(file_path);
    lines = {};
    tline = fgetl(fid);
    while ischar(tline)
        lines{end+1,1} = tline;
        tline = fgetl(fid);
    end
    fclose(fid);
elseif SUBMISSION_MODE == 2
    % do nothing
end

%%
if SUBMISSION_MODE == 0
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
                    err = [err; mean(val)-pred(counter)];
                    counter = counter + 1;
                end
                row = row + 1;
            end
        end
    end
    fclose(data_output);
    fclose('all');
elseif SUBMISSION_MODE == 1
    % Convert the content of each file to an array 
    data_output = fopen(output_path);
    A = textscan(data_output,'%s','Delimiter',';');
    % Iterate for each subscenario
    err = [];
    persta_err = [];
    counter = 1;
    for i = 1 : length(A{1})
        if counter <= length(lines)
            % Read scenario id
            line_val = A{1}(i);
            if contains(line_val,'KOMONDOR')   
                row = 1;
            else
                if (row == 1) % per-STA throughput
                    split1 = strsplit(line_val{1},',');
                    val = str2double(split1);
                    split2 = strsplit(lines{counter},',');
                    pred = str2double(split2);
                    err = [err; mean(val)-mean(pred)];
                    persta_err = [persta_err val-pred];
                    counter = counter + 1;
                end
                row = row + 1;
            end
        end
    end
    fclose(data_output);
    fclose('all');
elseif SUBMISSION_MODE == 2
    % Convert the content of each file to an array 
    data_output = fopen(output_path);
    A = textscan(data_output,'%s','Delimiter',';');
    data_prediction = fopen(file_path);
    B = textscan(data_prediction,'%s','Delimiter',';');
    % Iterate for each subscenario
    err = [];
    persta_err = [];
    counter = 1;
    for i = 1 : length(A{1})
%         if counter < length(lines)
            % Read scenario id
            line_val = A{1}(i);
            line_val2 = B{1}(i);
            if contains(line_val,'KOMONDOR')   
                row = 1;
            else
                if (row == 1) % per-STA throughput
                    split1 = strsplit(line_val{1},',');
                    val = str2double(split1);
                    split2 = strsplit(line_val2{1},',');
                    pred = str2double(split2);
                    err = [err; mean(val)-mean(pred)];
                    persta_err = [persta_err val-pred];
%                     counter = counter + 1;
                end
                row = row + 1;
            end
%         end
    end
    fclose(data_output);
    fclose('all');
elseif SUBMISSION_MODE == 3
    % Convert the content of each file to an array 
    data_output = fopen(output_path);
    A = textscan(data_output,'%s','Delimiter',';');
    % Iterate for each subscenario
    err = [];
    persta_err = [];
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
                    err = [err; mean(val)-mean(pred(counter:counter+length(val)-1))];
                    persta_err = [persta_err val-pred(counter:counter+length(val)-1)'];
                    counter = counter + length(val);
                end
                row = row + 1;
            end
        end
    end
    fclose(data_output);
    fclose('all');
end

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

if SUBMISSION_MODE == 1 || SUBMISSION_MODE == 2 || SUBMISSION_MODE == 3
    
    figure
    histogram(abs(persta_err))
    ylabel('# counts (per-STA)')
    xlabel('Per-STA Error (Mbps)')
    set(gca,'fontsize',16)
    grid on
    grid minor

    figure
    cdfplot(abs(persta_err))
    ylabel('CDF (per-STA)')
    xlabel('Per-STA Error (Mbps)')
    set(gca,'fontsize',16)
    grid on
    grid minor

    disp(['Average per-STA error: ' num2str(mean(abs(persta_err))) ' Mbps'])
    output_filename = ['persta_err_' num2str(team_name) '.mat'];
    save(output_filename, 'persta_err')

end