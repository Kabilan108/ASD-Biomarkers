"""
Useful functions for this project.
"""

# Imports
from sklearn.metrics import roc_curve, auc
from ToolBox.utils import tempdir
import matplotlib.pyplot as plt
import pandas as pd
import subprocess


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


def auc_roc_curve(clf, X_val, y_val, subtitle, path=None):
    """
    Plot ROC curve and return AUC given a prefit classifier and validation data
    """

    y_score = clf.decision_function(X_val)
    fpr, tpr, _ = roc_curve(y_val, y_score)
    roc_auc = auc(fpr, tpr)

    fig, ax = plt.subplots(figsize=(6,4))
    ax.plot(fpr, tpr, color='darkorange', lw=2,
            label=f'ROC Curve (Area = {roc_auc:0.2f})')
    ax.plot([0, 1], [0, 1], lw=2, linestyle='--', color='navy',
            label='Random Guess')
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.0])
    plt.xlabel("False Positive Rate")
    plt.ylabel("True Positive Rate")
    plt.title(f"Receiver Operating Characteristic Curve\n{subtitle}")
    plt.legend(loc="lower right")
    plt.show()

    if path is not None:
        fig.savefig(path)
    
    return roc_auc