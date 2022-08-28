"""data_trimming.py
Run this to trim the demographics file so that it only 
includes patients with corresponding connectomes.
"""

# Imports
import pandas as pd
import numpy as np

# Working directory
from os import chdir, listdir
chdir("/mnt/z/Vault/Coursework/CS-T680/project")


if __name__ == '__main__':

    # Load original demographics file
    demo = pd.read_csv('../data/CHARM/tobacco_demographics.csv')

    # Make lists of file IDs
    des_ids = np.array([x[:11] for x in listdir('../data/CHARM/Desikan_sift2')])
    sch_ids = np.array([x[:11] for x in listdir('../data/CHARM/Schaefer200_sift2')])

    # Check that IDs are in both lists
    if (des_ids != sch_ids).all():
        raise ValueError('Desikan and Schaefer connectome IDs don\'t match.')

    # Make list of overlapping IDs
    ids = np.intersect1d(np.intersect1d(des_ids, sch_ids), demo['Subject'])

    # Trim demographics file
    demo = (demo[demo.Subject.isin(ids)]
        .reset_index(drop=True)
        .rename({'ados_css': 'ADOS', 'scq_total': 'SCQ', 'iq': 'IQ'}, axis=1)
        .sort_values('Subject'))

    # Save trimmed demographics file
    demo.to_csv('../data/CHARM/demographics.tsv', index=False, sep='\t')