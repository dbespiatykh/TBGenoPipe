To make samples table with your PE reads, you can use the following code:

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
