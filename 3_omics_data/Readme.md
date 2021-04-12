# *Omics* data

National Center for Biotechnology Information [NCBI](https://www.ncbi.nlm.nih.gov/)

---
## Download reads

[fastq-dump](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc&f=fastq-dump)
``` 
fastq-dump --help
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRACODE
```

* Can take more than 12h with big files (>15G)
* --defline-seq '@$sn[_$rn]/$ri' without this flag trinity does not recognize the headers of the downloaded reads and gives an error
* --split-files in case of paired reads, to keep them separately in two different files

## Ensuring data integrity
[vdb-validate](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc&f=vdb-validate)
```
cd ~/ncbi/public/sra
vdb-validate sracode.sra
```
---
## Fastq

FASTQ format is a text-based format for storing both a biological sequence (usually nucleotide sequence) and its corresponding quality scores. Both the sequence letter and quality score are each encoded with a single ASCII character for brevity.

FASTQ file: four lines per sequence. 
* Line 1 begins with a '@' character and is followed by a sequence identifier and an optional description
* Line 2 is the raw sequence letters.
* Line 3 begins with a '+' character and is optionally followed by the same sequence identifier (and any description) again.
* Line 4 encodes the quality values for the sequence in Line 2, and must contain the same number of symbols as letters in the sequence

![header](https://raw.githubusercontent.com/MariangelaIannello/didattica/main/images/illumina_seq_id.png)

![ascii](https://raw.githubusercontent.com/MariangelaIannello/didattica/main/images/ascii_2.png)

![ascii_2](https://raw.githubusercontent.com/MariangelaIannello/didattica/main/images/ascii.png)

![ascii_3](https://raw.githubusercontent.com/MariangelaIannello/didattica/main/images/ascii33.gif)

---

## Fasta

FASTA format is a text-based format for storing biological sequences.

FASTA file: usually two lines per sequence.
* Line 1 begins with a '>' character and is followed by a sequence identifier and an optional description
*	Line 2 is the sequence.
---
## Reads quality check

[FASTQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

```
fastqc file.fastq file2.fastq .. [-o output dir] [-f fastq]
```

---
## Filter low quality reads
[Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)

```
trimmomatic PE -threads 5 -phred33 ../../SRR10293988_1.fastq ../../SRR10293988_2.fastq ./paired_1 ./unpaired_1 ./paired_2 ./unpaired_2 ILLUMINACLIP:/usr/local/anaconda3/share/trimmomatic-0.39-2/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:75 2> stats_trimmomatic 
```
* ILLUMINACLIP:TruSeq3-PE.fa:2:30:10  
    * path to adapters fasta;
    * seedMismatches: specifies the maximum mismatch count which will still allow a full match to be performed;
    * palindromeClipThreshold: specifies how accurate the match between the two 'adapter ligated' reads must be for PE palindrome read alignment;
    * simple clip threshold: the minimum score of the full alignment between adapter and read for the clipping to take place
* LEADING:3 #Remove leading low quality or N bases (below quality 3)
* TRAILING:3 #Remove trailing low quality or N bases (below quality 3)
* SLIDINGWINDOW:4:15
    * windowSize: specifies the number of bases to average across; 
    * requiredQuality: specifies the average quality required.
* MINLEN:36


![trimmomatic_1](https://raw.githubusercontent.com/MariangelaIannello/didattica/main/images/trimm_4_15.png)


