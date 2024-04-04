# Purpose : Take our raw VCFs and make them ready for analysis
# How it works : Merges VCFs, applies multiple filters.
# How to use : Follow the steps - do not just run this file.
# Notes : YMMV.
# More details here: bcftools - http://www.htslib.org/doc/#manual-pages
# vcftools : https://vcftools.github.io/examples.html 


# Step 1: Index each vcf.gz individually - loops and sorting before indexing causes problems
# eg 

bcftools index Chemovar1.vcf.gz

# Step 2: Make a merge list 

ls *.vcf.gz > mergeList.txt

# Step 3: Merge the files with bcftools merge

bcftools merge --file-list mergeList.txt --merge both --output-type v --output mergedVcf.vcf

# --threads arg is only called if we are doing any compression of the output stream
# --merge both so that both snp and indel records can be multiallelic
# O v specifies uncompressed vcf as the output + the output file name
# --file-list identifies reference file, one file per line

# Step 4: Sort - do not set any memory parameters, that will cause failure

bcftools sort -O v -o sortedVcf.vcf mergedVcf.vcf

# --o v  sets the output type vcf
# --output-file determines output files

# Step 5: Normalize - will be required downstream

bcftools norm -m -any sortedVcf.vcf -Ov > normalizedVcf.vcf

# -m split multiallelic to biallelic
# -any splits all types of variants
# -Ov output vcf
# > normVcf.vcf cat to our new file 
# Outputs a one line overview of what happened to console
# output: Lines   total/split/realigned/skipped:  15357974/244517/0/0

# Step 6: Get allele frequency
  # Step 6.1: Check AF tags (there shouldn't be any yet)

    tail -n 3 normalizedVcf.vcf 

  # Step 6.2: Add AF tags
    bcftools +fill-tags normalizedVcf.vcf  -- -t AF > afNorm.vcf
  # Step 6.3: Check AF tags (should be there in INFO field)
    tail -n 3 afNorm.vcf 

# Step 7: Add other tags

bcftools +fill-tags afNorm.vcf > taggedNorm.vcf

# Step 8:  Check all tags (should be there in INFO field)

tail -n 3 taggedNorm.vcf 

# Step 9: Apply Filters
# Step 9.1: Create filter script
  nano filterScript.sh

# here are the parameters I used, detailed below
vcftools --vcf taggedNorm.vcf \
--remove-indels \
--max-missing 0.2 \
--maf 0.05 \
--min-alleles 2 --max-alleles 2 \
--remove-filtered-all \
--recode --recode-INFO-all \
--stdout \
> filter1Snp.vcf

# Step 9.2 : Run filter script

bash filterScript.sh

# Summary of filtering 
cat out.log 
# Example output
#VCFtools - 0.1.16
#(C) Adam Auton and Anthony Marcketta 2009

#Parameters as interpreted:
#        --vcf taggedNorm.vcf
#        --recode-INFO-all
#        --maf 0.05
#        --max-alleles 2
#        --min-alleles 2
#        --max-missing 0.2
#        --recode
#        --remove-filtered-all
#        --remove-indels
#        --stdout
#
#Warning: Expected at least 2 parts in INFO entry: ID=AC,Number=A,Type=Integer,Description="Allele count in genotypes for each ALT allele, in the same order as listed">
#Warning: Expected at least 2 parts in INFO entry: ID=DP4,Number=4,Type=Integer,Description="Number of high-quality ref-forward , ref-reverse, alt-forward and alt-reverse bases">
#Warning: Expected at least 2 parts in INFO entry: ID=DP4,Number=4,Type=Integer,Description="Number of high-quality ref-forward , ref-reverse, alt-forward and alt-reverse bases">
#After filtering, kept 32 out of 32 Individuals
#Outputting VCF file...
#After filtering, kept 5219894 out of a possible 15604377 Sites
#Run Time = 589.00 seconds

# Step 10: create and run scripts to identify positions to be excluded

# Step 10.1: Calculate heterozigosity (VCF_filtering_heterozigosity_assignment.sh)

# The script - thank you kind biostars contributors
nano VCF_filtering_heterozigosity_assignment.sh

  paste <(bcftools view filter1Snps.vcf |\
      awk -F"\t" 'BEGIN {print "CHR\tPOS\tID\tREF\tALT"} \
        !/^#/ {print $1"\t"$2"\t"$3"\t"$4"\t"$5}') \
      \
    <(bcftools query -f '[\t%SAMPLE=%GT]\n' filter1Snps.vcf |\
      awk 'BEGIN {print "nHet"} {print gsub(/0\|1|1\|0|0\/1|1\/0/, "")}') 

# This will give us a tab-sep file with format 
# CHROM POS ID REF ALT nHet
# Where nHet is the count of heterozygous genotypes for a set position
# We run the script and save the output in heterozigosityData.txt
bash VCF_filtering_heterozigosity_assignment.sh > heterozigosityData.txt

