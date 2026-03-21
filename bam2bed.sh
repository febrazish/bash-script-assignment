#!/usr/bin/env bash
# A script that takes a BAM file and converts it to a BED file
# It also  filters the contents of the file using regex.
# and creates and activates a conda environment

# Get the command arguments
bamfile=$1
echo "BAM file:" $bamfile
outputfolder=$2 
echo "Output folder:" $outputfolder

# Creating a new output directory
mkdir $outputfolder"/output_dir"
outputdir="$outputfolder""/output_dir"
echo "Output directory:" $outputdir

# Conda
source $(dirname $(dirname $(which mamba)))/etc/profile.d/conda.sh
# Creating and activating conda environment with the name 'bam2bed'
conda create --name bam2bed
conda activate bam2bed

# Converting input BAM file to a BED file with bedtools
# and saving it in output directory
filename="GSM1606197"
echo $filename
bedtools bamtobed -i "$bamfile" > "$outputdir/$filename.bed"
echo "BED file:" "$outputdir/$filename.bed"

# Filtering the BED file with regex for all regions from chromosome 1
# and saving those in another BED file with the suffix _chr1.bed
grep chr.*1 "$outputdir/$filename.bed" > "$outputdir/$filename""_chr1.bed"
echo "Chromosome 1 file:" "$outputdir/$filename""_chr1.bed"

# Counting the number of lines in the filtered file and storing the count in
# a new file called bam2bed_number_of_rows.txt
wc -l "$outputdir/$filename""_chr1.bed" > $outputdir"/bam2bed_number_of_rows.txt"
echo "Count file:" $outputdir"/bam2bed_number_of_rows.txt"

echo Alex