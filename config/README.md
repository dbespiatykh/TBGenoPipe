To make samples table you can use this script:

```bash

for f in $(realpath reads_folder/*_R1.fastq.gz); do printf '%s\t%s\t%s\n' "$(basename "$f" _R1.fastq.gz)" "$f" "${f%_R1.fastq.gz}_R2.fastq.gz"; done | sed -E -e '1iRun\tR1\tR2' >samples.tsv


```
