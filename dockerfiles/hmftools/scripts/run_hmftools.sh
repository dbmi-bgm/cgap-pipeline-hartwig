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
    --tumor_id)
        shift
        tumor_id=$1
        ;;
    --reference_id)
        shift
        reference_id=$1
        ;;
    --reference_genome)
        shift
        reference_genome=$1
        ;;
    --genome_version)
        shift
        genome_version=$1
        ;;
    #COBALT parameters
    --threads_cobalt)
        shift
        threads_cobalt=$1
        ;;
    --output_dir_cobalt)
        shift
        output_dir_cobalt=$1
        ;;
    #PURPLE parameters
    --output_dir_purple)
        shift
        output_dir_purple=$1
        ;;
    #LINX parameters
    --output_dir_linx)
        shift
        output_dir_linx=$1
        ;;
    #reference files
    --gc_profile)
        shift
        gc_profile=$1
        ;;
    --ensembl_data)
        shift
        ensembl_data=$1
        ;;
    --known_fusion_file)
        shift
        known_fusion_file=$1
        ;;
    --somatic_vcf)
        shift
        somatic_vcf=$1
        ;;
    --somatic_sv_vcf)
        shift
        somatic_sv_vcf=$1
        ;;
    --somatic_hotspots)
        shift
        somatic_hotspots=$1
        ;;
    --driver_gene_panel)
        shift
        driver_gene_panel=$1
        ;;
    
    --amber_tar)
        shift
        amber_tar=$1

    esac
    shift
done

echo "decompress AMBER results"
amber_folder="amber_output"
mkdir -p $amber_folder

pushd $amber_folder
tar -xf $amber_tar
popd

echo "Running COBALT"
/usr/lib/jvm/java-11-openjdk-amd64/bin/java \
-Xmx32G \
-cp /usr/local/bin/cobalt-1.13.jar com.hartwig.hmftools.cobalt.CobaltApplication \
-tumor_bam $tumor_bam \
-reference_bam $reference_bam \
-tumor $tumor_id \
-reference $reference_id \
-threads $threads_cobalt \
-gc_profile $gc_profile \
-output_dir $output_dir_cobalt

FILTER_VCF="filtered_vcf"
tar -xzf $ensembl_data

python3 filter_variants.py -i $somatic_vcf -o ind snv --pass_only --prefix $FILTER_VCF 
echo "Running PURPLE"
/usr/lib/jvm/java-11-openjdk-amd64/bin/java \
-Xmx32G -jar purple_v3.8.1.jar \
-reference $reference_id \
-tumor $tumor_id \
-amber $amber_folder \
-cobalt $output_dir_cobalt \
-gc_profile $gc_profile \
-ref_genome $reference_genome \
-ref_genome_version $genome_version \
-ensembl_data_dir $ensembl_data \
-somatic_vcf $(FILTER_VCF)_ind_snv.vcf.gz \
-somatic_sv_vcf $somatic_sv_vcf \
-output_dir $output_dir_purple \
-somatic_hotspots $somatic_hotspots \
-driver_gene_panel $driver_gene_panel \
-circos /usr/local/bin/circos-0.69-9/bin/circos

echo "Running LINX"
/usr/lib/jvm/java-11-openjdk-amd64/bin/java -jar linx_v1.22.jar \
-sample $tumor_id \
-ref_genome_version $genome_version \
-sv_vcf $output_dir_purple/$tumor_id.purple.sv.vcf.gz \
-purple_dir $output_dir_purple \
-output_dir $output_dir_linx \
-ensembl_data_dir $ensembl_data \
-check_fusions


pushd  $output_dir_cobalt
tar -czvf  $(dirs -l +1)/$output_dir_cobalt.tar.gz *
popd


pushd  $output_dir_purple
tar -czvf  $(dirs -l +1)/$output_dir_purple.tar.gz *
popd


pushd  $output_dir_linx
tar -czvf  $(dirs -l +1)/$output_dir_linx.tar.gz *
popd
