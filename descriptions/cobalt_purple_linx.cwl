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

  - id: tumor_bam
    type: File
    inputBinding:
      prefix: -tumor_bam
    secondaryFiles:
      - .bai
    doc: tumor BAM file
  
  - id: amber_tar
    type: File
    inputBinding:
      prefix: --amber_tar
    doc: todo

  - id: reference_genome
    type: File
    inputBinding:
      prefix: --reference_genome
    secondaryFiles:
      - .fai
      - .dict
    doc: reference genome

  - id: reference_bam
    type: File
    inputBinding:
      prefix: -reference_bam
    secondaryFiles:
      - .bai
    doc: reference BAM file

  - id: tumor_id
    type: string
    inputBinding:
      prefix: -tumor
    doc: tumor sample ID

  - id: reference_id
    type: string
    inputBinding:
      prefix: -reference
    doc: reference sample ID

  - id: output_dir_cobalt
    type: string
    inputBinding:
      prefix: --output_dir_cobalt
    default: "cobalt_output"
    doc: output directory

  - id: gc_profile
    type: File
    inputBinding:
      prefix: --gc_profile
    doc: GC 

  - id: ensembl_data
    type: File
    inputBinding:
      prefix: --ensembl_data
    doc: TODO

  - id: known_fusion_file
    type: File
    inputBinding:
      prefix: --known_fusion_file
    doc: todo

  - id: somatic_sv_vcf
    type: File
    inputBinding:
      prefix: --somatic_sv_vcf
    doc: todo

  - id: somatic_hotspots
    type: File
    inputBinding:
      prefix: --somatic_hotspots
    doc: todo

  - id: driver_gene_panel
    type: File
    inputBinding:
      prefix: --driver_gene_panel
    doc: todo

  - id: somatic_vcf
    type: File
    inputBinding:
      prefix: --somatic_vcf
    doc: todo

  - id: output_dir_purple
    type: string
    inputBinding:
      prefix: --output_dir_purple
    default: "purple_output"
    doc: output directory

  - id: output_dir_linx
    type: string
    inputBinding:
      prefix: --output_dir_linx
    default: "linx_output"
    doc: output directory

  - id: threads_cobalt
    type: int
    inputBinding:
      prefix: --threads_cobalt
    default: 32
    doc: number of threads for cobalt

  - id: genome_version
    type: string
    inputBinding:
      prefix: --genome_version
    default: "V38"
    doc: genome version

outputs:

  - id: cobalt_tar
    type: File
    outputBinding:
      glob: $(inputs.output_dir_cobalt).tar.gz

  - id: purple_tar
    type: File
    outputBinding:
      glob: $(inputs.output_dir_purple).tar.gz

  - id: linx_tar
    type: File
    outputBinding:
      glob: $(inputs.output_dir_linx).tar.gz

doc: |
  generate a tumor BAF file using AMBER