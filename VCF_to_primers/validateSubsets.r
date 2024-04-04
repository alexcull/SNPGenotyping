# Purpose : generate a genetic distance matrix from different sized sets of snp, 
# and check to see if each set can differentiate between all strains

# Install dependencies ----
BiocManager::install("gdsfmt")
BiocManager::install("SNPRelate")
BiocManager::install("ade4")
BiocManager::install("vcfR")
BiocManager::install("ncf")
library(gdsfmt)
library(SNPRelate)
library(vcfR)
library(ade4)
library(ncf)

# Loading data ----
# check and set wd
getwd()
setwd("GitHub/MastersData/subsetCreation/")
list.files()

# Load Vcfs - subsets generated as described in VCF_filtering_MAF.sh
missVcf <- "miss.vcf"
vcf4 <- "four.vcf"
vcf5 <- "five.vcf"
vcf6 <- "six.vcf"
vcf7 <- "sev.vcf"
vcf8 <- "oct.vcf"
vcf9 <- "nine.vcf"
vcf10 <- "ten.vcf"
vcf11 <- "elev.vcf"
vcf50 <- "C:/Users/aj_cu/Documents/GitHub/MastersData/subsetCreation/50.vcf"
vcf100 <- "C:/Users/aj_cu/Documents/GitHub/MastersData/subsetCreation/100.vcf"


# Convert to GDS, the format we need to work with
snpgdsVCF2GDS(missVcf, "miss.gds", method = "biallelic.only")
snpgdsVCF2GDS(vcf4, "4.gds", method = "biallelic.only")
snpgdsVCF2GDS(vcf5, "5.gds", method = "biallelic.only")
snpgdsVCF2GDS(vcf6, "6.gds", method = "biallelic.only")
snpgdsVCF2GDS(vcf7, "7.gds", method = "biallelic.only")
snpgdsVCF2GDS(vcf8, "8.gds", method = "biallelic.only")
snpgdsVCF2GDS(vcf9, "9.gds", method = "biallelic.only")
snpgdsVCF2GDS(vcf10, "10.gds", method = "biallelic.only")
snpgdsVCF2GDS(vcf11, "11.gds", method = "biallelic.only")
snpgdsVCF2GDS(vcf50, "50.gds", method = "biallelic.only")
snpgdsVCF2GDS(vcf100, "100.gds", method = "biallelic.only")

# Let's check a couple (or all of them)

snpgdsSummary("4.gds")
snpgdsSummary("5.gds")
snpgdsSummary("6.gds")
snpgdsSummary("7.gds")
snpgdsSummary("8.gds")
snpgdsSummary("9.gds")
snpgdsSummary("10.gds")
snpgdsSummary("11.gds")
snpgdsSummary("50.gds")
snpgdsSummary("100.gds")

# open our gds files into memory ----
# check and set wd
getwd()
setwd("YOURDIRHERE")
list.files()

miss <- snpgdsOpen("miss.gds")
s4 <- snpgdsOpen("4.gds")
s5 <- snpgdsOpen("5.gds")
s6 <- snpgdsOpen("6.gds")
s7 <- snpgdsOpen("7.gds")
s8 <- snpgdsOpen("8.gds")
s9 <- snpgdsOpen("9.gds")
s10 <- snpgdsOpen("10.gds")
s11 <- snpgdsOpen("11.gds")
s50 <- snpgdsOpen("50.gds")
s100 <- snpgdsOpen("100.gds")


# Make genetic matrices ----
# Miss
ibsmiss <- snpgdsIBS(miss, num.thread=2)
mmiss <- 1 -ibsmiss$ibs
colnames(mmiss) <- rownames(mmiss) <- ibsmiss$sample.id
View(mmiss) # can discriminate between all samples

# 4
ibss4 <- snpgdsIBS(s4, num.thread=2)
ms4 <- 1 -ibss4$ibs
colnames(ms4) <- rownames(ms4) <- ibss4$sample.id
View(ms4) # fails

# 5
ibss5 <- snpgdsIBS(s5, num.thread=2)
ms5 <- 1 -ibss5$ibs
colnames(ms5) <- rownames(ms5) <- ibss5$sample.id
View(ms5) # Nope
# 5 diffs ACDC/ANKA, ISLAND HONEY/KUSH, KUSH/SENSIBIGTWIN, Splits Afghani Kush from BBerryKush/GhostTrainHaze group, KANATA/HEADBAND,
# R2/ACADIA, CBDCritmass/TB1004, SENSIBIGTWIN/KUSH/CBDYUMMY/HASHPLANT, HASHPLANT/SENSIBIGTWIN

# 6
ibss6 <- snpgdsIBS(s6, num.thread=2)
ms6 <- 1 -ibss6$ibs
colnames(ms6) <- rownames(ms6) <- ibss6$sample.id
View(ms6) # Nope 
# 6 splits nepali diesel from the mongolian/nukem/armageddon group
# 6 splits sensi big twin and CBDYummy

# 7
ibss7 <- snpgdsIBS(s7, num.thread=2)
ms7 <- 1 -ibss7$ibs
colnames(ms7) <- rownames(ms7) <- ibss7$sample.id
View(ms7) # Nope 
#No change between 6 and 7 in terms of strains discriminated... 7 could be redundant?


# 8
ibss8 <- snpgdsIBS(s8, num.thread=2)
ms8 <- 1 -ibss8$ibs
colnames(ms8) <- rownames(ms8) <- ibss8$sample.id
View(ms8) # Nope 
# SNP 8 splits mongolian apart from nukem/armageddon


# 9
ibss9 <- snpgdsIBS(s9, num.thread=2)
ms9 <- 1 -ibss9$ibs
colnames(ms9) <- rownames(ms9) <- ibss9$sample.id
View(ms9) # Nope
# SNP 9 differentiates between Blueberrykush and GhostTrainHaze

# 10
# SNP #10 differentiates between nukem/armageddon
ibss10 <- snpgdsIBS(s10, num.thread=2)
ms10 <- 1 -ibss10$ibs
colnames(ms10) <- rownames(ms10) <- ibss10$sample.id
View(ms10) # can discriminate between all samples

# 11
ibss11 <- snpgdsIBS(s11, num.thread=2)
ms11 <- 1 -ibss11$ibs
colnames(ms11) <- rownames(ms11) <- ibss11$sample.id
View(ms11) # can discriminate between all samples

# 50
ibss50 <- snpgdsIBS(s50, num.thread=2)
ms50 <- 1 -ibss50$ibs
colnames(ms50) <- rownames(ms50) <- ibss50$sample.id
View(ms50) # can discriminate between all samples 

# 100
ibss100 <- snpgdsIBS(s100, num.thread=2)
ms100 <- 1 -ibss100$ibs
colnames(ms100) <- rownames(ms100) <- ibss100$sample.id
View(ms100) # can discriminate between all samples 

# A 9 SNP subset that removes the "redundant" SNP 7 identified above
ibsNew9 <- snpgdsIBS(sOpt, num.thread=2)
mNew9 <- 1 -ibsNew9$ibs
colnames(mNew9) <- rownames(mNew9) <- ibsNew9$sample.id
View(mNew9) # can discriminate between all samples!

# If we want to automate the validation, write the matrix to a csv, then pass to validateDistanceMatrices.py
write.table(mNew9, file = "mNew9.csv", sep = " ", row.names = TRUE, col.names = TRUE)

# Now we have our targeted SNPs, we can get flanking sequences and begin to develop primers (go to Primers_Flanks.sh)

# References
citation(gdsfmt)
citation(SNPRelate)
citation(vcfR)
citation(ade4)
citation(ncf)
