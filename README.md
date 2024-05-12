# TBGenoPipe

Tuberculosis Genomic Pipeline

### Installation

#### Conda

```bash
git clone https://github.com/dbespiatykh/TBGenoPipe.git && cd TBGenoPipe

micromamba create -n snakemake -c conda-forge -c bioconda snakemake mamba

micromamba activate snakemake

chmod +x TBGenoPipe

# test
./TBGenoPipe -t 6 --type fastq -i config/reads_PE_SE.tsv --test

# run
./TBGenoPipe -t 6 --type fastq -i config/reads_PE_SE.tsv -o results_output
```

#### Docker

```bash
git clone https://github.com/dbespiatykh/TBGenoPipe.git && cd TBGenoPipe

chmod +x TBGenoPipe

docker pull --platform linux/amd64 snakemake/snakemake:stable

#test
sudo docker run \
	-it \
	--rm \
	-v "$(pwd)":/mnt/TBGenoPipe \
	--platform linux/amd64 snakemake/snakemake:stable \
	bash -c "cd /mnt/TBGenoPipe && ./TBGenoPipe -t 6 --type fastq -i config/reads_PE_SE.tsv --test"

#run
sudo docker run \
	-it \
	-rm \
	-v "$(pwd)":/mnt/TBGenoPipe \
	--platform linux/amd64 snakemake/snakemake:stable \
	bash -c "cd /mnt/TBGenoPipe && ./TBGenoPipe -t 6 --type fastq -i config/reads_PE_SE.tsv -o results_output"
```

### Usage

```bash
TBGenoPipe (A pipilene for Mycobacterium tuberculoisis genomic analysis)

Usage: TBGenoPipe [options]

Options:
--type [sra/fastq]                   Type of the input data
-i, --input                          Input samples table
-o, --output                         Output directory
-t, --threads                        Number of threads to use
--test                               Run pipeline in a dry-run mode
```
