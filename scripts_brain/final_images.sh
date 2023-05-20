#!/bin/bash
# Run this in a OS with unix-based syntax

# Measure Elapsed time of the script:
START_TIME=$SECONDS

# Modify according to the location of your data
initial1='../../Task1_resample/brain/'
initial2='../../Task1_mask_MR_corrected/brain/'
initial3='../../Task1_mr_T1_registered/brain/'
initial4='../../Task1_mask_MR/brain/'
dirOut='../../Task1_final_images/brain/'

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
    TMP3=${dirOut}ct_crop/${patient}/
    TMP4=${initial3}${patient}/
    TMP5=${dirOut}mr_crop/${patient}/
    TMP6=${initial4}${patient}/
    TMP7=${dirOut}mask_crop/${patient}/
    mkdir -p $TMP3
    mkdir -p $TMP5
    mkdir -p $TMP7

    # These three are the final images that are provided for each patient
    # Mask MRI and resampled to cropped FOV
    python3 ../pre_process_tools.py crop --i ${TMP1}ct_resampled.nii.gz --mask_crop ${TMP2}mask_MR_corrected.nii.gz --o ${TMP3}ct_crop.nii.gz #--mask_value -1000
    python3 ../pre_process_tools.py crop --i ${TMP4}mr_T1_registered.nii.gz --mask_crop ${TMP2}mask_MR_corrected.nii.gz --o ${TMP5}mr_crop.nii.gz #--mask_value 0
    python3 ../pre_process_tools.py crop --i ${TMP6}mask_MR.nii.gz --mask_crop ${TMP2}mask_MR_corrected.nii.gz --o ${TMP7}mask_crop.nii.gz #--mask_value 0
done

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo 'Time elapsed to prepare the data: ' $(($ELAPSED_TIME/60)) ' min' $(($ELAPSED_TIME%60)) ' s'
echo 'Time elapsed to prepare the data: ' $(($ELAPSED_TIME/60)) ' min' $(($ELAPSED_TIME%60)) ' s' >> ${dirOut}Logfile.txt