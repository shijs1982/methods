rm(list = ls())
setwd("D:/workspace/R/methods/hmm")
options(stringsAsFactors = FALSE)
#source("http://bioconductor.org/biocLite.R")
#options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
#biocLite()

library(HMM)
# Initialise HMM
hmm = initHMM(c("A","B"), c("L","R"), 
              startProbs = c(0.5,0.5),
              transProbs=matrix(c(.8,.2,.2,.8),2),
              emissionProbs=matrix(c(.6,.4,.4,.6),2))
print(hmm)
# Sequence of observations
observations = c("L","L","R","R")
# Calculate forward probablities
logForwardProbabilities = forward(hmm,observations)
print(exp(logForwardProbabilities))
# Calculate backward probablities
logBackwardProbabilities = backward(hmm,observations)
print(exp(logBackwardProbabilities))
# Calculate Viterbi path
viterbi = viterbi(hmm,observations)
print(viterbi)

# Initial HMM
hmm = initHMM(c("A","B"),c("L","R"),
              transProbs=matrix(c(.5,.5,.5,.5),2),
              emissionProbs=matrix(c(.5,.5,.5,.5),2))
print(hmm)
# Sequence of observation
a = sample(c(rep("L",1000),rep("R",10000)))
b = sample(c(rep("L",300),rep("R",100)))
observation = c(a,b)

# Baum-Welch
bw = baumWelch(hmm,observation,100)
print(bw$hmm)



####
rm(list = ls())
library(HMMCont)
# Step-by-step analysis example.

Returns<-logreturns(Prices) # Getting a stationary process
Returns<-Returns*10 		# Scaling the values

hmm<-hmmsetcont(Returns) 	# Creating a HMM object
print(hmm) 		# Checking the initial parameters

for(i in 1:6){hmm<-baumwelchcont(hmm)} # Baum-Welch is 
# executed 6 times and results are accumulated
print(hmm) 		# Checking the accumulated parameters
summary(hmm) 	# Getting more detailed information

hmmcomplete<-viterbicont(hmm) # Viterbi execution

statesDistributionsPlot(hmmcomplete, sc=10) # PDFs of 
# the whole data set and two states are plotted 
par(mfrow=c(2,1))
plot(hmmcomplete, Prices, ylabel="Price") 
plot(hmmcomplete, ylabel="Returns") # the revealed 
# Markov chain and the observations are plotted

