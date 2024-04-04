#!/bin/bash
# Purpose : Generate jobs that trim and merge raw reads
# How it works: Make a list of all our chemovar names (declare), then iterate through the list and make a .sh file 
# for each strain by echoing each line of the script to the .sh file
# How to use : declare strain list, modify fastp criteria/allocations as needed, run in bash terminal
# More details here: https://github.com/OpenGene/fastp

# Step 1: Declare string array of chemovars
declare -a strain_list=("Chemovar1" "Chemovar2" "Chemovar3" "Chemovar etc")

# Step 2 : Iterate through each strain in list of strains, this will generate one "fastp_$strain.sh" file per strain

	

for strain in ${strain_list[@]}; do
	touch fastp_$strain.sh #Creates file
	echo "#!/bin/bash" >> fastp_$strain.sh
    # Adds paramaters to file
	echo fastp -i "$strain"_R1.fastq.gz -I "$strain"_R2.fastq.gz \
	-o fastp_"$strain"_R1P.fastq.gz fastp_"$strain"_R2P.fastq.gz \
	-R $strain"_fastp_QC" -h "Fastp_"$strain -j $strain"_fastp" \
	-e 20 -c -a ""auto"" -L -r \
	-m --merged_out $strain"_fastp_Merged.fastq.gz" --out1 $strain"_R1_fastp_Unmerged.fastq.gz" \
	--out2 $strain"_R2_fastp_Unmerged.fastq.gz" \
	--unpaired1 $strain"_R1Pass_R2Fail.fastq.gz" --unpaired2 $strain"_R2Pass_R1Fail.fastq.gz" >> fastp_$strain.sh
done

# fastp parameters
	# Run QC and trimming -i and -I specify our raw reads, -o specifies our output, -R specifies default report name, -h names html QC report,
	# -j names .json QC report, -e applies per-read average quality score filter, -c enables base correction based on overlap,
	# -a "auto" enables automated adapter ID and trimming, -L disables length filtering
	# -r applies sliding window from front to end, if read mean < threshold, drop window and the rest of the read
	# default window size is 4, default read mean is 20
	# -m merged output paired reads, --out1 and --out2 gives names for QC pass reads that couldnt be merged
	# --unpaired1 --unpaired2 gives reads where one of two tracks failed QC
	
# Reference
# Chen, S., Zhou, Y., Chen, Y., Gu, J., 2018. fastp: an ultra-fast all-in-one FASTQ preprocessor. 
# Bioinformatics 34, i884–i890. https://doi.org/10.1093/bioinformatics/bty560