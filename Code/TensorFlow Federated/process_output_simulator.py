############################################
# File used to read the .txt files generated
# with the Komondor simulator and convert
# data into a readable .csv file
# (to be processed by ML models)
############################################

# IMPORTANT: the dataset may contain nan and inf values that need to be removed

import pandas as pd
import numpy as np
import math

# Set the file to be read
scenario_id = "sce1"
path_file = "./simulator_output/output_11ax_sr_simulations_" + scenario_id + ".txt"

# Define a dataframe object to store the dataset
df = pd.DataFrame(columns=['context', 'obss_pd', 'throughput', 'interference', 'rssi', 'sinr'])

# Read the .txt file (simulator output)
index_table = 0
header_text = "KOMONDOR"  # Text to identify the header of each simulation
with open(path_file, 'r', encoding="utf8", errors='ignore') as reader:
    line = reader.readline()  # Read the first line
    while line != '':  # The EOF char is an empty string
        # print(line)
        if header_text in line:
            # Parse the header line to get the context id
            split1 = line.split("_")
            split2 = split1[3].split("s")
            context_id = int(split2[1])
            # Parse the header line to get the OBSS/PD threshold
            split3 = split1[4].split("c")
            split4 = split3[1].split(".")
            obss_pd = int(split4[0])
            # New line to be appended to the table
            new_line = dict()
            new_line['context'] = context_id
            new_line['obss_pd'] = obss_pd / -62
            index_table += 1
            # Line counter to keep track of each feature/label
            line_counter = 0
        else:
            line = line.replace('\n', '')
            if line_counter == 0:
                arr = line.split(',')
                for i in range(0, len(arr)):
                    arr[i] = float(arr[i])
                # print('Mean tpt ' + str(np.mean(arr)))
                new_line['throughput'] = np.mean(arr)
            elif line_counter == 1:
                arr = line.split(',')
                for i in range(0, len(arr)):
                    arr[i] = float(arr[i])
                    if math.isinf(arr[i]):
                        arr[i] = 5
                    else:
                        arr[i] = arr[i] / -50
                new_line['interference'] = np.mean(arr)
            elif line_counter == 2:
                arr = line.split(',')
                for i in range(0, len(arr)):
                    arr[i] = float(arr[i]) / -30
                new_line['rssi'] = np.mean(arr)
            elif line_counter == 3:
                arr = line.split(',')
                for i in range(0, len(arr)):
                    arr[i] = float(arr[i])
                    if math.isnan(arr[i]):
                        arr[i] = 0.0
                    else:
                        arr[i] = arr[i] / 30
                new_line['sinr'] = np.mean(arr)

            line_counter += 1

        # Append a row to the dataframe
        if line_counter == 4:
            df = df.append(new_line, ignore_index=True)

        # Read the next line
        line = reader.readline()

# Save the dataframe object to a .csv file
print(df.head())
df.to_csv('./simulator_output/processed_outputs/processed_output_' + scenario_id + '_norm.csv', sep=';')
