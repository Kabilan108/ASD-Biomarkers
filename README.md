# AutismCNN

Developing a CNN-based classfier for identifying connectomes from subjects with ASD.

## Dataset

- `CHARM` dataset provided by collaborators at Penn Medicine
  - Connectomes from 450 subjects in total, 313 of which passed Data QA check
  - 163 ASD (Autism-Spectrum Disorder) & 150 TDC (Typically Developing Controls)
  - 2 Sets of connectomes:
    - Desikan atlas with 86 parcellations
    - Schaefer atlas with 220 parcellations

## Replicating Results

```bash
# Clone the repository
git clone ...
cd ...

# Set up conda environment
conda install environment.yml

# Clean up demographics table
python 
```