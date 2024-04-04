# Purpose : Run our fastp filtering jobs
# How it works : iterates through list of fastp_$strain.sh files
# How to use : set the file names, run in bash term
# More details here: https://github.com/OpenGene/fastp

#!/bin/bash
# Step 1: Declare string array of filenames
declare -a fastp_files=("fastp_Chemovar1.sh" "fastp_Chemovar2.sh")
# In future, consider shopt/nullglob to build array from files in dir (https://stackoverflow.com/questions/10981439/reading-filenames-into-an-array?noredirect=1&lq=1)

# Step 2: Iterate through each fastp file in the list of fastp files, run the .sh file 
for file in "${fastp_files[@]}"; do
	bash $file
done


# Reference
# Chen, S., Zhou, Y., Chen, Y., Gu, J., 2018. fastp: an ultra-fast all-in-one FASTQ preprocessor. 
# Bioinformatics 34, i884–i890. https://doi.org/10.1093/bioinformatics/bty560