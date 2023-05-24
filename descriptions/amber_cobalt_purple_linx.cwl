#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/hmftools:VERSION

baseCommand: [/usr/local/bin/run_hmftools.sh]

inputs:

  - id: input_tumor_bam
    type: File
    inputBinding:
      prefix: --input_tumor_bam
    secondaryFiles:
      - .bai
    doc: tumor BAM file

  - id: reference_genome
    type: File
    inputBinding:
      prefix: --reference_genome
    secondaryFiles:
      - .fai
      - ^.dict
    doc: reference genome

  - id: input_normal_bam
    type: File
    inputBinding:
      prefix: --input_normal_bam
    secondaryFiles:
      - .bai
    doc: reference BAM file

  - id: tumor_sample_name
    type: string
    inputBinding:
      prefix: --tumor_sample_name
    doc: tumor sample ID

  - id: normal_sample_name
    type: string
    inputBinding:
      prefix: --normal_sample_name
    doc: reference sample ID

  - id: gc_profile
    type: File
    inputBinding:
      prefix: --gc_profile
    doc: GC profile

  - id: ensembl_data
    type: File
    inputBinding:
      prefix: --ensembl_data
    doc: Ensembl data cache

  - id: somatic_sv_vcf
    type: File
    inputBinding:
      prefix: --somatic_sv_vcf
    doc: VCF file containing somatic structural variants

  - id: somatic_hotspots
    type: File
    inputBinding:
      prefix: --somatic_hotspots
    doc: VCF containing somatic hotspot locations

  - id: driver_gene_panel
    type: File
    inputBinding:
      prefix: --driver_gene_panel
    doc: TSV containing driver genes

  - id: input_somatic_vcf
    type: File
    inputBinding:
      prefix: --input_somatic_vcf
    doc: VCF containing somatic variants (SNV/INDEL)

  - id: loci_file
    type: File
    inputBinding:
      prefix: --loci_file
    doc: VCF file containing likely heterozygous sites

  - id: output_dir_cobalt
    type: string
    inputBinding:
      prefix: --output_dir_cobalt
    default: "cobalt_output"
    doc: COBALT output directory

  - id: output_dir_amber
    type: string
    inputBinding:
      prefix: --output_dir_amber
    default: "amber_output"
    doc: AMBER output director

  - id: output_dir_purple
    type: string
    inputBinding:
      prefix: --output_dir_purple
    default: "purple_output"
    doc: PURPLE output directory

  - id: output_dir_linx
    type: string
    inputBinding:
      prefix: --output_dir_linx
    default: "linx_output"
    doc: LINX output directory

  - id: threads_amber
    type: int
    inputBinding:
      prefix: --threads_amber
    default: 16
    doc: number of threads for AMBER

  - id: threads_cobalt
    type: int
    inputBinding:
      prefix: --threads_cobalt
    default: 16
    doc: number of threads for COBALT

  - id: threads_purple
    type: int
    inputBinding:
      prefix: --threads_purple
    default: 16
    doc: number of threads for PURPLE

  - id: threads_linx
    type: int
    inputBinding:
      prefix: --threads_linx
    default: 16
    doc: number of threads for LINX

  - id: genome_version
    type: string
    inputBinding:
      prefix: --genome_version
    default: "V38"
    doc: genome version
  
  - id: known_fusion_data
    type: File
    inputBinding:
      prefix: --known_fusion_data
    doc: HMF known fusion data

outputs:

  - id: purple_tumor_cnv_somatic_tsv
    type: File
    outputBinding:
      glob: $(inputs.output_dir_purple)/$(inputs.tumor_sample_name).purple.cnv.somatic.tsv.gz
    doc: File containing the copy number profile of all (contiguous)  segments of the tumor sample

  - id: purple_tumor_purity_tsv
    type: File
    outputBinding:
      glob: $(inputs.output_dir_purple)/$(inputs.tumor_sample_name).purple.purity.tsv.gz
    doc: File containing a summary of the purity fit

  - id: purple_tumor_segment_tsv
    type: File
    outputBinding:
      glob: $(inputs.output_dir_purple)/$(inputs.tumor_sample_name).purple.segment.tsv.gz
    doc: File containing results of segmentation of the genome for the tumor sample.

  - id: purple_tumor_purity_qc
    type: File
    outputBinding:
      glob: $(inputs.output_dir_purple)/$(inputs.tumor_sample_name).purple.qc
    doc: File containing a summary of the purity fit

  - id: linx_tumor_svs_tsv
    type: File
    outputBinding:
      glob: $(inputs.output_dir_linx)/$(inputs.tumor_sample_name).linx.svs.tsv.gz
    doc: File containing annotations of each non PON filtered breakjunction
  
  - id: linx_tumor_breakend_tsv
    type: File
    outputBinding:
      glob: $(inputs.output_dir_linx)/$(inputs.tumor_sample_name).linx.breakend.tsv.gz
    doc: File containing information about the impact of each non PON filtered break junction on each overlapping gene
  
  - id: linx_tumor_fusions_tsv
    type: File
    outputBinding:
      glob: $(inputs.output_dir_linx)/$(inputs.tumor_sample_name).linx.fusion.tsv.gz
    doc: File containing all inframe and out of frame fusions predicted in the sample including HMF fusion knowledgebase annotations

  - id: linx_driver_catalog_tsv
    type: File
    outputBinding:
      glob: $(inputs.output_dir_linx)/$(inputs.tumor_sample_name).linx.driver.catalog.tsv.gz
    doc: File containing the driver catalog

  - id: amber_tar
    type: File
    outputBinding:
      glob: $(inputs.output_dir_amber).tar.gz
    doc: AMBER compressed output folder

  - id: cobalt_tar
    type: File
    outputBinding:
      glob: $(inputs.output_dir_cobalt).tar.gz
    doc: COBALT compressed output folder

  - id: purple_tar
    type: File
    outputBinding:
      glob: $(inputs.output_dir_purple).tar.gz
    doc: PURPLE compressed output folder

  - id: linx_tar
    type: File
    outputBinding:
      glob: $(inputs.output_dir_linx).tar.gz
    doc: LINX compressed output folder

doc: |
  Run AMBER, COBALT, PURPLE and LINX on tumor-normal paired samples.