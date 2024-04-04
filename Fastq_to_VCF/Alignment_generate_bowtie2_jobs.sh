#!/bin/bash
# Purpose : Generate jobs that align trimmed and merged reads to alignment genome
# How it works: Make a list of all our strain names (declare), then iterate through the list and make a .sh file for each
# script by echoing each line of the script to the .sh file 
# How to use : declare strain list, modify bowtie criteria/allocations as needed, run in bash terminal
# More details here: https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml

# Step 1: Declare string array of strains
declare -a strain_list=("Chemovar1" "Chemovar2" "Chemovar3" "Chemovar etc")

# Step 2 : Iterate through each strain in list of strains, this will generate one "Alignment_$strain.sh" file per strain
for strain in ${strain_list[@]}; do
	#Creates file
	touch Alignment_$strain.sh 
	echo "#!/bin/bash" >> Alignment_$strain.sh 
	# adds job - cs10 is our reference genome
	echo bowtie2 -x cs10 -U $strain"_fastp_Merged.fastq.gz" -S $strain"_aligned.sam" >> Alignment_$strain.sh

done

# Reference
# Langmead, B., Salzberg, S.L., 2012. Fast gapped-read alignment with Bowtie 2. Nat. Methods 9, 357–359. https://doi.org/10.1038/nmeth.1923
# bowtie parameters
	# -p sets core count, -x sets prefix of the bowtie2 indexed reference genome 
	# -U (unpaired, which we use because we merged read tracks) specifies name of reads to align, -S specifies .sam out file name