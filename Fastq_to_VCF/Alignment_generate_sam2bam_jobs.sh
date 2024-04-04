# Purpose : Generate jobs that convert sam alignments to bam alignments 
# How it works: Make a list of all our strain names (declare), then iterate through the list and make a .sh file for each
# script by echoing each line of the script to the .sh file 
# How to use : declare strain list, run in bash terminal
# More details here: http://www.htslib.org/doc/#manual-pages

#Generate script for each strain that will convert sam outputted from bowtie2 alignment to a bam, sort the bam, then call variants
declare -a strain_list=("Chemovar1" "Chemovar2" "Chemovar3" "Chemovar etc")

#Iterate through each strain in list of strains 
for strain in ${strain_list[@]}; do
    #Creates file
	touch sam_to_bam_$strain.sh 
	# shebang line
	echo "#!/bin/bash" >> sam_to_bam_$strain.sh
	# -bS specifies input (.sam == S) and output (.bam == b)
	echo "samtools view -bS $strain.sam > $strain.bam" >> sam_to_bam_$strain.sh #convert sam to bam
done

# Reference
# Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G., 
# Durbin, R., 1000 Genome Project Data Processing Subgroup, 2009. The Sequence Alignment/Map format and SAMtools. 
# Bioinforma. Oxf. Engl. 25, 2078–2079. https://doi.org/10.1093/bioinformatics/btp352
