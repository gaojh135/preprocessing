#!/bin/bash
# Run this in a OS with unix-based syntax

# Measure Elapsed time of the script:
START_TIME=$SECONDS

# Modify according to the location of your data
initial1='../../Task1/brain/'
initial2='../../Task1_resample/brain/'
initial3='../../Task1_mask_MR/brain/'
dirOut='../../Task1_mask_MR_corrected/brain/'

#Prepare calculation of elapsed time for the script and logging
Now=`date`
script_name=$(basename $0)
echo -e $script_name $Now
echo -e $script_name $Now  >> ${dirOut}Logfile.txt

# Loop over patients and resample CT to 1x1x1
declare -a patients
readarray -t patients < ../txt/1_brain_train.txt

for patIndex in $(seq 0 $((${#patients[*]}-1)))
do
    patient=`echo ${patients[patIndex]} | awk '{print $1}'`

    # Define paths to input and output data
    patientnr=${patient:1}

    # Define path to temporary output directory
    TMP1=${initial1}${patient}/
    TMP2=${initial2}${patient}/
    TMP3=${initial3}${patient}/
    TMP4=${dirOut}${patient}/
    mkdir -p $TMP4

    #Correct FOV
    python3 ../pre_process_tools.py correct --i ${TMP1}mr.nii.gz --ii ${TMP2}ct_resampled.nii.gz \
    --f ../param_files/registration_parameters_brain.txt --mask_crop ${TMP3}mask_MR.nii.gz --o ${TMP4}mask_MR_corrected.nii.gz
done

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo 'Time elapsed to prepare the data: ' $(($ELAPSED_TIME/60)) ' min' $(($ELAPSED_TIME%60)) ' s'
echo 'Time elapsed to prepare the data: ' $(($ELAPSED_TIME/60)) ' min' $(($ELAPSED_TIME%60)) ' s' >> ${dirOut}Logfile.txt