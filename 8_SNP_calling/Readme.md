# SNP calling

**Pileup format** : text format for summarizing the base calls of aligned reads to a reference sequence.

```
samtools mpileup [options] input.bam
samtools mpileup -f MF.fasta -Q 30 -q 20 Sample_23_merged.sorted.bam #-Q min base quality -q min mapping quality -f rederence used in the mapping step
```

Pileup format:
1. Reference name
2. Position on reference
3. Reference base
4. Base depth
5. Info at that position from each mapping read 
    > . = base that matched the reference on the forward strand 

    > , = base that matched the reference on the reverse strand

    > AGTCN = base that did not match the reference on the forward strand

    > agtcn = base that did not match the reference on the reverse strand

    > ^ = start of read

    > $ = end of read

    > \+ = insertions (followed by the length of the insertion)

    > \- = deletions (followed by the length of the deletion)

6. Base quality 
----
## The role of depth in SNP calling

> NGS sequencing depth affects variant detection: the higher the depth, the higher the confidence to the base call at that position

```samtools depth -aa -q 20 -Q 30 Sample_23_merged.sorted.bam```
> take a look at the sequencing depth for each base

-aa print all positions of the reference genome, also those with 0 depth

-q calculate depth only for bases with min mapping quality of x

-Q calculate depth only for bases with min base qualiity of y

---
## Merge bam files from multiple samples
If we want analyze snps from multiple samples, we need to merge bam files from each sample. First, we need to make sure that each bam file has the information about sample name in the bam header. If not, we can use the addreplacerg subcommand of samtools:

```for i in Sample_*sorted.bam; do samtools addreplacerg -o $i"_prova_test.bam" -O BAM -r "@RG\tID:"${i:7:2}"\tLB:1\tPL:Illumina\tSM:"$i"" $i; done```

> Using variables may help us to handle multiple files at the same time

Now we can merge bam files using the merge subcommand of samtools:

