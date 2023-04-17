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
    #AMBER parameters
    --threads_amber)
        shift
        threads_amber=$1
        ;;
    --output_dir_amber)
        shift
        output_dir_amber=$1
        ;;
    #PURPLE parameters
    --output_dir_purple)
        shift
        output_dir_purple=$1
        ;;
    --threads_purple)
        shift
        threads_purple=$1
        ;;
    #LINX parameters
    --output_dir_linx)
        shift
        output_dir_linx=$1
        ;;
    --threads_linx)
        shift
        threads_linx=$1
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
    --loci_file)
        shift
        loci_file=$1

    esac
    shift
done

# exit if any of the commands fails
set -e


FILTER_VCF="filtered_vcf"
ENSEMBL_DIR="ensembl_data"
SOMATIC_SV_VCF="somatic_sv.vcf"
DRIVER_GENE_PANEL_TSV="gene_panel.tsv"

echo "Unzipping ENSEMBL data"
mkdir -p $ENSEMBL_DIR
tar -xzf $ensembl_data --directory $ENSEMBL_DIR

echo "Unzipping driver gene panel"
gunzip -c $driver_gene_panel > $DRIVER_GENE_PANEL_TSV

echo "Filtering SV variants -- SNVs, INDELs, PASS only"
python3 /usr/local/bin/filter_variants.py -i $somatic_vcf -o ind snv --pass_only --prefix $FILTER_VCF

echo "Removing non standard chromosomes"
python3  /usr/local/bin/remove_non_std_chroms.py -i ${FILTER_VCF}_ind_snv.vcf.gz -o $SOMATIC_SV_VCF

echo "Running AMBER"
/usr/lib/jvm/java-11-openjdk-amd64/bin/java \
-Xmx16G \
-cp ${AMBER_JAR_PATH} com.hartwig.hmftools.amber.AmberApplication \
-tumor_bam $tumor_bam \
-reference_bam $reference_bam \
-tumor $tumor_id \
-reference $reference_id \
-loci $loci_file \
-output_dir $output_dir_amber \
-ref_genome_version $genome_version \
-threads $threads_amber

echo "Running COBALT"
/usr/lib/jvm/java-11-openjdk-amd64/bin/java \
-Xmx32G \
-cp ${COBALT_JAR_PATH} com.hartwig.hmftools.cobalt.CobaltApplication \
-tumor_bam $tumor_bam \
-reference_bam $reference_bam \
-tumor $tumor_id \
-reference $reference_id \
-threads $threads_cobalt \
-gc_profile $gc_profile \
-output_dir $output_dir_cobalt

echo "Running PURPLE"
/usr/lib/jvm/java-11-openjdk-amd64/bin/java \
-Xmx32G -jar ${PURPLE_JAR_PATH} \
-reference $reference_id \
-tumor $tumor_id \
-amber $output_dir_amber \
-cobalt $output_dir_cobalt \
-gc_profile $gc_profile \
-ref_genome $reference_genome \
-ref_genome_version $genome_version \
-ensembl_data_dir $ENSEMBL_DIR \
-somatic_vcf $SOMATIC_SV_VCF \
-somatic_sv_vcf $somatic_sv_vcf \
-output_dir $output_dir_purple \
-somatic_hotspots $somatic_hotspots \
-driver_gene_panel $DRIVER_GENE_PANEL_TSV \
-circos /usr/local/bin/circos-0.69-9/bin/circos \
-threads $threads_purple

echo "Running LINX"
/usr/lib/jvm/java-11-openjdk-amd64/bin/java -jar ${LINX_JAR_PATH} \
-sample $tumor_id \
-ref_genome_version $genome_version \
-sv_vcf $output_dir_purple/$tumor_id.purple.sv.vcf.gz \
-purple_dir $output_dir_purple \
-output_dir $output_dir_linx \
-ensembl_data_dir $ENSEMBL_DIR \
-check_fusions \
-check_drivers \
-threads $threads_linx \
-driver_gene_panel $DRIVER_GENE_PANEL_TSV


pushd  $output_dir_amber
echo "Compressing AMBER directory"
tar -czvf  $(dirs -l +1)/$output_dir_amber.tar.gz *
popd

pushd  $output_dir_cobalt
echo "Compressing COBALT directory"
tar -czvf  $(dirs -l +1)/$output_dir_cobalt.tar.gz *
popd

pushd  $output_dir_purple
echo "Compressing PURPLE directory"
tar -czvf  $(dirs -l +1)/$output_dir_purple.tar.gz *
popd


pushd  $output_dir_linx
echo "Compressing LINX directory"
tar -czvf  $(dirs -l +1)/$output_dir_linx.tar.gz *
popd

echo "Compressing output TSV files"
gzip $output_dir_purple/$tumor_id.purple.cnv.somatic.tsv
gzip $output_dir_purple/$tumor_id.purple.purity.tsv
gzip $output_dir_purple/$tumor_id.purple.segment.tsv
gzip $output_dir_linx/$tumor_id.linx.svs.tsv
gzip $output_dir_linx/$tumor_id.linx.breakend.tsv
gzip $output_dir_linx/$tumor_id.linx.fusion.tsv
gzip $output_dir_linx/$tumor_id.linx.driver.catalog.tsv
