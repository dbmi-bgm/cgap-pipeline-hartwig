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
      prefix: --sample
    doc: tumor sample ID

  - id: reference_id
    type: string
    inputBinding:
      prefix: --reference
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
    default: "V38"
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

  - id: breakend_pon
    type: File
    inputBinding:
      prefix: --breakend_pon
    doc: TODO

  - id: breakpoint_pon
    type: File
    inputBinding:
      prefix: --breakpoint_pon
    doc: TODO

  - id: breakpoint_hotspot
    type: File
    inputBinding:
      prefix: --breakpoint_hotspot
    doc: TODO

outputs:
  - id: gridss_output_vcf
    type: File
    outputBinding:
      glob: $(inputs.gridss_output_vcf)
    
  - id: gripss_vcf_filtered
    type: File
    outputBinding:
      glob: $(inputs.tumor_id).gripss.filtered.vcf.gz
    secondaryFiles:
      - .tbi
  
  - id: gripss_vcf
    type: File
    outputBinding:
      glob:  $(inputs.tumor_id).gripss.vcf.gz
    secondaryFiles:
      - .tbi

doc: |
  Gridss
