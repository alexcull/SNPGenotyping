#!/bin/bash
# Purpose : Remove snps with moderate LD to avoid biases caused by LD in downstream analysis
# How it works : bcftools has a plugin <prune> that will allow us to set an LD threshold
# More details here: http://www.htslib.org/doc/#manual-pages

# Step 1 : Specify plugin location
export BCFTOOLS_PLUGINS='PLUGIN LOCATION'

# Step 2 : Change senstivity and/or window size (--max-LD and -w)
bcftools +prune --max-LD 0.5 snpMiss.vcf -Ov -o miss.vcf

# -Ov : output type - b for .bam.gz, u for .bam, v for vcf, z for vcf.gz 
# -o : output file name

# Done

# References
# Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G., 
# Durbin, R., 1000 Genome Project Data Processing Subgroup, 2009. The Sequence Alignment/Map format and SAMtools. 
# Bioinforma. Oxf. Engl. 25, 2078–2079. https://doi.org/10.1093/bioinformatics/btp352
