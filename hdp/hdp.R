rm(list = ls())
setwd("~/R/methods/hdp")
#source("https://bioconductor.org/biocLite.R")
#options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
#biocLite("BSgenome.Hsapiens.UCSC.hg19")
library(devtools)
library(knitr)
#Sys.getenv('PATH')
#system('g++ -v')
#system('where make')
#devtools::install_github("nicolaroberts/hdp", build_vignettes = TRUE)
#devtools::install_github("nicolaroberts/nrmisc")
library(hdp)
mycolors=rainbow(12)
citation('hdp')
data(luad_tcga, package='SomaticCancerAlterations')
data(lusc_tcga, package='SomaticCancerAlterations')

# necessary metadata. Only keep 100 samples. Then concatenate and sort.
for (cancer_name in c("luad","lusc")){
  raw <- get(paste0(cancer_name, "_tcga"))
  snv <- raw[which(raw$Variant_Type == "SNP")]
  snv <- snv[which(snv$Patient_ID %in% levels(snv$Patient_ID)[1:100])]
  mcols(snv) <- data.frame(sampleID=paste(cancer_name, snv$Patient_ID, sep='_'),
                           ref=snv$Reference_Allele,
                           alt=snv$Tumor_Seq_Allele2)
  assign(cancer_name, snv)
}

variants <- sort(c(luad,lusc))
remove(cancer_name, luad, luad_tcga,lusc,lusc_tcga, raw, snv)
# tally mutations per sample in 96 base subsitution classes by trinuc context
mut_count <- nrmisc::tally_mutations_96(variants)


genotypesImputed=as.matrix(mut_count)

n=ncol(genotypesImputed)
##
shape=1
invscale=1
hdp=hdp_init(ppindex=0,
             cpindex = 1,
             hh=rep(1/n,n),
             alphaa = shape,
             alphab = invscale
)

hdp=hdp_adddp(hdp,
              numdp=nrow(genotypesImputed),
              pp=1,
              cp=1)

hdp=hdp_setdata(hdp=hdp, dpindex = 1:nrow(genotypesImputed)+1, data = genotypesImputed)

hdp=dp_activate(hdp, 1:(nrow(genotypesImputed)+1),5)

burnin=5000
postsamples=1000
spacebw=20
cpsamples=10

#aaa=example_data_hdp
set.seed(20)
output=hdp_posterior(hdp,
                     burnin=burnin,
                     n=postsamples,
                     space=spacebw,
                     cpiter=cpsamples)


plot(output@lik, type='l')
abline(v=burnin, lty=3)

plot(output@numcluster,type='l')
output@hdp@dp[[3]]

posteriorMerged=hdp_extract_components(output,cos.merge = 0.95)

###
f_state=final_hdpState(posteriorMerged)
f_1=f_state@dp[[2]]
f_1@datacc
f_1@classnd
f_1@classnt
f_1@beta
f_1@datass
f_state@base@hh


posteriorSamples=as.matrix(posteriorMerged@hdp@base@classqq)
rownames(posteriorSamples)=colnames(genotypesImputed)
colnames(posteriorSamples)=1:ncol(posteriorSamples)
posteriorMeans=rowMeans(posteriorSamples);posteriorMeans=as.data.frame(posteriorMeans)
posteriorQuantiles=apply(posteriorSamples,1:2,quantile,c(0.025,0.5,0.975))
posteriorMode=apply(posteriorSamples, 1:2, function(x) {t=table(x);as.numeric(names(t)[which.max(t)])})
posterior=kable(posteriorQuantiles[2,,],"html",table.attr='id="=posteriorMedian"')
write(posterior,"temp.html")

###

genes=apply(posteriorSamples,2,function(x) paste(ifelse(x>10, rownames(posteriorSamples),"")[order(x,decreasing = T)[1:5]],collapse = ";"))
genes=gsub(";+$","",genes)
posteriorProbability=matrix(0,nrow=ncol(posteriorSamples),ncol=nrow(genotypesImputed))
#posteriorProbability=as.data.frame(posteriorProbability)
rownames(posteriorProbability)=colnames(posteriorSamples)
colnames(posteriorProbability)=rownames(genotypesImputed)
for(i in 1:ncol(posteriorProbability)){
  f_i=f_state@dp[[i+1]]
  posteriorProbability[,i]=f_i@beta
}
posteriorProbability=as.data.frame(posteriorProbability)

data.frame(Prob=rowMeans(posteriorProbability),genes)

##
dpClass=factor(apply(posteriorProbability,2,which.max))
table(dpClass)
table(dpClass[1:100])
table(dpClass[101:200])
plot(seq(0,1,l=ncol(posteriorProbability)),sort(apply(posteriorProbability,2,max)),
     type='l',ylim=c(0,1),xlab="Fraction of patients",ylab="Assignment probability")

boxplot(apply(posteriorProbability,2,max)~dpClass,ylab="Probability",xlab="Class")

###
par(mar=c(6,3,1,1)+.1,cex=.8)
o=order(colSums(genotypesImputed),decreasing=TRUE)
driverPrevalence=t(sapply(split(as.data.frame(as.matrix(genotypesImputed)),dpClass),colSums)[o,])
b=barplot(driverPrevalence,col=mycolors,las=2,legend=TRUE,border=NA,args.legend=list(border=NA),names.arg=rep("",ncol(genotypesImputed)))
abline(h=seq(100,500,100),col="white")
rotatedLabel(b,labels=colnames(genotypesImputed)[o])



