# Purpose : Subset vcf files to take the X snps with the highest minor allele frequencies (MAF).
# How it works : Works in conjunction with VCF_filtering_MAF.sh
# How to use : Follow the steps - do not just run this file.
# Notes : YMMV.
# More details here: https://pandas.pydata.org/docs/


# Start at VCF_filtering_MAF.sh
# Setup env
import pandas as pd

# data intake - mafScore.txt generated in VCF_filtering_MAF.sh
data = pd.read_csv('mafScore.txt', sep =' ', header=None, low_memory=False)
data.columns = ["ID", "MAF"]

# Check table
data.head(n=5)

# Sort by maf
dataSorted = data.sort_values('MAF', ascending=False)

# Check if sorted
dataSorted.head(n=5)

# If top few MAFs = ~0.5, success

# Now we will make some subsets with a few loops (using globals for this is apparently a garbage solution)
# Unused but could be useful for pipeline 
#for i in range(2, 12):
#    globals()["subset_" + str(i)] = dataSorted.head(n=i)

# Create our subsets - note that taking the top values from this sort is pretty arbitrary
# if you have many SNPs a MAF of 0.5
subset_5 = dataSorted.head(n=5)
subset_10 = dataSorted.head(n=10)
subset_100 = dataSorted.head(n=100)

# Print out subsets to .txt files
# Update your directory for output
# The SNP IDs in these text files will be cut out, then used with vcftools --snps to select our desired SNPs from the vcf
subset_5.to_csv(r'YOURDIRECTORY/subset5.txt', header=None, index=None, sep=' ', mode='a')
subset_10.to_csv(r'YOURDIRECTORY/subset10.txt', header=None, index=None, sep=' ', mode='a')
subset_100.to_csv(r'YOURDIRECTORY/subset100.txt', header=None, index=None, sep=' ', mode='a')

# Go back to VCF_filtering_MAF.sh

# References
# McKinney, W., 2010. Data Structures for Statistical Computing in Python. 
# Presented at the Python in Science Conference, Austin, Texas, pp. 56–61. https://doi.org/10.25080/Majora-92bf1922-00a