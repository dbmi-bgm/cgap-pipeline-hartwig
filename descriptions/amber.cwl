#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/driver_catalog:VERSION

baseCommand: [python3, /usr/local/bin/somatic_annot.py, dumpJSON ]

inputs:
  - id: vcf
    type: File
    inputBinding:
      prefix: -v
    doc: VCF file containing SNVs and INDELs annotated with putative driver mutations and hotspot locations


outputs:

  - id: drivers_json
    type: File
    outputBinding:
      glob: $(inputs.output)
    secondaryFiles:
      - .tbi

doc: |
  TODO