rm(list = ls())
setwd("~/R/methods/bayesian/")
options(stringsAsFactors = FALSE)
#source("http://bioconductor.org/biocLite.R");
#biocLite("affycoretools")

##
x=seq(from=-2,to=2,by=0.1)
y=x^2
plot(x,y,type = 'l')
dev.copy2eps(file='SimpleGraph.eps')
