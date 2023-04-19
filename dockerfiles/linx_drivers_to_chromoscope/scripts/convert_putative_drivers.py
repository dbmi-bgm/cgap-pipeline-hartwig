import pandas as pd
import argparse

chromoscope_fields = ['top_category', 'category', 'biallelic', 'pos', 'gene', 'minCopyNumber', 'maxCopyNumber']


def convert_linx_drivers(args):
    """
    Convert a driver catalog from LINX into a TSV file compatible with Chromoscope.

    :param args: dictionary containing information provided by the user through CLI
    """

    linx_drivers = pd.read_csv(args["linx_drivers"], sep="\t", compression='gzip')
    genes_table = pd.read_csv(args["genes"], sep="\t", compression='gzip').drop_duplicates(subset=['gene'])

    genes_table['pos'] = (genes_table["start"] + round(((genes_table["end"] - genes_table["start"]) / 2))).astype(int)

    putative_drivers = linx_drivers.merge(genes_table, on='gene', how="left", validate="many_to_one")
    putative_drivers["top_category"] = putative_drivers['driver'].map({'AMP': 'CNV', 'DEL': 'CNV', 'DISRUPTION': 'SV'})
    putative_drivers["category"] = putative_drivers['driver'].map(
        {'AMP': 'amplification', 'DEL': 'deletion', 'DISRUPTION': 'disruption'})

    putative_drivers['biallelic'] = putative_drivers['biallelic'].map({True: "yes", False: "no"})
    putative_drivers['minCopyNumber'] = putative_drivers['minCopyNumber'].apply(lambda x: round(x, 1))
    putative_drivers['maxCopyNumber'] = putative_drivers['maxCopyNumber'].apply(lambda x: round(x, 1))
    putative_drivers[chromoscope_fields].to_csv(args["output"], sep="\t", index=False)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Convert LINX driver catalog into a file compatible with chromoScope.")
    parser.add_argument('--linx_drivers', '-d', help="LINX driver catalog (sample_id.driver.tsv)")
    parser.add_argument('--genes', '-g', help="Genes information used to calculate the midpoint of the driver genes.")
    parser.add_argument('--output', '-o', help="Output file", default="chromoscope_linx_drivers.tsv")
    args = parser.parse_args()
    convert_linx_drivers(vars(args))
