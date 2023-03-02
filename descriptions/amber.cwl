#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: hmftools:1.0.0

baseCommand: [ /usr/local/bin/run_amber.sh]

inputs:
  - id: tumor_bam
    type: File
    inputBinding:
      prefix: --tumor_bam
    secondaryFiles:
      - .bai
    doc: tumor BAM file

  - id: reference_bam
    type: File
    inputBinding:
      prefix: --reference_bam
    secondaryFiles:
      - .bai
    doc: reference BAM file

  - id: loci_file
    type: File
    inputBinding:
      prefix: --loci_file
    doc: VCF file containing likely heterozygous sites

  - id: tumor_id
    type: string
    inputBinding:
      prefix: --tumor_id
    doc: tumor sample ID

  - id: reference_id
    type: string
    inputBinding:
      prefix: --reference_id
    doc: reference sample ID

  - id: output_dir
    type: string
    inputBinding:
      prefix: --output_dir_amber
    default: "amber_output"
    doc: output directory

  - id: threads
    type: int
    inputBinding:
      prefix: --threads_amber
    default: 16
    doc: number of threads

  - id: ref_genome_version
    type: string
    inputBinding:
      prefix: --genome_version
    default: "V38"
    doc: genome version

outputs:
  - id: amber_tar
    type: File
    outputBinding:
      glob: $(inputs.output_dir).tar.gz

doc: |
  generate a tumor BAF file using AMBER
