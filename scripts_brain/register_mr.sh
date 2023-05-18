# Register MR-Brain batch script
#!/bin/bash
# Run this in a OS with unix-based syntax

# Measure Elapsed time of the script:
START_TIME=$SECONDS

# Modify according to the location of your data
initial1='../../Task1/brain/'
initial2='../../Task1_resample/brain/'
dirOut='../../Task1_mr_T1_registered/brain/'

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
    TMP3=${dirOut}${patient}/
    mkdir -p $TMP3

    # Register MRI to CT according to the parameter file specified
    echo "Registering..."
    python3 ../pre_process_tools.py register --f ${TMP2}ct_resampled.nii.gz --m ${TMP1}mr.nii.gz --o ${TMP3}mr_T1_registered.nii.gz --p ../param_files/parameters_MR.txt
done

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo 'Time elapsed to prepare the data: ' $(($ELAPSED_TIME/60)) ' min' $(($ELAPSED_TIME%60)) ' s'
echo 'Time elapsed to prepare the data: ' $(($ELAPSED_TIME/60)) ' min' $(($ELAPSED_TIME%60)) ' s' >> ${dirOut}Logfile.txt