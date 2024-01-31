# TBGenoPipe

Tuberculosis Genomic Pipeline

### Installation

#### Conda

```bash
git clone https://github.com/dbespiatykh/TBGenoPipe.git && cd TBGenoPipe

micromamba create -n snakemake -c conda-forge -c bioconda snakemake mamba

micromamba activate snakemake

# test
snakemake --conda-frontend mamba -np

# run
snakemake --conda-frontend mamba --use-conda -c 48 --keep-going --retries 5 --rerun-incomplete
```

#### Docker

```bash
git clone https://github.com/dbespiatykh/TBGenoPipe.git && cd TBGenoPipe

docker pull --platform linux/amd64 snakemake/snakemake:stable

#test
sudo docker run \
	-it \
	-v "$(pwd)":/mnt/TBGenoPipe \
	--platform linux/amd64 snakemake/snakemake:stable \
	bash -c "cd /mnt/TBGenoPipe && snakemake --conda-frontend mamba -np"

#run
sudo docker run \
	-it \
	-v "$(pwd)":/mnt/TBGenoPipe \
	--platform linux/amd64 snakemake/snakemake:stable \
	bash -c "cd /mnt/TBGenoPipe && snakemake --conda-frontend mamba --use-conda -c 48 --keep-going --retries 5 --rerun-incomplete"
```
