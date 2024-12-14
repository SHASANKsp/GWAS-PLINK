#!/bin/bash
echo "Generated log file for the run <BGEN to VCF>" > 47_13log.txt
#change the log file name
x="bcftools-1.11.3"
module load $x
echo "BCFtools module loaded" >> 47_13log.txt
y="bgen-665"
module load $y
echo "Bgenix module loaded" >> 47_13log.txt
for var in 13;
do
	now=$(date)
	echo "Current time : $now" >> 47_13log.txt
	echo "Index file for chromosome $var started" >> 47_13log.txt
	bgenix -g "ukb22828_c${var}_b0_v3.bgen" -index
	now=$(date)
	echo "Current time : $now" >> 47_13log.txt
	echo "Index file for chromosome $var completed" >> 47_13log.txt
	echo "VCF file for chromosome $var started" >> 47_13log.txt
	bgenix -g "ukb22828_c${var}_b0_v3.bgen" -i "ukb22828_c${var}_b0_v3.bgen.bgi" -vcf | bgzip -c > new/ukb22828_c${var}.vcf.gz --thread 72
	echo "VCF file for chromosome $var completed" >> 47_13log.txt
	now=$(date)
	echo "Current time : $now" >> 47_13log.txt
	echo "Indexing the vcf file" >> 47_13log.txt
	cd /gpfs/data/user/shasank/22828_BGEN_Files/new/
	bcftools index -t ukb22828_c${var}.vcf.gz  --thread 72
	cd /gpfs/data/user/shasank/22828_BGEN_Files/
	now=$(date)
	echo "Current time : $now" >> 47_13log.txt

done
echo "END" >> 47_13log.txt
