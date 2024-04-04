#!/bin/bash

# Purpose : First step to get heterozigosity rate per variant - this gives us the count per variant
# How it works : counts occurence of heterozygous genotypes (1/0, 1|0, 0/1, 0|1) in GT field per variant, 
# outputs to a txt file. 
# How to use : Modify file name (currently set as snpsFile.vcf) as needed (file name called twice), modify gsub if multiallelic, run in bash term
# More details here: http://www.htslib.org/doc/#manual-pages


paste <(bcftools view snpsFile.vcf |\
    awk -F"\t" 'BEGIN {print "CHR\tPOS\tID\tREF\tALT"} \
      !/^#/ {print $1"\t"$2"\t"$3"\t"$4"\t"$5}') \
    \
  <(bcftools query -f '[\t%SAMPLE=%GT]\n' snpsFile.vcf |\
    awk 'BEGIN {print "nHet"} {print gsub(/0\|1|1\|0|0\/1|1\/0/, "")}')


# Reference
# Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G., 
# Durbin, R., 1000 Genome Project Data Processing Subgroup, 2009. The Sequence Alignment/Map format and SAMtools. 
# Bioinforma. Oxf. Engl. 25, 2078–2079. https://doi.org/10.1093/bioinformatics/btp352

