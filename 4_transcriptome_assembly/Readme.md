# Transcriptome assembly
Reads are usually much shorter than the transcripts,we need to reconstruct the transcripts

[Trinity](https://github.com/trinityrnaseq/trinityrnaseq/wiki)

( There are many other tools: [Spades](http://cab.spbu.ru/software/spades/), [Transabyss](https://github.com/bcgsc/transabyss), [Velvet](https://www.ebi.ac.uk/~zerbino/velvet/) and [Oases](https://github.com/dzerbino/oases), [A5](https://chipster.csc.fi/manual/a5-miseq.html) etc..)

## Trinity
1)	Genome guided assembly

    ```
    Trinity --genome_guided_bam rnaseq.coordSorted.bam \
            --genome_guided_max_intron 10000 \
            --max_memory 10G --CPU 10 

    ```
2)	De novo assembly 

    ```
    Trinity --seqType fq --left reads_1.fq --right reads_2.fq --CPU 6 --max_memory 20G 
    ```
    --trimmomatic

    --quality_trimming_params \<string\>
    
    defaults to: "ILLUMINACLIP:/usr/local/anaconda3/opt/trinity-2.1.1/trinity-plugins/Trimmomatic-0.32/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:5 LEADING:5 TRAILING:5 MINLEN:25"


> MEMORY: ~ 1G disk space per 1M illumina reads; ~ 1G RAM per 1M illumina reads


### Trinity output


![Trinity_output](https://raw.githubusercontent.com/MariangelaIannello/didattica/main/images/Screenshot_2021-03-10%20trinityrnaseq%20trinityrnaseq.png)

'TRINITY_DN1000_c115_g5_i1' indicates Trinity read cluster 'TRINITY_DN1000_c115', gene 'g5', and isoform 'i1'. 

The Path information stored in the header ("path=[31015:0-148 23018:149-246]") indicates the path traversed in the Trinity compacted de Bruijn graph to construct that transcript.

---
## Transcriptome Assembly Quality Assessment

Once your assembly is complete, you'll want to know how 'good' it is

1) Examine the RNA-Seq read representation of the assembly. Ideally, at least ~80% of your input RNA-Seq reads are represented by your transcriptome assembly

2) Use BUSCO to explore completeness according to conserved ortholog content. 

    [gVolante](https://gvolante.riken.jp/analysis.html) 

3) Compute the N50 transcript contig length
   
   ``` 
    TrinityStats.pl input.fasta > output.txt
    ```

## Isoforms redundancy
 * ``` perl /usr/local/anaconda3/opt/trinity-2.1.1/util/misc/get_longest_isoform_seq_per_trinity_gene.pl Trinity.fasta > output.fasta``` 
 * [Cd-hit](http://weizhongli-lab.org/cd-hit/) 
    ```
    cd-hit-est -i input.fasta -o output.fasta -T 12 -t 1 –c 0.9
    ```
    -c sequence identity threshold, default 0.9 \
    -T n. of processores \
    -t tolerance for redundance, default 2
