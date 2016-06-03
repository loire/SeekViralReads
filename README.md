SeekViralReads
======

install
=======
This script is to be executed on cc2-login (southgreen cluster). It will take as argument two fastq files and fasta files with the potential contaminent sequences.

vsearch, seqtk and flash binaries are provided, make sure to copy or link them in ~/bin or any other directory in the $PATH


First time, use 
```bash
git clone https://github.com/loire/SeekViralReads 
```
in a directory of your account.
To update, just type 
```bash
git pull 
```
in the same directory 


usage 
======

```bash
 qsub script_viral_reads_clean_merge_and_blast_cluster.sh $R1.fastq $R2.fastq filtering_sequences.fasta
```

purpose
======

This script aims at finding viral reads in a paired-end fastq datasets. 
Steps are: 

 1.  cutadapt to remove adapters. Adapters sequences are currently hard coded   
 2.  filter reads by mapping them with bwa on hosts and bacterial 16S sequences (the filtering_sequences.fasta file, provided by the user    
 3.  merge reads pairs when possible with flash    
 4.  blast resulting merged and orphan reads on viral databases located on the cluster   
   * on a complete viral nucléotide databse, with blastn    
   * on the viral Refseq database (complete genome), with blastn      
   * on a complete viral protein database (blastx), with blastx     


