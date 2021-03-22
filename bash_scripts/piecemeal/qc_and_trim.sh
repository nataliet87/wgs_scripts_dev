#!/bin/bash

# DEPENDENCIES:
# fastqc
# trimgalore
# cutadapt
# samtools

# DIRECTORY SETUP
mkdir fastq
mkdir fastq/merged_untrimmed

mkdir reports
mkdir reports/fastqc_untrimmed_out
mkdir reports/fastqc_trimmed_out

echo " ----  Trimming and Running QC  ----"

# UNTRIMMED FASTQC
for f in fastq/merged_untrimmed/*_001.fastq.gz

	do
 			echo Running fastqc on "$f"
			fastqc -t 2 --extract -o reports/fastqc_untrimmed_out "$f"
	done


# TRIM AND GENERATE TRIMMED FASTQC
for f in fastq/merged_untrimmed/*R1_001.fastq.gz
	do
			echo "Running TrimGalore on:  ${f}  ${f/R1/R2}"
			trim_galore --quality 30 --paired --output_dir fastq \
					--fastqc --fastqc_args "-t 2 --extract -o reports/fastqc_trimmed_out" \
					"${f}" "${f/R1/R2}"
	done
