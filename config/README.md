To make samples table with your PE reads, you can use the following code:

```bash
for f in "$(realpath reads_folder/*_R1.fastq.gz)"; do printf '%s\t%s\t%s\n' "$(basename "$f" _R1.fastq.gz)" "$f" "${f%_R1.fastq.gz}_R2.fastq.gz"; done | sed -E -e '1iRun\tR1\tR2' >samples.tsv
```

> [!NOTE]
> Change "reads_folder", "R1", and "R2" to suitable in your case values
