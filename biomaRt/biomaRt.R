rm(list = ls())
setwd("~/R/methods/biomaRt/")
options(stringsAsFactors = FALSE)
source("http://bioconductor.org/biocLite.R")
options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
#biocLite("biomaRt")

library("biomaRt") #载入biomaRt包
##
marts <- listMarts(); head(marts)
ensembl <- useMart("ensembl") #使用ensembl数据源
datasets <- listDatasets(ensembl); datasets[1:10,] 


mart <- useMart('ensembl',"hsapiens_gene_ensembl")

filters <- listFilters(mart); filters[grepl("entrez", filters[,1]),]
attributes <- listAttributes(mart); attributes[grepl("^ensembl|hgnc", attributes[,1]), ]

temp=getBM(attributes=c("entrezgene","hgnc_symbol"),
           filters = "entrezgene",
           values = genes_complement_activation$IDs,
           mart = mart)
