#!/usr/bin/env bash
# A script that takes a BAM file and converts it to a BED file
# It also filters the contents of the file using regex.
# and creates and activates a conda environment

# Get the command arguments
bamfile=$1
echo "BAM file:" $bamfile
outputfolder=$2 
echo "Output folder:" $outputfolder

# Creating the output directory if it doesn't exist yet
# (I adapted this code from the similar line in the test_the_script.sh file)
if [ ! -d $2 ]; then
  mkdir $outputfolder
fi

# Conda
source $(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh
# Creating and activating conda environment called 'bam2bed' with the bedtools package
conda create -y -n bam2bed bedtools
conda activate bam2bed

# Converting input BAM file to a BED file with bedtools
# and saving it in output directory
filename=$(basename ${bamfile} .bam)
echo $filename
bedtools bamtobed -i $bamfile > "$outputfolder/$filename.bed"
echo "BED filename:" "$outputfolder/$filename.bed"

 echo "BED line count:" $(wc -l "$outputfolder/$filename.bed")

# Filtering the BED file with regex for all regions from chromosome 1
# and saving those in another BED file with the suffix _chr1.bed
# and the -w flag to make sure it doesn't include chr10
grep -i -w "chr1" "$outputfolder/$filename.bed" > "$outputfolder/$filename""_chr1.bed"
echo "Chromosome 1 BED filename:" "$outputfolder/$filename""_chr1.bed"

# Counting the number of lines in the filtered file and storing the count in
# a new file called bam2bed_number_of_rows.txt
wc -l "$outputfolder/$filename""_chr1.bed" > $outputfolder"/bam2bed_number_of_rows.txt"
echo "Count file:" $outputfolder"/bam2bed_number_of_rows.txt"

echo Alex
