if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("NOISeq")

library(NOISeq)

matrix_dg <- read.table("Rph_dg_counts", sep = " ",header = TRUE, row.names = 1)
View(matrix_dg)
matrix_dg=matrix_dg[,-27] #remove decussatus
factors <- data.frame(dg_conditions = c("CH_T1","CH_T1","CH_T1","CH_T1","CH_T1","CH_T3","CH_T3","CH_T3","CH_T3","CH_T3","CH_W","CH_W","CH_W","CH_W","CH_W","PM_T1","PM_T1","PM_T1","PM_T1","PM_T1","PM_T3","PM_T3","PM_T3","PM_T3","PM_T3","PM_W","PM_W","PM_W","PM_W"))

dg_noiseq <- readData(data=matrix_dg, factors = factors)
dg_noiseq
head(assayData(dg_noiseq)$exprs)
#dg_noiseq <- addData(dg_noiseq, length = mylength)

mycountsbio = dat(dg_noiseq, factor = NULL, type = "countsbio")
explo.plot(mycountsbio, toplot = 1, samples = NULL, plottype = "barplot")

#filter loci with low counts

myfilt10 = filtered.data(matrix_dg, factor = factors$dg_conditions, norm = FALSE, depth = NULL, method = 1, cv.cutoff = 100, cpm = 10, p.adj = "fdr")
dg_noiseq <- readData(data=myfilt10, factors = factors)
mycountsbio = dat(dg_noiseq, factor = NULL, type = "countsbio")
explo.plot(mycountsbio, toplot = 1, samples = NULL, plottype = "barplot")
dg_TMM10 = tmm(assayData(dg_noiseq)$exprs, long = 1000, lc = 0)
write.table(dg_TMM10, file="dg_tmm10", append = FALSE, eol="\n", quote = FALSE)


#Differential expression

factors_ch_pm_t0 <- data.frame(dg_conditions = c("CH_W","CH_W","CH_W","CH_W","CH_W","PM_W","PM_W","PM_W","PM_W"))
ch_pm_t0=dg_TMM10[,c(11:15,26:29)]
dg_noiseq_ch_pm_t0 <- readData(data=ch_pm_t0, factors = factors_ch_pm_t0)
mynoiseqbio_ch_pm_t0=noiseqbio(dg_noiseq_ch_pm_t0, k=0.1, norm="n", filter=0, factor="dg_conditions") 

#plot the average expression value and highlight the feature differentially expressed
DE.plot(mynoiseqbio_ch_pm_t0, q = 0.95, graphic = "expr", log.scale = TRUE)
dev.copy2pdf(file= "ch_pm_t0_expr.pdf")

#plot the log-FC , M=log-FC, D= |exprCond1 - exprCond2|
DE.plot(mynoiseqbio_ch_pm_t0, q = 0.95, graphic = "MD")
dev.copy2pdf(file= "ch_pm_t0_DM.pdf")