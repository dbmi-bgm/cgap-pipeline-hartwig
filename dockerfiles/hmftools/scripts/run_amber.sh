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
    --threads_amber)
        shift
        threads_amber=$1
        ;;
    --output_dir_amber)
        shift
        output_dir_amber=$1
        ;;
    #reference files
    --loci_file)
        shift
        loci_file=$1
        ;;

    esac
    shift
done


echo "Running AMBER"
/usr/lib/jvm/java-11-openjdk-amd64/bin/java \
-Xmx16G \
-cp /usr/local/bin/amber-3.9.jar com.hartwig.hmftools.amber.AmberApplication \
-tumor_bam $tumor_bam \
-reference_bam $reference_bam \
-tumor $tumor_id \
-reference $reference_id \
-loci $loci_file \
-output_dir $output_dir_amber \
-ref_genome_version $genome_version \
-threads $threads_amber

pushd  $output_dir_amber
tar -czvf  $(dirs -l +1)/$output_dir_amber.tar.gz *
popd
