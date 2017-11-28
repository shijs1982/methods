rm(list = ls())
setwd("~/R/methods/mysql/")
options(stringsAsFactors = FALSE)
#source("http://bioconductor.org/biocLite.R")
#options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
#biocLite("affyQCReport")
molecules_MN=read.csv('molecules_MN.csv')


library(RMySQL)
conn <- dbConnect(MySQL(), dbname = "rmysql", username="alfred", password="12345", host="127.0.0.1", port=3306)

dbListTables(conn)#查表
#dbRemoveTable(conn,'molecules_MN')
#dbWriteTable(conn, "molecules_MN", molecules_MN)#写表
dbListTables(conn)#查表
#dbRemoveTable(conn,'molecules_MN')#删表
###
dbGetQuery(conn, "show columns FROM molecules_MN")
genes_MN_all=dbGetQuery(conn, "SELECT DISTINCT Gene_sybmol FROM molecules_MN")#仅仅列出不同（distinct）的值

dbDisconnect(conn) #关闭连接
###
load("~/R/myfunction/ncbi_id_symbol.RData")
genes_MN=genes_MN_all[,1]
genes_MN=toupper(genes_MN)
genes_MN=unique(genes_MN)
genes_MN_common=intersect(genes_MN,Homo_sapiens.gene_info$Symbol)
genes_MN_common=genes_MN_common[order(genes_MN_common)]
setdiff(genes_MN,Homo_sapiens.gene_info$Symbol)
write.table(genes_MN_common,'genes_MN_common.txt',quote = F,row.names = F,col.names = F)
IDs_genes_MN_common=symbol2id[genes_MN_common,2]
write.table(IDs_genes_MN_common,'IDs_genes_MN_common.txt',quote = F,row.names = F,col.names = F)
table_MN_common=symbol2id[genes_MN_common,]
