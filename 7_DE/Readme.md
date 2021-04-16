# Raw counts normalization and differential expression

[NOISEQ](https://bioconductor.org/packages/release/bioc/html/NOISeq.html )

Three modules:

    1. Quality control of count data
    2. Low-count filtering and normalization 
    3. Differential expression analysis

We need **raw counts**: data must be provided in a matrix or a data.frame R object. (Data can be both also normalized expression data such as RPKM values, and also any other normalized expression values).

We need to have **conditions** to perform differential expressions (males vs females, youngs vs old, different tissues or populations or species etc): factors are the variables indicating the experimental group for each sample.

> At least 3 replicates for condition

We may need length of our genes, basing on the normalization method we use


## 1. Quality control of count data

We need to check if the sequencing depth of the samples is enough to detect good quantification and differential expression. 

The **Saturation plot** shows the number of features in the genome detected with more than k counts with the sequencing depth of the sample, and with higher and lower simulated sequencing depths.

Features with low counts are, in general, less reliable and may introduce noise in the data.

The **Sensitivity plot** helps to decide the threshold to remove low-count features. It shows CPM (counts per million; counts scaled by tot n of reads x 1 million) for each sample.


## 2. Low-count filtering and normalization

Three methods for filtering. Method 1 (CPM) removes those features that have an average expression per condition less than cpm value and a coefficient of variation (standard_deviation/mean) per condition higher than cv.cutoff (in percentage) in all the conditions. 

Normalization is a crucial step in order to make the samples comparable. 

## 3. Differential expression analysis

The NOISeq package computes differential expression between two experimental conditions. There are two different approaches: NOISeq for technical replicates or no replication at all and **NOISeqBIO** which is optimized for the use of biological replicates.

NOISeq computes the differential expression statistics (θ) for each feature, using M (which is the log2-ratio of the two conditions) and D (the value of the difference between conditions). θ=(M+D)/2

A feature is considered to be differentially expressed if its
corresponding M and D values are likely to be higher than in noise.
By comparing the (M;D) values of a given feature against the noise distribution, NOISeq obtains the probability of differential expression for this feature.

> log2 fold change (B/A) of 1 means B is twice as large as A, while log2fc of 2 means B is 4x as large as A. Conversely, -1 means A is twice as large as B, and -2 means A is 4x as large as B.

When using NOISeqBIO, the probability of differential expression would be equivalent to 1 - FDR, where FDR can be considered as an adjusted p-value. In this case, it would be convenient to use q = 0.95.


# GO enrichment

To see if our genes of interest (for example genes differentially expressed in one condition), show an enrichment in some functional annotation.

We use [topGO](https://bioconductor.org/packages/release/bioc/html/topGO.html). topGO requires:

1. **Gene universe** the complete list of genes
2. **Genes of interest**
3. **GO annotation** with the followinf format:

    gene_ID\<TAB>GO_ID1, GO_ID2, GO_ID3, ....

There are two types of test statistics we can choose: Fisher's exact test which is based on **gene counts**, and a Kolmogorov-Smirnov like test which computes enrichment based on **gene scores**, which consider p-values.

One tools to visualize GO enrichment: [REVIGO](http://revigo.irb.hr/)
