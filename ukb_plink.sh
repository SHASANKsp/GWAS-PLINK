#!/bin/bash
x="plink/1.9.0"
module load $x
while read line; do
	plink --keep wblistf.txt --vcf ../${line}.vcf.gz -recode vcf bgz --out ${line}_wb.vcf.gz --threads 72 
done < ../chrom.txt