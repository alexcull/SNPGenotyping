# Purpose : Index cs10 reference genome to be used for sorting 
# How it works: run command
# More details here: http://www.htslib.org/doc/#manual-pages


# Step 1 : Index genome 
samtools faidx cs10.fasta

# Reference
# Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G., 
# Durbin, R., 1000 Genome Project Data Processing Subgroup, 2009. The Sequence Alignment/Map format and SAMtools. 
# Bioinforma. Oxf. Engl. 25, 2078–2079. https://doi.org/10.1093/bioinformatics/btp352
