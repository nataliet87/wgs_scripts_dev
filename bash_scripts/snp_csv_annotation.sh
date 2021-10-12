#!/bin/bash

# DEPENDENCIES:
# blast
# conda packages: biopython, pandas, numpy, pyranges

# deal with weird python path env bullshit b/c of spack
source ~/.bashrc
conda activate snippy

python_path=$(dirname $(which python))
spack load blast-plus@2.10.0

export PATH="${python_path}:${PATH}"

echo "%%% PRINTING PATH"
echo $PATH


# READ IN ARGUMENTS
# usage:
function usage {
        echo "Usage: $(basename $0) [-R] [-A] [-L]" 2>&1
        echo '   -R   path to reference_genome.fa'
        echo '   -A   path to annotation_genome.gbk'
        echo '   -L   path to lab references CSV dir'
        exit 1
}

if [[ ${#} -eq 0 ]]; then
   usage
fi

# Define list of arguments expected in the input
optstring="R:A:L:"

while getopts ${optstring} arg; do
  case "${arg}" in
    R) REF="${OPTARG}" ;;
    A) ANNO="${OPTARG}" ;;
    L) LAB="${OPTARG}" ;;

    ?)
      echo "Invalid option: -${OPTARG}."
      echo
      usage
      ;;
  esac
done

# DIRECTORY SETUP
mkdir csv_old
mkdir blast


python ~/wgs/wgs_scripts_dev/python_analysis_scripts/snp_csv_annotation.py \
		-ref_strain BCG \
		--H37Rv \
		-blast blast \
		-lab_strain BCG \
		-vcf vcf_parse/ \
		-out csv_test_out

