if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("KEGGREST")


if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("Biostrings")



library(KEGGREST)
cgr.seq=keggGet(c("crg:105317345","crg:105318076","crg:105318218","crg:105318342","crg:105318400","crg:105318401","crg:105318424","crg:105318622","crg:105319097","crg:105319124"), "aaseq") 
library(Biostrings)
writeXStringSet(cgr.seq,"cgr_oxphos.fa", format = "fasta")
