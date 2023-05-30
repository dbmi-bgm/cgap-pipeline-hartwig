#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/bnd2bedpe:VERSION

baseCommand: [python3, /usr/local/bin/bnd2bedpe.py]

inputs:
  - id: input_sv_vcf
    type: File
    inputBinding:
      prefix: --input
    doc: VCF file containing structural variants in the BND notation

  - id: output_bedpe
    type: string
    inputBinding:
      prefix: --output
    default: "output.bedpe"
    doc: name of the output BEDPE file

outputs:
  - id: output_sv_bedpe
    type: File
    outputBinding:
      glob: $(inputs.output_bedpe)
    doc: output BEDPE file

doc: |
  Convert a VCF file containing SVs stored in the BND notation to the BEDPE format
