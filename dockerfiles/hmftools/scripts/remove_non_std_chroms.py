#!/usr/bin/env python3

##################################################################################
#
#       Script to exclude non standard chromosomes i.e GL000225.1
#
##################################################################################


from granite.lib import vcf_parser
import argparse

# Constants
CHR_PREFIX = "chr"

# list of standard chromosomes
std_chromosomes = [str(chrom) for chrom in list(range(1, 23))] + ["X", "Y"]
std_chromosomes += [CHR_PREFIX + chrom for chrom in std_chromosomes]

################################################
#   Functions
################################################


def main(args):
    output_file = args["outputfile"]

    vcf = vcf_parser.Vcf(args["inputfile"])

    with open(output_file, "w") as output:
        vcf.write_header(output)

        for vnt in vcf.parse_variants():
            # Exclude non standard chromosomes
            if vnt.CHROM in std_chromosomes:
                vcf.write_variant(output, vnt)


################################################
#   Main
################################################

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Remove non standard chromosomes from a VCF file. This script excludes all the variants that are not chromosomes 1-22, X or Y. "
    )

    parser.add_argument("-i", "--inputfile", help="input VCF file", required=True)
    parser.add_argument("-o", "--outputfile", help="output VCF file", required=True)

    args = vars(parser.parse_args())

    main(args)
