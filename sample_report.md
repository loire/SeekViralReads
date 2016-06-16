 
# SeekViralReads results for sample **_"sample"_** 

---

## Adapters removal by cutadapt 

### command line:

```bash 
cutadapt  -n 5 -a CAGCGGACGCCTATGTGATGG -g CATCACATAGGCGTCCGCTG -A CAGCGGACGCCTATGTGATGG -G CATCACATAGGCGTCCGCTG -O 15 -o no_adaptor_sample_R1.fastq -p no_adaptor_sample_R2.fastq Data/sample_R1.fastq Data/sample_R2.fastq
```
### Results summary

| variable | value |
| --- | --- |
| Total read pairs processsed | 1,000 | 
| R1 with adapters |43 (4.3%)| 
| R2 with adapters | 33 (3.3%) | 
| R1 total length before | 249,799 bp | 
| R1 total length after | 247,655 bp | 
| R2 total length before | 244,066 bp  | 
| R2 total length after | 242,511 bp |
| Total length of filtered sequences (R1+R2) | 490,166 bp (99.3%) |
| Reads pairs written | 1,000 (100.0%) | 

## Quality trimming by cutadapt 

### command line:

```bash 
cutadapt  -a CAGCGGACGCCTATGTGATGG -g CATCACATAGGCGTCCGCTG -A CAGCGGACGCCTATGTGATGG -G CATCACATAGGCGTCCGCTG -m 40 -q 30,30 -o cleaned_sample_R1.fastq -p cleaned_sample_R2.fastq no_adaptor_sample_R1.fastq no_adaptor_sample_R2.fastq
```

### Results summary:

| variable | value |
| --- | --- |
| Total reads pairs processsed | 1,000 |
| R1 with adapters | 38 (3.8%) |
| R2 with adapters | 43 (4.3%) |
| R1 total length before | 247,655 bp |
| R1 total length after | 224,446 bp |
| R2 total length before | 242,511 bp  |
| R2 total length after | 182,841 bp |
| Total length of quality trimmed sequences | 407,287 bp (83.1%) |
| Reads pairs written | 940 (94.0%) |

## Mapping on contaminent sequences

```bash
bwa mem -t 15 Data/Bacterial16S_and_Aedes_vexans_genome.fasta cleaned_sample_R1.fastq cleaned_sample_R2.fastq
```

### Stats

| variable | value |
| --- | --- |
| Reads input   | 940 |
| Properly Mapped | 391  |
| Properly Mapped % | 41.60% |
| Mapped with mate to a different chrom  | 24   |
| Output reads | 525   |
