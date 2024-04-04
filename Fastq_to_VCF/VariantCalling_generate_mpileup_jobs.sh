#!/bin/bash
# Purpose : Generate jobs that runs mpileup + variant call to produce vcf files
# How it works: Make a list of all our strain names (declare), then iterate through the list and make a .sh file for each
# strain by echoing each line of the script to the .sh file 
# How to use : declare strain list, modify parameters as needed, run in bash terminal
# More details here: http://www.htslib.org/doc/#manual-pages

# Step 1: Declare string array of strains
declare -a strain_list=("Chemovar1" "Chemovar2" "Chemovar3" "Chemovar etc")

# Step 2 : Iterate through each strain in list of strains, this will generate one "variantCall_$strain.sh" file per strain
for strain in ${strain_list[@]}; do
	touch variantCall_$strain.sh #Creates file
	# shebang line
	echo "#!/bin/bash" >> variantCall_$strain.sh 
	# job parameters -- details below
	echo "bcftools mpileup \\
  --redo-BAQ \\
  --min-BQ 30 \\
  --per-sample-mF \\
  --annotate FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,FORMAT/SP,INFO/AD,INFO/ADF,INFO/ADR \\
  -f cs10.fasta "$strain".bam | \\
  bcftools call \\
    --multiallelic-caller \\
    --variants-only \\
    --skip-variants indels \\
    --threads 8 \\
    -Ov " "> "$strain".vcf" >> variantCall_$strain.sh 

done

# bcftools parameters
# mpileup args 
# --redo-BAQ : Recalculate BAQ on the fly, ignore existing BQ tags. BAQ : BAQ is the Phred-scaled probability of a read base being misaligned.
# --min-BQ : Minimum base quality for a base to be considered
# --per-sample-MF : Apply -m and -F thresholds per sample to increase sensitivity of calling. By default both options are applied to reads pooled from all samples.
# -m threshold : Minimum number gapped reads for indel candidates [1]
# -F threshold : Minimum fraction of gapped reads [0.002]
# --annotate : Comma-separated list of FORMAT and INFO tags to output. Args at bottom
# -f : The faidx-indexed reference file in the FASTA format.

# call args
# --multiallelic-caller : alternative model for multiallelic and rare-variant calling designed to overcome known limitations in -c calling model
# --variants-only : output variant sites only
# --skip-variants indels : skip indel/SNP sites
# --threads 8 : specifies threads - only useful when compression is required
# -Oz : output type b for .bam.gz, u for .bam, v for vcf, z for vcf.gz 

# annotate args : 
# FORMAT/AD   .. Allelic depth (Number=R,Type=Integer)
# FORMAT/ADF  .. Allelic depths on the forward strand (Number=R,Type=Integer)
# FORMAT/ADR  .. Allelic depths on the reverse strand (Number=R,Type=Integer)
# FORMAT/DP   .. Number of high-quality bases (Number=1,Type=Integer)
# FORMAT/SP   .. Phred-scaled strand bias P-value (Number=1,Type=Integer)
# FORMAT/SCR  .. Number of soft-clipped reads (Number=1,Type=Integer)
# INFO/AD     .. Total allelic depth (Number=R,Type=Integer)
# INFO/ADF    .. Total allelic depths on the forward strand (Number=R,Type=Integer)
# INFO/ADR    .. Total allelic depths on the reverse strand (Number=R,Type=Integer)
# INFO/SCR    .. Number of soft-clipped reads (Number=1,Type=Integer)
# FORMAT/DV   .. Deprecated in favor of FORMAT/AD; Number of high-quality non-reference bases, (Number=1,Type=Integer)
# FORMAT/DP4  .. Deprecated in favor of FORMAT/ADF and FORMAT/ADR; Number of high-quality ref-forward, ref-reverse,
#               alt-forward and alt-reverse bases (Number=4,Type=Integer)
# FORMAT/DPR  .. Deprecated in favor of FORMAT/AD; Number of high-quality bases for each observed allele (Number=R,Type=Integer)
# INFO/DPR    .. Deprecated in favor of INFO/AD; Number of high-quality bases for each observed allele (Number=R,Type=Integer)

# Reference
# Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G., 
# Durbin, R., 1000 Genome Project Data Processing Subgroup, 2009. The Sequence Alignment/Map format and SAMtools. 
# Bioinforma. Oxf. Engl. 25, 2078–2079. https://doi.org/10.1093/bioinformatics/btp352
