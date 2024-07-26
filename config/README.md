## A samples table for PE reads

| Run | R1 | R2 |
| --- | --- | --- |
| sample1 | ./path/to/sample1_1.fastq.gz | ./path/to/sample1_2.fastq.gz |
| sample2 | ./path/to/sample2_1.fastq.gz | ./path/to/sample2_2.fastq.gz |

### Description:
`Run` - Names of your samples. <br />
`R1` - Full path to the first FastQ read or to the single-end FastQ read. <br />
`R1` - Full path to the second FastQ read. <br />

**To make samples table with your PE reads, you can use the following code:**

```bash
#!/usr/bin/env bash

echo -e "Run\tR1\tR2" > samples.tsv

for f in reads/*_1.fastq.gz; do
    full_path=$(realpath "$f")
    base=$(basename "$f" _1.fastq.gz)
    r2_path="${full_path%_1.fastq.gz}_2.fastq.gz"
    printf '%s\t%s\t%s\n' "$base" "$full_path" "$r2_path" >> samples.tsv
done
```

> [!NOTE]
> Change directory `reads`, and `_1`, and `_2` to suitable in your case values

## A samples table for SRA accessions

| Run | LibraryLayout |
| --- | --- |
| SRR****** | PAIRED |
| SRR****** | SINGLE |

### Description:
`Run` - SRA accession. <br />
`LibraryLayout` - Type of sequence run layout, paired-end (PAIRED) or single-end (SINGLE).  <br />

**To make samples table from a list of SRA accessions, you can use the following code:**

```bash
#!/usr/bin/env bash

input=accessions.txt
file=samples.tsv

echo -e "Run\tLibraryLayout" >"$file"

epost -db sra -input "$input" |
  esummary |
  sed 's/<PAIRED\/>/PAIRED/g; s/<SINGLE\/>/SINGLE/g' |
  xtract -pattern DocumentSummary -element Runs/Run@acc -block Library_descriptor -element LIBRARY_LAYOUT >>"$file"
```
> [!NOTE]
> Requires [Entrez Direct (EDirect)](https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/).
