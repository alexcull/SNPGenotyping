# Purpose : Generate jobs that sorts bam files
# How it works: Make a list of all our strain names (declare), then iterate through the list and make a .sh file 
# for each strain by echoing each line of the script to the .sh file
# How to use : declare strain list, tinker with allocation settings and naming of files if needed, 
# run in bash terminal
# More details here: http://www.htslib.org/doc/#manual-pages

#!/bin/bash
# Step 1: Generate script for each strain that will convert sam outputted from bowtie2 alignment to a bam, sort the bam, then call variants
declare -a strain_list=("Chemovar1" "Chemovar2" "Chemovar3" "Chemovar etc")

# Step 2: Iterate through each strain in list of strains 
for strain in ${strain_list[@]}; do
	#Creates file
	touch bam_sort_$strain.sh 
	echo "#!/bin/bash" >> bam_sort_$strain.sh
	# Sort -o specifies output file
    echo "samtools sort -o "$strain"_sorted.bam $strain.bam" >> bam_sort_$strain.sh 
done

# Reference
# Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G., 
# Durbin, R., 1000 Genome Project Data Processing Subgroup, 2009. The Sequence Alignment/Map format and SAMtools. 
# Bioinforma. Oxf. Engl. 25, 2078–2079. https://doi.org/10.1093/bioinformatics/btp352
