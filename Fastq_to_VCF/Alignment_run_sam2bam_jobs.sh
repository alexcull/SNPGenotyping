#!/bin/bash

# Purpose : Submit our conversion files to our queue
# How it works : iterates through list of sam_to_bam$strain.sh files and submits them to queue
# How to use : set the strain names, run in bash term
# More details here: http://www.htslib.org/doc/#manual-pages


declare -a strain_list=("Chemovar1" "Chemovar2" "Chemovar3" "Chemovar etc")

for strain in "${strain_list[@]}"; do
	bash sam_to_bam_$strain.sh
done

# Reference
# Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G., 
# Durbin, R., 1000 Genome Project Data Processing Subgroup, 2009. The Sequence Alignment/Map format and SAMtools. 
# Bioinforma. Oxf. Engl. 25, 2078–2079. https://doi.org/10.1093/bioinformatics/btp352
