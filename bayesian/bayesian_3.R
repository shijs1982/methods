rm(list = ls())
setwd("~/R/methods/bayesian/")
options(stringsAsFactors = FALSE)
#source("http://bioconductor.org/biocLite.R");
#biocLite("affycoretools")

# Goal: Toss a coin N times and compute the running proportion of heads.
N = 500 # Specify the total number of flips, denoted N.
# Generate a random sample of N flips for a fair coin (heads=1, tails=0)
# the function "sample" is part of R:
set.seed(47405) 
flipsequence = sample(x=c(0,1), prob = c(.5,.5), size = N, replace = TRUE)
# Compute the running proportion of heads:
r = cumsum(flipsequence)
n=1:N 
runprop=r/n # component by component division
plot(n,runprop,type = 'o', log = 'x',
     xlim = c(1,N), ylim = c(0.0,1.0), cex.axis = 1.5,
     xlab = 'Flip Number', ylab = 'Proportion Heads', cex.lab = 1.5,
     main = 'Running Proportion of Heads', cex.main = 1.5
     )
lines(c(1,N),c(.5,.5),lty=3)
