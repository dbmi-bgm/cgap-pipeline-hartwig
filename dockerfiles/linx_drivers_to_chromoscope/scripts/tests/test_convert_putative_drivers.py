#################################################################
#   Libraries
#################################################################
import os
import pytest
import filecmp


convert = __import__("convert_putative_drivers")


def test_convert_linx_drivers(tmp_path):
    """
    Test for driverCatalogVCF
    """
    output = f"{tmp_path}/out.tsv"
    # Variables and Run
    args = {
        "linx_drivers": "tests/files/GAPFI7K5EHIG.tsv.gz",
        "genes": "tests/files/GAPFI6BQNY5O.tsv.gz",
        "output": output
    }

    convert.convert_linx_drivers(args)

    assert True == filecmp.cmp(output, "tests/files/chromoscope_linx_drivers.tsv")
