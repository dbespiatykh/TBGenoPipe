# TBGenoPipe

Tuberculosis Genomic Pipeline

### Installation

```bash
micromamba create -n snakemake -c conda-forge -c bioconda snakemake mamba

micromamba activate snakemake

# test
snakemake --conda-frontend mamba -np

# run
snakemake --conda-frontend mamba --use-conda -c 68
```
