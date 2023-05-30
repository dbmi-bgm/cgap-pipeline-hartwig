#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/linx_drivers_to_chromoscope:VERSION

baseCommand: [python3, /usr/local/bin/convert_putative_drivers.py]

inputs:
  - id: linx_driver_catalog_tsv
    type: File
    inputBinding:
      prefix: --linx_drivers
    doc: File containing the driver catalog

  - id: genes
    type: File
    inputBinding:
      prefix: --genes
    doc: File containing genes available on CGAP

outputs:
  - id: chromoscope_drivers
    type: File
    outputBinding:
      glob: chromoscope_linx_drivers.tsv
    doc: Chromoscope compatible output driver catalog

doc: |
  Convert driver catalog from PURPLE/LINX into a TSV file compatible with Chromoscope
