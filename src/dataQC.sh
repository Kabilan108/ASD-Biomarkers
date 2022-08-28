#!/bin/bash

# Define paths to bash/python scripts
PY="/home/kabil/.anaconda3/envs/neuro/bin/python"
qc="${PY} /home/kabil/Vault/ToolBox/neuro/cli.py qc"

# QC fo Desikan86 Connectomes
echo "Desikan86 Connectome QC"
$qc --indir '/home/kabil/Vault/Coursework/CS-T680/AutismCNN/data/CHARM/Desikan_sift2/' \
    --outdir '/home/kabil/Vault/Coursework/CS-T680/AutismCNN/data/CHARM/Desikan_sift2/qc/' \
    --subjects '/home/kabil/Vault/Coursework/CS-T680/AutismCNN/data/CHARM/subjects.txt' \
    --file-stub '_desikan_connmat_sift2.txt' \
    --name-pattern 'R\d*_V\d*' \
    --nodes 86 \
    --hemisphere-map '/home/kabil/Vault/Coursework/CS-T680/AutismCNN/data/hemispheremap_Desikan86.txt' \
    --std 3 \
    --modality 'structural' \
    --no-droplastnode \
    --no-zero-diag

# QC for Schaefer200 Connectomes
echo "Schaefer200 Connectome QC"
$qc --indir '/home/kabil/Vault/Coursework/CS-T680/AutismCNN/data/CHARM/Schaefer200_sift2/' \
    --outdir '/home/kabil/Vault/Coursework/CS-T680/AutismCNN/data/CHARM/Schaefer200_sift2/qc/' \
    --subjects '/home/kabil/Vault/Coursework/CS-T680/AutismCNN/data/CHARM/subjects.txt' \
    --file-stub '_DTI_Schaefer2018_200_7Networks_connmat_sift2' \
    --name-pattern 'R\d*_V\d*' \
    --nodes 220 \
    --hemisphere-map '' \
    --std 3 \
    --modality 'structural' \
    --no-droplastnode \
    --no-zero-diag
