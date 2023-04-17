#!/bin/bash

while [ "$1" != "" ]; do
    case $1 in
    --tumor_bam)
        shift
        tumor_bam=$1
        ;;
    --reference_bam)
        shift
        reference_bam=$1
        ;;
    --threads)
        shift
        threads=$1
        ;;
    --reference_genome)
        shift
        reference_fa=$1
        ;;
    --ref_genome_version)
        shift
        ref_genome_version=$1
        ;;
    --tumor_id)
        shift
        tumor_id=$1
        ;;
    --reference_id)
        shift
        reference_id=$1
        ;;       
    --bwa_index)
        shift
        reference_bwt=$1
        ;;
    
    #GRIDSS parameters
    --gridss_output_vcf)
        shift
        gridss_output_vcf=$1
        ;;
    
    #reference files 
    --pon_sv_file)
        shift
        pon_sv_file=$1
        ;;
    --known_hotspot_file)
        shift
        known_hotspot_file=$1
        ;;
    --pon_sgl_file)
        shift
        pon_sgl_file=$1
        ;;
    esac
    shift
done

echo  ${reference_id},${tumor_id}

fasta="reference.fasta" 

# fasta
ln -s ${reference_fa}.fa  reference.fasta
ln -s ${reference_fa}.fa.fai  reference.fasta.fai
ln -s ${reference_fa}.dict  reference.dict

# bwt
ln -s ${reference_bwt}.bwt  reference.fasta.bwt
ln -s ${reference_bwt}.ann  reference.fasta.ann
ln -s ${reference_bwt}.amb  reference.fasta.amb
ln -s ${reference_bwt}.pac  reference.fasta.pac
ln -s ${reference_bwt}.sa   reference.fasta.sa
ln -s ${reference_bwt}.alt  reference.fasta.alt

gridss \
--jar  ${GRIDSS_JAR_PATH} \
--jvmheap 44g \
--otherjvmheap 4g \
--labels ${reference_id},${tumor_id} \
--output $gridss_output_vcf \
--threads $threads \
--reference $fasta \
$reference_bam \
$tumor_bam

/usr/lib/jvm/java-11-openjdk-amd64/bin/java \
-Xmx32G \
-jar ${GRIPSS_JAR_PATH} \
-sample $tumor_id \
-reference $reference_id \
-vcf  $gridss_output_vcf \
-output_dir . \
-pon_sgl_file $pon_sgl_file \
-pon_sv_file $pon_sv_file \
-known_hotspot_file $known_hotspot_file \
-ref_genome reference.fasta \
-ref_genome_version $ref_genome_version