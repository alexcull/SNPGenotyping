# Purpose : Submit our variant call job files to our queue
# How it works : iterates through list of variantCall_$strain.sh files and submits them to queue
# How to use : set the strain names, run in bash term
# More details here: http://www.htslib.org/doc/#manual-pages

#!/bin/bash
# Step 1: Declare string array of strains
declare -a strain_list=("Chemovar1" "Chemovar2" "Chemovar3" "Chemovar etc")

# Step 2: Iterate through each strain in the list of strains, run the .sh file 
for strain in "${strain_list[@]}"; do
	bash "variantCall_"$strain.sh
done

# Reference
# Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G., 
# Durbin, R., 1000 Genome Project Data Processing Subgroup, 2009. The Sequence Alignment/Map format and SAMtools. 
# Bioinforma. Oxf. Engl. 25, 2078–2079. https://doi.org/10.1093/bioinformatics/btp352
