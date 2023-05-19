import pandas as pd

# Define path to input and output files
input_file = '1_brain_train.xlsx'
output_file = '1_brain_train.txt'
# input_file = '1_pelvis_train.xlsx'
# output_file = '1_pelvis_train.txt'

# Define column names to read from input file
columns_to_read = ['ID']

# Read input file using pandas
df = pd.read_excel(input_file, usecols=columns_to_read)

# Write selected columns to output file
with open(output_file, 'w') as f:
    for index, row in df.iterrows():
        f.write(str(row['ID']) + '\n')