# Step 10.2: Filter based on heterozygosity

# First we determine the numerator required for a 60% heterozigosity (our cutoff)
# In this case - 60% of 32 chemovars ~= 19
# We create another filter script to get only those with a heterozygote count (nHet) of 19 or greater,

nano hetFilter.sh
  #START
  #!/bin/bash
  awk -F '\t' '{ if ($6 >= 19) {print} }' het_count.txt > fail_het.txt
  #END
# Run filter - this will output the list of SNPs with >60% heterozygosity
bash hetFilter.sh

# Step 10.3: Save filtering results

# Here we keep only the CHROM and POS values
cut -f 1,2 fail_het.txt > chromPos.txt

# With chromPos.txt, we know what positions to filter out using vcftools' filter by position

# Step 11: Second round of filters
# We create the filtering script
nano vcftoolsFilter2.sh
  #!/bin/bash
  vcftools --vcf filter1Snp.vcf --exclude-positions chromPos.txt --recode --recode-INFO-all \
  --out Snp

# output
#
#VCFtools - 0.1.16
#(C) Adam Auton and Anthony Marcketta 2009

#Parameters as interpreted:
#        --vcf filter1Snps.vcf
#        --exclude-positions chromPos.txt
#        --recode-INFO-all
#        --out filter2Snp
#        --recode

#Warning: Expected at least 2 parts in INFO entry: ID=AC,Number=A,Type=Integer,Description="Allele count in genotypes for each ALT allele, in the same order as listed">
#Warning: Expected at least 2 parts in INFO entry: ID=DP4,Number=4,Type=Integer,Description="Number of high-quality ref-forward , ref-reverse, alt-forward and alt-reverse bases">
#Warning: Expected at least 2 parts in INFO entry: ID=DP4,Number=4,Type=Integer,Description="Number of high-quality ref-forward , ref-reverse, alt-forward and alt-reverse bases">
#After filtering, kept 32 out of 32 Individuals
#Outputting VCF file...
#After filtering, kept 5101489 out of a possible 5219894 Sites
#Run Time = 484.00 seconds

# Step 12: Check filter outputs
# Extra step - Rename file for sanity
mv Snp.recode.vcf Snp.vcf

# Check success with line count and checking to see if the first

awk -F '\t' '/15565/' filter1Snp.vcf # Replace number with first position in chromPOS.txt
awk -F '\t' '/15565/' Snp.vcf

# Unorthodox approach, but quickly interrupt with ctrl+C and check the first result from both awks
# Should be easy to find at the top of the first awk
# Will likely have plenty of results from second awk, but there should not be that position at first chromosome 

# Otherwise try wc -l to check line counts
wc -l chromPos.txt # x
wc -l filter1Snp.vcf # y
wc -l Snp.vcf # z
# y - x =~ z

# Step 13: Add snp IDs to make downstream filtering easier

bcftools annotate --set-id '%CHROM\_%POS\_%REF\_%ALT' Snp.vcf > Snp1.vcf

# Rename for sanity
rm Snp.vcf
mv Snp1.vcf Snp.vcf

# Step 14: missingness and depth filters
# Parameters
# --max-missing : Exclude sites on the basis of the proportion of missing data (defined to be between 0 and 1,
# where 0 allows sites that are completely missing and 1 indicates no missing data allowed).
# --min-meanDP : includes only sites with mean depth values (over all included individuals)  
# >="--min-meanDP" value. 20-30x is fine, 33x is what we used


# No missingness, 33x mean depth required
vcftools --vcf Snp.vcf \
--max-missing 1.0 \
--min-meanDP 33\
--remove-filtered-all \
--recode --recode-INFO-all \
--stdout \
> snpNoMiss.vcf

# Output 
# After filtering, kept 3715 out of a possible 5101489 Sites


# up to 20% missingness, 33x mean depth required
vcftools --vcf Snp.vcf \
--max-missing 0.8 \
--min-meanDP 33\
--remove-filtered-all \
--recode --recode-INFO-all \
--stdout \
> snpMiss.vcf
# Output 
# After filtering, kept 14140 out of a possible 5101489 Sites

# References
# Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G., 
# Durbin, R., 1000 Genome Project Data Processing Subgroup, 2009. The Sequence Alignment/Map format and SAMtools. 
# Bioinforma. Oxf. Engl. 25, 2078–2079. https://doi.org/10.1093/bioinformatics/btp352

# Danecek, P., Auton, A., Abecasis, G., Albers, C.A., Banks, E., DePristo, M.A., Handsaker, R.E., 
# Lunter, G., Marth, G.T., Sherry, S.T., McVean, G., Durbin, R., 1000 Genomes Project Analysis Group, 2011. 
# The variant call format and VCFtools. Bioinformatics 27, 2156–2158. https://doi.org/10.1093/bioinformatics/btr330

