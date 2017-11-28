rm(list = ls())
setwd("D:/workspace/R/methods/dpmixsim")
options(stringsAsFactors = FALSE)
#source("http://bioconductor.org/biocLite.R")
#options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
#biocLite()
library(dpmixsim)

## Not run: 
## Example 1: simple test using `galaxy' data
data("galaxy")
x0 <- galaxy$speed
x  <- prescale(x0) 
maxiter <- 4000; rec <- 3000; ngrid <- 100
res <- dpmixsim(x, M=1, a=1, b=0.1, upalpha=1, maxiter=maxiter, rec=rec,
                nclinit=4)
z <-  postdpmixciz(x=x, res=res, rec=rec, ngrid=ngrid, plot=T)
##
res <- dpmixsim(x, M=2, a=1, b=0.001, upalpha=0, maxiter=maxiter,
                rec=rec, nclinit=4)
z <-  postdpmixciz(x, res=res, rec=rec, ngrid=ngrid, plot=T)
##-----------------
## Example 2: 
demo(testMarronWand)
##-----------------
## Example 3: MRI segmentation
## Testing note: this example should reproduce the equivalent segmented
## images used in the author's references 
slicedata <- readsliceimg(fbase="t1_pn3_rf0", swap=FALSE)
image(slicedata$niislice, col=gray((0:255)/256), main="original image")
x0 <- premask(slicedata, subsamp=TRUE)
x  <- prescale(x0) 
rec <- 3000
res <- dpmixsim(x, M=1, a=1, b=1, upalpha=1, maxiter=4000,
                rec=rec, nclinit=8, minvar=0.002)
## post-simulation
ngrid <- 200
z <- postdpmixciz(x, res=res, rec=rec, ngrid=ngrid, plot=TRUE)
x0 <- premask(slicedata, subsamp=FALSE) # use full-sized image after estimation 
x  <- prescale(x0) 
cx   <- postdataseg(x, z, ngrid=ngrid)
cat("*** view grouped segmentations:\n")
postimgclgrp(slicedata$mask, cx, palcolor=FALSE)
cat("*** display all clusters:\n")
postimgcomps(slicedata$mask, cx)
cat("*** re-cluster with 4 clusters:\n")
postkcluster(slicedata$mask, cx, clk=4)

## End(Not run)