# Purpose : Submit our alignment files to our job queue
# How it works : iterates through list of alignment$strain.sh files and submits them to queue
# How to use : set the strain names, run in bash term
# More details here: https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml

#!/bin/bash
# Step 1: Declare string array of strains
declare -a strain_list=("Chemovar1" "Chemovar2" "Chemovar3" "Chemovar etc")

# Step 2: Iterate through each strain in the list of strains, run the .sh file 
for file in "${strain_list[@]}"; do
	bash "Alignment_"$file.sh
done

# Reference
# Langmead, B., Salzberg, S.L., 2012. Fast gapped-read alignment with Bowtie 2. Nat. Methods 9, 357–359. https://doi.org/10.1038/nmeth.1923

# bowtie parameters
	# -p sets core count, -x sets prefix of the bowtie2 indexed reference genome 
	# -U (unpaired, which we use because we merged read tracks) specifies name of reads to align, -S specifies .sam out file name