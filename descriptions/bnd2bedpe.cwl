#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/bnd2bedpe:VERSION

baseCommand: [/usr/local/bin/bnd2bedpe.py]

inputs:
  - id: input_sv_vcf
    type: File
    inputBinding:
      prefix: --input
    doc: TODO

  - id: output_bedpe
    type: File
    inputBinding:
      prefix: --output
    default: "output.bedpe"
    doc: TODO

outputs:
  - id: output_sv_bedpe
    type: File
    outputBinding:
      glob: $(inputs.output_bedpe)
    doc: TODO

doc: |
  TODO
