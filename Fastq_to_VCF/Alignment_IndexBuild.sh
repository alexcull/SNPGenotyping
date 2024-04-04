# Purpose : Index reference genome before bowtie2 alignment
# How it works : Builds an indexed version of the refgenome.fasta to be used in alignment
# How to use : update ref genome + prefix, run 
# More details here: https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml


# Step 1: Use bowtie2 to build
#  first arg is the reference genome, second is the prefix for the outputted index files
#  
bowtie2-build cs10.fasta cs10


# Reference
# Langmead, B., Salzberg, S.L., 2012. Fast gapped-read alignment with Bowtie 2. Nat. Methods 9, 357–359. https://doi.org/10.1038/nmeth.1923


