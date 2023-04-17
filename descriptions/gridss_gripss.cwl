#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/gridss:VERSION

baseCommand: [/usr/local/bin/run_gridss_gripss.sh]

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

  - id: gridss_output_vcf
    type: string
    inputBinding:
      prefix: --gridss_output_vcf
    default: "gridss_output.vcf"
    doc: output VCF
  
  - id: ref_genome_version
    type: string
    inputBinding:
      prefix: --ref_genome_version
    default: "38"
    doc: genome version

  - id: threads
    type: int
    inputBinding:
      prefix: --threads
    default: 16
    doc: number of threads
  
  - id: reference_genome
    type: File
    inputBinding: 
      prefix: --reference_genome
      valueFrom: $(self.path.match(/(.*)\.[^.]+$/)[1])
    secondaryFiles:
      - ^.dict
      - .fai
    doc: reference genome

  - id: bwa_index
    type: File
    inputBinding: 
      prefix: --bwa_index
      valueFrom: $(self.path.match(/(.*)\.[^.]+$/)[1])
    secondaryFiles:
      - ^.alt
      - ^.amb
      - ^.ann
      - ^.bwt
      - ^.pac
      - ^.sa
    doc: BWT genome index

  - id: pon_sgl_file
    type: File
    inputBinding:
      prefix: --pon_sgl_file
    doc: Panel of Normal for SGL breakends

  - id: pon_sv_file
    type: File
    inputBinding:
      prefix: --pon_sv_file
    doc: Panel of Normal for SVs

  - id: known_hotspot_file
    type: File
    inputBinding:
      prefix: --known_hotspot_file
    doc: Known hotspot locations for SVs

outputs:
  - id: gridss_output_vcf
    type: File
    outputBinding:
      glob: $(inputs.gridss_output_vcf)
    doc: GRIDSS SV VCF

  - id: gripss_vcf
    type: File
    outputBinding:
      glob:  $(inputs.tumor_id).gripss.vcf.gz
    secondaryFiles:
      - .tbi
    doc: all non-hard-filtered SVs

  - id: gripss_vcf_filtered
    type: File
    outputBinding:
      glob: $(inputs.tumor_id).gripss.filtered.vcf.gz
    secondaryFiles:
      - .tbi
    doc: filtered for PASS and PON only SVs

doc: |
  Run GRIDSS and GRIPSS
