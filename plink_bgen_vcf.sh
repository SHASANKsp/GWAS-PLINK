#!/bin/bash
echo "Generated log file for the run <BGEN to VCF>" > 5_log.txt
x="plink/2"
module load $x
echo "Plink module loaded" >> 5_log.txt
for var in 1 2 3 4 5;
do
	now=$(date)
	echo "Current time : $now" >> 5_log.txt
	plink2 --bgen ukb22828_c${var}_b0_v3.bgen ref-first  --sample new/ukb_sample/ukb22828_c${var}_*.sample --fa GCF_000001405.25_GRCh37.p13_genomic.fna  --keep-allele-order  --export vcf vcf-dosage=DS --out b2v_p/ukb22828_c${var}.vcf.gz
	now=$(date)
	echo "Current time : $now" >> 5_log.txt
done
echo "END" >> 5_log.txt