# Purpose : Subset vcf files to take the X snps with the highest minor allele frequencies (MAF).
# How it works : Works in conjunction with VCF_Filtering_MAF.py
# How to use : Follow the steps - do not just run this file.
# Notes : YMMV.
# More details here: bcftools - http://www.htslib.org/doc/#manual-pages
# vcftools : https://vcftools.github.io/examples.html 

# Step 1: extract MAF scores from VCF
bcftools query -f '%ID %MAF\n' SNPfile.vcf> mafScores.txt
# Step 2: Go to VCF_Filtering_MAF.py
# We use pandas to output a bunch of subsetXX.txt files to use for vcftools filter by position
# To do this, gotta cut the first two columns, then feed that text file to vcftools filter

# Step 4: Welcome back
# Step 5: Get the SNP IDs from our sorted SNP subsets
cut -d" " -f 1 subset5.txt > filterSubset5.txt
cut -d" " -f 1 subset10.txt > filterSubset10.txt
cut -d" " -f 1 subset100.txt > filterSubset100.txt

# Step 6: Selects snps by snp ID to generate our new subsetted vcfs
vcftools --vcf snpMiss.vcf --snps filterSubset5.txt --recode --recode-INFO-all --out 5
vcftools --vcf snpMiss.vcf --snps filterSubset10.txt --recode --recode-INFO-all --out 10
vcftools --vcf snpMiss.vcf --snps filterSubset100.txt --recode --recode-INFO-all --out 100

# Rename for my sanity
mv 5.recode.vcf five.vcf
mv 10.recode.vcf ten.vcf
mv 100.recode.vcf hundred.vcf


# References
# Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G., 
# Durbin, R., 1000 Genome Project Data Processing Subgroup, 2009. The Sequence Alignment/Map format and SAMtools. 
# Bioinforma. Oxf. Engl. 25, 2078–2079. https://doi.org/10.1093/bioinformatics/btp352

# Danecek, P., Auton, A., Abecasis, G., Albers, C.A., Banks, E., DePristo, M.A., Handsaker, R.E., 
# Lunter, G., Marth, G.T., Sherry, S.T., McVean, G., Durbin, R., 1000 Genomes Project Analysis Group, 2011. 
# The variant call format and VCFtools. Bioinformatics 27, 2156–2158. https://doi.org/10.1093/bioinformatics/btr330
