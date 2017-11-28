rm(list = ls())
setwd("D:/workspace/R/snps")
options(stringsAsFactors = FALSE)
#source("https://bioconductor.org/biocLite.R")
#biocLite("TxDb.Hsapiens.UCSC.hg19.knownGene")
#biocLite("SNPlocs.Hsapiens.dbSNP.20120608")
biocLite("SNPlocs.Hsapiens.dbSNP144.GRCh37")
library(VariantAnnotation)
library(TxDb.Hsapiens.UCSC.hg19.knownGene) # for annotation
library(org.Hs.eg.db)                      # to convert from Entrez Gene ID to Symbol
library(SNPlocs.Hsapiens.dbSNP144.GRCh37)

snps <- SNPlocs.Hsapiens.dbSNP144.GRCh37
temp=snpid2loc(snps, c('rs3753344','rs881375'))
names(temp)
as.numeric(temp)


input <- rbind.data.frame( c("rs3753344", "chr1", 1142150),
                           c("rs12191877", "chr6", 31252925),
                           c("rs881375", "chr9", 123652898) )
colnames(input) <- c("rsid", "chr", "pos")
input$pos <- as.numeric(as.character(input$pos))
input

target <- with(input,
               GRanges( seqnames = Rle(chr),
                        ranges   = IRanges(pos, end=pos, names=rsid),
                        strand   = Rle(strand("*")) ) )
target

#Alternatively you can read from a VCF file if you have one handy already and reduce all the codes above to:
#vcf    <- readVcf(filename, genome="hg19")
#target <- rowData(vcf)

library(TxDb.Hsapiens.UCSC.hg19.knownGene)
loc <- locateVariants(target, TxDb.Hsapiens.UCSC.hg19.knownGene, AllVariants())
names(loc) <- NULL
out <- as.data.frame(loc)
out$names <- names(target)[ out$QUERYID ]
out <- out[ , c("names", "seqnames", "start", "end", "LOCATION", "GENEID", "PRECEDEID", "FOLLOWID")]
out <- unique(out)
out

#convert from Entrez Gene IDs 
Symbol2id <- as.list( org.Hs.egSYMBOL2EG )
id2Symbol <- rep( names(Symbol2id), sapply(Symbol2id, length) )
names(id2Symbol) <- unlist(Symbol2id)

x <- unique( with(out, c(levels(GENEID), levels(PRECEDEID), levels(FOLLOWID))) )
table( x %in% names(id2Symbol) ) # good, all found

out$GENESYMBOL <- id2Symbol[ as.character(out$GENEID) ]
out$PRECEDESYMBOL <- lapply(out$PRECEDEID,function(x) as.character(id2Symbol[x]))
out$FOLLOWSYMBOL <- lapply(out$FOLLOWID,function(x) as.character(id2Symbol[x]))
out


