rm(list=ls())
setwd("D:/workspace/R/linear_regression")
library(reshape2)
eGFRchange <- read.csv("D:/workspace/R/linear_regression/eGFRchange.csv", header=F,row.names=1)
eGFR=eGFRchange[-1,]
ID=rownames(eGFR)
year=as.numeric(eGFRchange[1,])
eGFR_array=as.numeric(t(eGFR))
ID
eGFR_combined=data.frame(ID=rep(ID,each=length(year)),year=rep(year,times=length(ID)),eGFR=eGFR_array)
eGFR_final=eGFR_combined[!is.na(eGFR_combined[,3]),]

eGFR_down=as.data.frame(rep(NA,length(table(eGFR_final[,1])))) #建立一个预设为NA的向量，长度等于病人数
rownames(eGFR_down)=names(table(eGFR_final[,1]))
colnames(eGFR_down)='eGFR_down'

for(i in rownames(eGFR_down)) {
  eGFR_data=eGFR_final[eGFR_final[,1]==i,]
  if(nrow(eGFR_data)>2) {
    model = lm(eGFR ~ year, data=eGFR_data)
    eGFR_down[i,1]=coef(model)[2]
  }
}
write.csv(eGFR_down,"eGFR_down.csv")

boxplot(eGFR_down[,1])
hist(eGFR_down[,1])
shapiro.test(eGFR_down[,1])
