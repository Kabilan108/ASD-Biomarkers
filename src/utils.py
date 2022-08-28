"""
Useful functions for this project.
"""

# Imports
import subprocess
import pandas as pd

from ToolBox.utils import tempdir


RSCRIPT = "/home/kabil/.anaconda3/envs/R/bin/Rscript"


def compute_group_differences(data):
    """
    Compute group differences (Student's t-test) between ASD and TDC by 
    passing the data to R.
    """

    # Directory for temporary files
    temp = tempdir('r-portal')

    # Save the data frame
    raw_path = temp.joinpath('raw_data.csv')
    out_path = temp.joinpath('results.csv')
    data.to_csv(raw_path, index=False)

    # R script to compute the differences
    rscript = f"""
        options(warn=-1)

        # Load data
        df <- readr::read_csv('{raw_path}') |>
            tidyr::pivot_longer(-(1:7), names_to='measure', values_to='value') |>
            dplyr::group_by(measure)

        # Compute group differences
        stats <- df |>
            rstatix::t_test(value ~ DX, var.equal=FALSE) |>
            rstatix::adjust_pvalue(method='BH') |>
            dplyr::select(measure, p, p.adj)

        # Compute effect sizes
        effects <- df |>
            rstatix::cohens_d(value ~ DX, var.equal=FALSE) |>
            dplyr::select(measure, effsize)

        # Prepare results
        group_diff <- dplyr::inner_join(stats, effects, by=c('measure')) |>
            stats::setNames(c('Measure', 'P Value', 'Adjusted P Value', 'Effect Size')) |>
            dplyr::arrange(Measure)

        # Save results to temporary file
        group_diff |>
            readr::write_csv('{out_path}')
    """

    # Run R script
    e = subprocess.call([RSCRIPT, '-e', rscript])

    if e != 0:
        raise Exception('R script failed')

    # Load results
    results = pd.read_csv(out_path)

    # Delete temporary files
    subprocess.call(['rm', raw_path, out_path])

    return results
