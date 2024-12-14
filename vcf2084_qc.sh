#!/bin/bash
echo "Generated log file for the run" > vcf_qc_log.txt
x="bcftools-1.11.3"
module load $x
echo "BCFtools module loaded" >> vcf_qc_log.txt
#
bcftools stats 2084_allchr.vcf.gz  > 2084.stat --thread 72
echo "Stats generated before QC" >> vcf_qc_log.txt
#
echo "Preprocessing steps" >> vcf_qc_log.txt
#
echo "AC=0 Being filtered" >> vcf_prepro_log.txt
bcftools filter -e 'AC==0' 2084_allchr.vcf.gz -Oz -o 2084_allchr_ac0.vcf.gz --thread 72
bcftools stats 2084_allchr_ac0.vcf.gz  > 2084_ac0.stat --thread 72
echo "Stats generated after AC=0" >> vcf_qc_log.txt
#
echo "AC=AN Being filtered" >> vcf_prepro_log.txt
bcftools filter -e 'AC==AN' 2084_allchr_ac0.vcf.gz -Oz -o  2084_allchr_ac0_acan.vcf.gz --thread 72
bcftools stats 2084_allchr_ac0_acan.vcf.gz  > 2084_acan.stat --thread 72
echo "Stats generated after AC=AN" >> vcf_qc_log.txt
#
echo "Biallelic filter" >> vcf_prepro_log.txt
bcftools view -m2 -M2 2084_allchr_ac0_acan.vcf.gz -Oz -o 2084_allchr_biallelic.vcf.gz --thread 72
bcftools stats 2084_allchr_biallelic.vcf.gz  > 2084_bi.stat --thread 72
echo "Stats generated after Biallelic filter" >> vcf_qc_log.txt
#
echo "Multiallelic filter" >> vcf_prepro_log.txt
bcftools view -v mnps 2084_allchr_ac0_acan.vcf.gz -Oz -o 2084_allchr_multiallelic.vcf.gz --thread 72
bcftools stats 2084_allchr_multiallelic.vcf.gz  > 2084_multi.stat --thread 72
echo "Stats generated after Multiallelic filter" >> vcf_qc_log.txt
#
echo "QC1 steps" >> vcf_qc_log.txt
#
echo "QUAL<30 Being excluded" >> vcf_qc_log.txt
bcftools view -e 'QUAL<30' 2084_allchr_biallelic.vcf.gz -Oz -o 2084qc_qual.vcf.gz --thread 72
bcftools stats 2084qc_qual.vcf.gz  > 2084_qual.stat --thread 72
echo "Stats generated after qual" >> vcf_qc_log.txt
#
echo "MMQ<40 Being excluded" >> vcf_qc_log.txt
bcftools view -e 'MMQ < 40' 2084qc_qual.vcf.gz -Oz -o 2084qc_mmq.vcf.gz --thread 72
bcftools stats 2084qc_mmq.vcf.gz  > 2084_mmq.stat --thread 72
echo "Stats generated after MMQ" >> vcf_qc_log.txt
#
echo "GQ<20 Being excluded" >> vcf_qc_log.txt
bcftools view -e 'GQ < 20' 2084qc_mmq.vcf.gz -Oz -o 2084qc_gq.vcf.gz --thread 72
#https://github.com/samtools/bcftools/issues/1384
bcftools stats 2084qc_gq.vcf.gz  > 2084_gq.stat --thread 72
echo "Stats generated  after GQ " >> vcf_qc_log.txt
#
echo "QC2 steps" >> vcf_qc_log.txt
#
echo "snp filter" >> vcf_prepro_log.txt
bcftools view -v snps 2084qc_gq.vcf.gz -Oz -o 2084_allchr_snps.vcf.gz --thread 72
bcftools stats 2084_allchr_snp.vcf.gz  > 2084_snp.stat --thread 72
echo "Stats generated after snp filter" >> vcf_qc_log.txt
#
echo "indel filter" >> vcf_prepro_log.txt
bcftools view -v indels 2084qc_gq.vcf.gz -Oz -o 2084_allchr_indels.vcf.gz --thread 72
bcftools stats 2084_allchr_indels.vcf.gz  > 2084_indels.stat --thread 72
echo "Stats generated after indel filter" >> vcf_qc_log.txt
#
echo "END" >> vcf_qc_log.txt