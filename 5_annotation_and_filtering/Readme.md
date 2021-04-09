# Annotation
Annotation tools that find similarities between sequences:

[Blast](https://blast.ncbi.nlm.nih.gov/Blast.cgi)

[Diamond](https://github.com/bbuchfink/diamond)

Annotation tool using probabilistic models:

[HMMER](http://hmmer.org/): use hidden Markov models (HMMs) profiles. It is often used together with a profile database, such as Pfam or many of the databases that participate in Interpro. 

## Databases

+ Nr: Non-redundant protein sequences from GenPept, Swissprot, PIR, PDF, PDB, and NCBI RefSeq
+ Swiss-Prot: manually annotated and reviewd proteins ([UniProt](https://www.uniprot.org/))
+ [Pfam](http://pfam.xfam.org/): is a large collection of protein families, each represented by multiple sequence alignments and hidden Markov models 
+ See also [InterPro consortium](http://www.ebi.ac.uk/interpro/)


## Annotate sequences with Diamond

[Diamond](https://github.com/bbuchfink/diamond) is optimized for large input files of >1 million proteins.

The program may use quite a lot of memory and also temporary disk space. Should the program fail due to running out of either one, you need to set a lower value for the block size parameter -b.

**-b**: Block size in billions of sequence letters to be processed at a time. This is the main parameter for controlling the program’s memory and disk space usage. Bigger numbers will increase the use of memory and temporary disk space, but also improve performance. The program can be expected to use roughly six times this number of memory (in GB).


### Makedb

```
diamond makedb --in /var/local/diamond_db/nr.gz --db ./nr_diamond --taxonmap prot.accession2taxid --taxonnodes nodes.dmp --taxonnames names.dmp
```
**--in** file: Path to the input protein reference database ﬁle in FASTA format (may be gzip compressed).

**--db**: Path to the output DIAMOND database ﬁle.

**--taxonmap**: optional. Path to mapping ﬁle that maps NCBI protein accession numbers to taxon ids. The ﬁle can be downloaded from NCBI: ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.gz.

**--taxonnodes** and **--taxonnames**: optional. Needs to be supplied in order to provide taxonomy features. The ﬁles can be downloaded from NCBI: ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdmp.zip.


### Diamond search

The sensitivity can be adjusted using the options --mid-sensitive, --sensitive, --more-sensitive, --very-sensitive and --ultra-sensitive.

```
diamond blastp --db /var/local/diamond_db/nr_diamond.dmnd --query input_fasta  -p CPU -o ouptup --outfmt 6 qseqid sseqid evalue bitscore pident staxids stitle --max-target-seqs 5 --evalue 0.005
```

(see [Blast manual](https://www.ncbi.nlm.nih.gov/books/NBK279668/#usermanual.BLAST_search_strategies) and [Diamond manual](https://github.com/bbuchfink/diamond))

**Bit-score**: the requires size of a sequence database in which the current match could be found just by chance. The higher the bit-score, the better the sequence similarity. The bit-score gives the same value for hits in databases of different sizes. It is independent of query sequence length and database. The bit-score depends on the raw alignment score. Thus, the higher the bit score, the more highly significant the match is.

**Blast e-value**: number of expected hits of similar quality (score) that could be found just by chance, given the same size of a random database. The E-value (expectation value) is a corrected bit-score adjusted to the sequence database size. 

E = m x n  / 2^bit-score

m = query sequence length

n = total database length (sum of all sequences)

**pident**:  % of identical matches

## BLAST search

```
blastn –db nt –query nt.fsa –out results.out -remote # create custum db
blastn –db nt –query nt.fsa –out results.out # blast search
```

## HMMER Search

**hmmbuild** build profile from input multiple alignment

**hmmsearch** search profile against sequence database

**hmmscan** search sequence against profile database

```
hmmscan [-options] /var/local/Pfam/Pfam-A.hmm <seqfile>
```

**-o** \<f> Direct the main human-readable output to a file <f> instead
of the default stdout.

**--tblout** \<f> Save a simple tabular (space-delimited) file summarizing the
per-target output, with one data line per homologous target
model found.

**--domtblout** \<f> Save a simple tabular (space-delimited) file summarizing
the per-domain output, with one data line per homologous
domain detected in a query sequence for each homologous
model.

**--pfamtblout** \<f> Save an especially succinct tabular (space-delimited) file
summarizing the per-target output, with one data line per
homologous target model found.

**-E** \<x> In the per-target output, report target profiles with an Evalue
of <= \<x>. The default is 10.0

**-T** \<x> Instead of thresholding per-profile output on E-value, instead
report target profiles with a bit score of >= \<x>.

**--domE** \<x> In the per-domain output, for target profiles that have already
satisfied the per-profile reporting threshold, report
individual domains with a conditional E-value of <= \<x>. The default is 10.0.

**--domT** \<x> Instead of thresholding per-domain output on E-value, instead
report domains with a bit score of >= \<x>.


## Gene Ontology

Useful links:

http://geneontology.org/

https://www.ebi.ac.uk/QuickGO/

http://amigo.geneontology.org/amigo

### Get GO terms from protein sequences

[Argot2](http://www.medcomp.medicina.unipd.it/Argot2/)

Input: blast and hmmer searches

BLAST and HMM searches MUST be performed against Uniprot and P-fam databases, respectively.

```
blastp -outfmt "6 qseqid sseqid evalue " -query your_sequences -db /var/local/uniprot/uniprot_sprot.fasta-norep -out output_file

hmmscan --tblout output_file /var/local/Pfam/Pfam-A.hmm your_protein_sequences
```

Once you have completed BLAST and/or HMMER searches you need to compress the tabular output files in zip format. The .zip files produced are ready to be submitted to Argot2.



[Pannzer2](http://ekhidna2.biocenter.helsinki.fi/sanspanz/)

Input: protein fasta

Pannzer2 use SANSparallel (Interactive homology search against Uniprot) to perform homology searches.


## KEGG PATHWAY

https://www.genome.jp/kegg/ # pathways db

https://www.genome.jp/kegg/kaas/ # assign pathways to our sequences

https://www.genome.jp/kegg/mapper.html 


# Filter contaminants

Starting from annotation file with taxid indication.
The filter.sh script retrieves, for each taxid, the complete taxonomic lineage. 

```
#!/bin/bash
#$1=diamond annotation
#$2=taxon to keep
#$3=fasta file

mkdir tmp_dir

awk '{print $1,$6}' "$1" > tmp_dir/tmp
cd tmp_dir
awk '{print $NF}' tmp > tmp1
taxonkit lineage tmp1 --data-dir /var/local/taxonkit/ > tmp3
paste tmp tmp3 > tmp4

grep "$2" tmp4 | awk '{print $1}' | sort | uniq -c > hit_selected_taxon
awk '{print $1}' tmp | sort | uniq -c > hit_diamond

paste hit_diamond hit_selected_taxon | awk '$5=$3/$1*100 {print $0}' | awk '$5==100 {print $0}' | awk '{print $2}' > keep_these
file="keep_these" ; name=$(cat $file) ; for i in $name ; do grep -w -A1 $i ../"$3"; done > ../"$1"_"$2"_filter.fasta

grep -c ">" ../"$1"_"$2"_filter.fasta > n_filtered
grep -c ">" ../"$3" > n_tot

echo "Filtering step completed! Kept" "$(<n_filtered)"  "out of" "$(<n_tot)" "sequences"

cd ..
rm -r tmp_dir
```

# Get ORFs

[TransDecoder](https://github.com/TransDecoder/TransDecoder/wiki)

+ Step 1: extract the long open reading frames

  ```TransDecoder.LongOrfs -t target_transcripts.fasta```

  -m mimimum ORF length, default 100 
  
+ Step 2: (optional)

  Optionally, identify ORFs with homology to known proteins via blast or pfam searches.
  ```
  # either diamond or blast
  
  diamond blastp --query transdecoder_dir/longest_orfs.pep --db uniprot_sprot.fasta --evalue 1e-05 --max-target-seqs 1 --threads 5 --outfmt 6 --out blastp.outfmt6
  
  blastp -query transdecoder_dir/longest_orfs.pep -db uniprot_sprot.fasta  -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 10 > blastp.outfmt6

  # hmmer 

  hmmscan --cpu 8 --domtblout pfam.domtblout /path/to/Pfam-A.hmm transdecoder_dir/longest_orfs.pep
  ```
+ Step 3: predict the likely coding regions

  ```TransDecoder.Predict -t target_transcripts.fasta --retain_pfam_hits pfam.domtblout --retain_blastp_hits blastp.outfmt6```