```
samtools merge all.bam -b all.list 
#-b list of bam files
```
## SNP calling
[Freebayes](https://github.com/freebayes/freebayes): detecting SNPs (single-nucleotide polymorphisms), indels (insertions and deletions), MNPs (multi-nucleotide polymorphisms)

```
freebayes -f [REFERENCE] [OPTIONS] [BAM FILES] >[OUTPUT]

samtools faidx MF.fasta #index reference for freebayes with samtools

freebayes -f MF.fasta -b all.bam -q 20 -m 30 -p 1 --pooled-continuous -v all_merged_samples.vcf
```
Some options:

    -b bam file

    -f reference fasta

    -r region (if we are interested in only one chromosomse) chr1:1000-2000

    -s sample (limit di analysis to samples listed in file)

    -v vcf output

    -p ploidy (default 2)

    --pooled continuous (if we consider each sample as a population and we don’t know how many samples are in there)

    -m min mapping quality (default 1)

    -q min base quality (default 0)

## VCF format

The Variant Call Format (VCF) is a tab-delimited format for storing sequence variations.

It has three parts:

• A metadata header consisting of lines that start with ##

• A header line with the eight mandatory fields and if genotypes
are called, the individuals’ sample names

• The data lines, where each line consists of the information for
a variant at a particular position and all individuals’ genotypes
for this variant. 


```grep -v "##" all_merged_samples.vcf | less #take a look at vcf without description```

## VCF columns:

1.	CHROM chromosome names
2.	POS position on reference
3.	ID variant ID, if missing “.”
4.	REF allele on reference
5.	ALT alternative allele(s) found in our samples. If `*' : allele is missing due to a upstream deletion (some filter used)
6.	QUAL quality of called allele: Phred-scaled quality score that the call is wrong
7.	FILTER “.” If no filter applied; “PASS” if this position has passed all filters
8.	INFO additional information


### **Some useful INFO columns:**

**AB** Allele balance at heterozygous sites: a number between 0 and 1       representing the ratio of reads showing the reference allele to all reads, considering only reads from individuals called as heterozygous

**AC** Total number of alternate alleles in called genotypes

**AF** Estimated allele frequency in the range (0,1)

**AN** Total number of alleles in called genotypes

**AO** Count of full observations of this alternate haplotype.

**DP** Total read depth at the locus

**MQM** Mean mapping quality of observed alternate alleles

**MQMR** Mean mapping quality of observed reference alleles

**NS** Number of samples with data

**NUMALT** Number of unique non-reference alleles in called genotypes at this position.

---



### **GENOTYPE field :**

**GT** Genotype. The allele values are 0 for the reference allele, 1 for the first allele listed in ALT, 2 for the second allele list in ALT and so on. For diploid could be 0/1, 1/2, etc. If a call cannot be made for a sample at a given locus `.'

**DP** Read depth at this position for this sample

**AD** Number of observation for each allele

**RO** Reference allele observation count

**QR** Sum of quality of the reference observations

**AO** Alternate allele observation count

**QA** Sum of quality of the alternate observations

**GL** Genotype Likelihood, log10-scaled likelihoods of the data given the called genotype for each possible genotype generated from the reference and alternate alleles given the sample ploidy

---

## Filter VCF

[vcftool](https://vcftools.github.io/man_latest.html) for filtering vcf

```vcftools [ --vcf FILE] [ --out OUTPUT PREFIX ] [ FILTERING OPTIONS ] [ OUTPUT OPTIONS ]```

Some options:

    --chr #select only variants in that chromosome
    --not-chr #filter out that chromosome
    --from-bp <integer> --to-bp <integer> ##consider only variants in that range
    --remove-indels #filter out indels
    --keep-only-indels

Allele filtering options:

    --maf Include only sites with a Minor Allele Frequency greater than or equal to the "--maf". Allele frequency is defined as the number of times an allele appears over all individuals at that site, divided by the total number of non-missing alleles at that site.
    --non-ref-af Include only sites with all Non-Reference (ALT) Allele Frequencies (af) greater than or equal to the Output file comparing the sites in two vcf files
    Etc..

Genotype value filtering:

    --min-meanDP Includes only sites with mean depth values (over all included individuals) greater than or equal to the "--min-meanDP" value
    --minQ <float> Includes only sites with Quality value above this threshold.

Individual filtering options :

    --indv <string> # Specify an individual to be kept from the analysis. This option can be used multiple times to specify multiple individuals.
    --remove-indv <string> Specify an individual to be removed from the analysis. This option can be used multiple times to specify multiple individuals.
    --keep <filename> #filename with list of individuals to keep
    --remove <filename> #filename with list of individuals to remove
    
    Genotype filtering options :

        --minGQ <float> Exclude all genotypes with a quality below the threshold specified. 
        --minDP <float> Includes only genotypes greater than or equal to the "--minDP" value



Output VCF format:

    --out vcf outuput
    --recode generate a new file VCF from the input VCF file after applying the filtering options specified by the user. Important: By default, the INFO fields are removed from the output file, as the INFO values may be invalidated by the recoding (e.g. the total depth may need to be recalculated if individuals are removed)
    --recode-INFO-all keep all INFO values in the original file

Comparison options:

    --diff <filename> compare the original input file to this specified VCF
    --diff-site Outputs the sites that are common / unique to each file


Flags to print statistics (af for each position, summary, depth):

    --freq frequencies with information about the alleles
    --freq2 frequencies without information about the alleles
    --counts raw allele counts for each site 
    --depth mean depth per individual
    --site-depth depth per site summed across all individuals

Example filter vcf:

```vcftools --vcf all_merged_samples.vcf --indv Sample_02_merged --indv Sample_05_merged --indv Sample_08_merged --out male_ind_36x --chr M_assembly49 --non-ref-af 0.15 --minGQ 20 --minQ 30 --minDP 36 --recode --freq2``` 

Difference between two vcf:

```vcftools --vcf Sample_34.sam.bam.sorted.vcf --diff Sample_36.sam.bam.sorted.vcf --diff-site --out S34_34_diff```

