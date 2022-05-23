%function convert_simulator_to_sfctmn_files(folder_path)

folder_path = 'simulator_input_files_test';

cd(folder_path)
files_dir = dir('*.csv');
num_files = length(files_dir);
for k = 1 : num_files
   file_name = files_dir(k).name;
   input_data = readtable(file_name);
   rows = [];
   for j = 1 : height(input_data)
       if input_data(j,:).node_type == 0
           code = j;
           primary = input_data(j,:).primary_channel+1;
           left = primary+1;
           right = primary+1;
           tx_power = TX_POWER_MAX;
           cca = CCA_DEFAULT;
           lambda = 9999;
           x_ap = input_data(j,:).x_m_;
           y_ap = input_data(j,:).y_m_;
           z_ap = input_data(j,:).z_m_;
           % Consider the closest STA (optimistic case)
           found_next_ap = 0;
           cnt = 1;
           minD = 100;
           while ~found_next_ap
               if input_data(j,:).node_type == 0
                   found_next_ap = 1;
               elseif input_data(j,:).node_type == 1
                   x = input_data(j+cnt,:).x_m_;
                   y = input_data(j+cnt,:).y_m_;
                   z = input_data(j+cnt,:).z_m_;
                   dist = sqrt((x_ap-x)^2 + (y_ap-y)^2 + (z_ap-z)^2);  
                   if d < minD
                       x_sta = x;
                       y_sta = y;
                       z_sta = z;
                   end
               end  
           end        
           legacy = 0;
           cw = input_data(j,:).cont_wind;
           non_srg_id = input_data(j,:).bss_color;
           srg_id = 0;
           non_srg_pd = input_data(j,:).non_srg_obss_pd;
           srg_pd = -82;
           tx_pw_ref = 21;
           coord = 0;
           new_row = [code primary right left tx_power cca lambda x_ap y_ap z_ap...
               x_sta y_sta z_sta legacy cw non_srg_id srg_id non_srg_pd srg_pd tx_pw_ref coord];
           rows = [rows; new_row];
       end
   end
   writematrix(rows,['../converted_sim_input_files_test/' file_name],'Delimiter',';')
end
cd ..
