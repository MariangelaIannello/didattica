if (!requireNamespace("BiocManager", quietly=TRUE))
  install.packages("BiocManager")

BiocManager::install("topGO")

#older R versions
#source("http://bioconductor.org/biocLite.R")
#biocLite()

#source("http://bioconductor.org/biocLite.R")
#biocLite("topGO")

library(topGO)


geneID2GO=readMappings(file="all_genes_annotation_ok")
str(head(geneID2GO))
geneNames <- names(geneID2GO)
head(geneNames)
int_genes= read.table("genes_of_interest", sep = "\t")
gene_int_list <- as.vector(int_genes$V1)
str(gene_int_list)
geneList <- factor(as.integer(geneNames %in% gene_int_list))
str(geneList)
names(geneList) <- geneNames
str(geneList)

GOdata <- new("topGOdata", ontology = "BP", allGenes = geneList, annot = annFUN.gene2GO, gene2GO = geneID2GO)
resultFis <- runTest(GOdata, algorithm = "classic", statistic = "fisher")
resultFis
allGO= usedGO(object=GOdata)
allRes <- GenTable(GOdata, classicFisher = resultFis,ranksOf = "classicFisher", topNodes = length(allGO))
resultFis
write.table(allRes,file="topGOall_BP.txt", quote=FALSE, row.names=FALSE, sep = "\t")
