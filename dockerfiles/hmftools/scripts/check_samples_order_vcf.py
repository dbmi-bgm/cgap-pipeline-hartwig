#!/usr/bin/env python3

##################################################################################
#
#       Script to check the order of sample columns and reformat them in the provided order
#
##################################################################################

from granite.lib import vcf_parser
import argparse

def write_variant(vnt_obj, ID_list, output):
    """Reorder the sample columns according to the ID_list and write the variant to a file
    :param vnt_obj: Variant object
    :type vnt_obj: vcf_parser.Vcf
    :param ID_list: List of sample IDs in the expected order
    :type ID_list: list
    :param output: output file buffer
    :type output: io.TextIOWrapper
    """
    variant_as_list = [vnt_obj.CHROM,
                       str(vnt_obj.POS),
                       vnt_obj.ID,
                       vnt_obj.REF,
                       vnt_obj.ALT,
                       vnt_obj.QUAL,
                       vnt_obj.FILTER,
                       vnt_obj.INFO]
    variant_as_list.append(vnt_obj.FORMAT)  # add FORMAT column
    for IDs_genotype in ID_list:
        variant_as_list.append(vnt_obj.GENOTYPES[IDs_genotype])

    variant_as_list[-1] = variant_as_list[-1] + "\n"
    output.write("\t".join(variant_as_list))

def main(args):

    output_file = args["outputfile"]
    order = args["order"]
    vcf = vcf_parser.Vcf(args["inputfile"])

    vcf_columns = ['#CHROM', 'POS', 'ID', 'REF', 'ALT', 'QUAL', 'FILTER', 'INFO', 'FORMAT']

    if len(order) != len(vcf.header.IDs_genotypes):
        raise Exception(f"Wrong number of sample IDs. Provided IDs {order}, actual IDs: {vcf.header.IDs_genotypes}")
    for ID in order:
        if ID not in vcf.header.IDs_genotypes:
            raise Exception(f"Missing ID {ID} in {vcf.header.IDs_genotypes}")

    with open(output_file, "w") as output:

        vcf_obj = vcf_parser.Vcf(args['inputfile'])
        #write the header
        vcf_obj.write_definitions(output)

        #modify the sample columns
        vcf_columns += order
        vcf_columns[-1] = vcf_columns[-1] + "\n"

        output.write("\t".join(vcf_columns))

        #parsing the VCF file
        for vnt_obj in vcf_obj.parse_variants():
            write_variant(vnt_obj, order, output)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Check the order of sample columns and reformat them in the provided order")

    parser.add_argument("-i", "--inputfile", help="input VCF file", required=True)
    parser.add_argument("-o", "--outputfile", help="output VCF file", required=True)
    parser.add_argument("-r", "--order", nargs="+", help="Order of the samples in VCF", required=True)

    args = vars(parser.parse_args())

    main(args)
