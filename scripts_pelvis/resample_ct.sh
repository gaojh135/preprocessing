# batch script -- CT-Pelvis 1*1*1
#!/bin/bash
# Run this in a OS with unix-based syntax

# Measure Elapsed time of the script:
START_TIME=$SECONDS

# Modify according to the location of your data
initial='../../Task1/pelvis/'
dirOut='../../Task1_resample/pelvis/'

#Prepare calculation of elapsed time for the script and logging
Now=`date`
script_name=$(basename $0)
echo -e $script_name $Now
echo -e $script_name $Now  >> ${dirOut}Logfile.txt


# Loop over patients and resample CT to 1x1x1
declare -a patients
readarray -t patients < ../txt/1_pelvis_train.txt

for patIndex in $(seq 0 $((${#patients[*]}-1)))
do
    patient=`echo ${patients[patIndex]} | awk '{print $1}'`
    
    # Define paths to input and output data
    patientnr=${patient:1}

    # Define path to temporary output directory
    TMP1=${initial}${patient}/
    TMP2=${dirOut}${patient}/
    mkdir -p $TMP2

    # Resample CT to 1x1x1
    echo "Resampling CT"
    python3 ../pre_process_tools.py resample --i ${TMP1}ct.nii.gz --o ${TMP2}ct_resampled.nii.gz --s 1 1 1
done

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo 'Time elapsed to prepare the data: ' $(($ELAPSED_TIME/60)) ' min' $(($ELAPSED_TIME%60)) ' s'
echo 'Time elapsed to prepare the data: ' $(($ELAPSED_TIME/60)) ' min' $(($ELAPSED_TIME%60)) ' s' >> ${dirOut}Logfile.txt