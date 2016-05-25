#!/bin/bash
#$ -cwd
#$ -V
#$ -N SeekViralReads
#$ -q normal.q
#$ -pe parallel_smp 15
nthread=15
# Modify both 15 above to change the number of threads used by the pipeline

# Goal: Take two MiSeq pair-end fastq reads files of viral sample, clean for sequencing error and adapter (sequence hardcoded below), map on host genome and bacterial 16S, merge overlapping remaining pair when possible and blast merged and single reads on a viral nt database  

# added: also blastx the viral_nr database 


# usage: qsub script_viral_reads_clean_merge_and_blast_cluster.sh file_R1.fastq file_R2.fastq

# output: 	log files of most steps (see log... txt file)
#		"file"_reads_potential_viral.fasta: fasta file of reads sequences  
#		"file"_blast_vir_results.txt : blast results of reads sequences  on a viral nt database (TODO: blastx on vi_nr?)
#		

module load system/python/2.7.9/
module load bioinfo/cutadapt/default/
module load compiler/gcc/4.9.2
module load bioinfo/bwa/0.7.12
module load bioinfo/samtools/1.3
module load system/java/jre8
module load bioinfo/picard-tools/1.130
module load bioinfo/ncbi-blast/2.2.30

# Needs the following additional program in your path
# Flash (https://sourceforge.net/projects/flashpage/)
# seqtk (https://github.com/lh3/seqtk)


# adapter sequence in 3' and 5'
A3=CAGCGGACGCCTATG
A5=CATAGGCGTCCGCTG

# reads file names
R1=$(basename $1)
R2=$(basename $2)

# extract basename of reads file to create further filename
arrIN=(${R1//_/ })
basen=${arrIN[0]}

# set reference for filtering (16S and host genome) 

ref=$3


 options of cutadapt
 n: trim max number of adapters
 m: keep reads at least that long
 q: quality trimming (phread score)
 O: overlap (not threads)

cutadapt -n 5 -a $A3 -g $A5 -A $A3 -G $A5 -O 15 -m 40 -q 30,30 -o cleaned_$R1  -p cleaned_$R2  $1 $2 &> log_cutadapt_$basen

# suppress the 25 last base of R2 (maybe this part should be commented: in this case, comment the towo 

#seqtk trimfq -e 25 cleaned_$R2 > trim_cleaned_$R2
# Rename first read file so it matches the second
#mv trim_cleaned_$R2 cleaned_$R2

# extract first part of reads name  to create a common base filename for both reads 
arrIN=(${R1//_/ })
basen=${arrIN[0]}

# index ref

bwa index $ref

# map on host genomes / bacterial 16S

bwa mem -t $nthread $ref cleaned_$R1 cleaned_$R2 2> log_bwa_$basen | samtools view -b - > Contamination_"$basen".bam

# get some stats on the alignement of reads on the host + bacterial 16S sequences :

samtools flagstat Contamination_"$basen".bam > Stats_mapping_contaminent_"$basen".txt

# Extract correctly unmapped properly paired reads in a bam file  :

samtools view -b -hf 0x4 Contamination_"$basen".bam > sample_unmapped_"$basen".bam

# Extract reads from bam file:

java -jar /usr/local/bioinfo/picard-tools/1.130/picard.jar SamToFastq I=sample_unmapped_"$basen".bam F=filtered_$R1 F2=filtered_$R2 2> log_picard_"$basen".txt

# merge overlapping reads with flash 

./flash -M 100 -t $nthread filtered_$R1 filtered_$R2 &> log_flash_"$basen".txt

# fastq2fasta for the three reads files (merge and singleton)
for i in out*fastq ; do ./seqtk seq -A $i >> "$basen"_reads_potential_viral.fasta ; done 

# blast on viral database (in ~/save/blastdb)
# parameters used: n threads, only best alignment is reported, output is a simple tabular file with accession number

blastn -db /homedir/loire/work/share/ViralBlastDB/Viral_NT_sequences.fasta -query "$basen"_reads_potential_viral.fasta -num_threads $nthread -evalue 0.05 -num_alignments 1 -outfmt 6 > "$basen"_blast_vir_NT_results.tsv

blastn -db /homedir/loire/work/share/ViralBlastDB/refseqVirNuc.fasta  -query "$basen"_reads_potential_viral.fasta -num_threads $nthread -evalue 0.05 -num_alignments 1 -outfmt 6 > "$basen"_blast_vir_RefSeq_results.tsv

blastx -db /homedir/loire/work/share/ViralBlastDB/AA_VIR -query "$basen"_reads_potential_viral.fasta -num_threads $nthread -evalue 0.05 -num_alignments 1 -outfmt 6 > "$basen"_blast_vir_AA_results.tsv

# clean intermediate files

rm  out* clean* filtered* *.bam




