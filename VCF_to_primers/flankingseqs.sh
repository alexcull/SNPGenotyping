# Objective  : find flanking sequences of our target snps
# Prerequisite: generate a .bed file using targeted SNP position data - example included (snps.bed)
# More info: https://bedtools.readthedocs.io/en/latest/


# Step 1: Get flanking sequence using bedtools 
# bedtools automatically indexes .fasta if required

bedtools getfasta -fo snpFlanks.fasta -fi cs10.fasta -bed snps.bed

# References
# Quinlan, A.R., Hall, I.M., 2010. BEDTools: a flexible suite of utilities for comparing genomic features. 
# Bioinformatics 26, 841–842. https://doi.org/10.1093/bioinformatics/btq033