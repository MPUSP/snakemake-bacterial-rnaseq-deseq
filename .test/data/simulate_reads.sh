#!/bin/bash

# script to simulate reads using DWGSIM tool; 
# we start in the main dir of the sm workflow
mkdir .test/data/rnaseq_sim
cd .test/data/rnaseq_sim

# parameters
read_length=75
read_number=100000
random_freq=0.05
error_freq=0.01
fasta="GCF_043231225.1_ASM4323122v1_genomic.fna"
prefix="control_S1"
threep_adapter="GGGCTGATGCTTTGAA"
threep_umi_len=6
threep_phred="2212022201214242326224"

# run raw read simulation for paired end reads
# output is separate R1/R2.fastq.gz files (option -o)
dwgsim -1 ${read_length} -2 ${read_length} \
  -N ${read_number} \
  -y ${random_freq} \
  -r ${error_freq} \
  -o 1 \
  ${fasta} \
  ${prefix} &> "${prefix}.log"

# manipulate reads such that 1 adapter and 1 UMI are added at the 
# 2nd line of each read. Quality scores are added at 4th line of each read
zcat ${prefix}.bwa.read2.fastq.gz > ${prefix}.bwa.read2.fastq

awk '{
  if (NR % 4 == 2) {
    umi="tr -dc 'GATC' </dev/urandom | head -c '${threep_umi_len}'"
    umi | getline random_str
    close(umi)
    $0 = substr($0,0,53) random_str "'${threep_adapter}'"
  } else if (NR % 4 == 0) {
    $0 = substr($0,0,53) "'${threep_phred}'"
  }
  print
}' ${prefix}.bwa.read2.fastq | gzip > ${prefix}_R2.fastq.gz
