rm(list = ls())
setwd("~/R/methods/bnlearn")
#source("http://bioconductor.org/biocLite.R")
#options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
#biocLite()
#library(devtools)

#Creating an empty network
library(bnlearn)
e = empty.graph(LETTERS[1:6])
class(e)
e
#generate multiple graphs
empty.graph(LETTERS[1:6], num = 2)

#Creating a network structure
#With a specific arc set
arc.set = matrix(c("A", "C", "B", "F", "C", "F"),ncol = 2, byrow = TRUE,dimnames = list(NULL, c("from", "to")))
arc.set

#Then we can assign the newly created arc.set to a bn object using the assignment version of the arcs() function
arcs(e) = arc.set
e
plot(e)


#With a specific adjacency matrix
adj = matrix(0L, ncol = 6, nrow = 6, dimnames = list(LETTERS[1:6], LETTERS[1:6]))
adj["A", "C"] = 1L
adj["B", "F"] = 1L
adj["C", "F"] = 1L
adj["D", "E"] = 1L
adj["A", "E"] = 1L

adj

#Then we introduce the arcs in the graph with the assignment version of amat().
amat(e) = adj
e
plot(e)

#With a specific model formula
#1.With the model2network() function (documented here), without creating an empty graph first.
plot( model2network("[A][C][B|A][D|C][F|A:B:C][E|F]"))
#2.With modelstring() (documented here) and an existing bn object, as for arcs() and amat() above.
modelstring(e) = "[A][C][B|A][D|C][F|A:B:C][E|F]"
plot(e)

#Creating one or more random network structures
#With a specified node ordering

plot(random.graph(LETTERS[1:6], prob = 0.1))

#Sampling from the space of connected directed acyclic graphs with uniform probability
random.graph(LETTERS[1:6], num = 2, method = "ic-dag")
plot(random.graph(LETTERS[1:6], num = 1, method = "ic-dag"))
random.graph(LETTERS[1:6], num = 2, method = "ic-dag", burn.in = 10^4,every = 50, max.degree = 3)

#Sampling from the space of the directed acyclic graphs with uniform probability
random.graph(LETTERS[1:6], method = "melancon")

#Creating custom fitted Bayesian networks
#Creating custom fitted Bayesian networks using expert knowledge
#Discrete networks
library(bnlearn)
cptA = matrix(c(0.4, 0.6), ncol = 2, dimnames = list(NULL, c("LOW", "HIGH")))
cptA
cptB = matrix(c(0.8, 0.2), ncol = 2, dimnames = list(NULL, c("GOOD", "BAD")))
cptB
cptC = c(0.5, 0.5, 0.4, 0.6, 0.3, 0.7, 0.2, 0.8)
dim(cptC) = c(2, 2, 2)
dimnames(cptC) = list("C" = c("TRUE", "FALSE"), "A" =  c("LOW", "HIGH"),"B" = c("GOOD", "BAD"))
cptC

net = model2network("[A][B][C|A:B]")
dfit = custom.fit(net, dist = list(A = cptA, B = cptB, C = cptC))
dfit

dfit = custom.fit(net, dist = list(A = cptA, B = cptB, C = cptC), ordinal = c("A", "B"))
dfit

#Continuous networks
distA = list(coef = c("(Intercept)" = 2), sd = 1)
distB = list(coef = c("(Intercept)" = 1), sd = 1.5)
distC = list(coef = c("(Intercept)" = 0.5, "A" = 0.75, "B" = 1.32), sd = 0.4)
cfit = custom.fit(net, dist = list(A = distA, B = distB, C = distC))
cfit

distA = list(coef = c("(Intercept)" = 2), fitted = 1:10, resid = rnorm(10))
distB = list(coef = c("(Intercept)" = 1), fitted = 3:12, resid = rnorm(10))
distC = list(coef = c("(Intercept)" = 0.5, "A" = 0.75, "B" = 1.32), fitted = 2:11, resid = rnorm(10))
cfit = custom.fit(net, dist = list(A = distA, B = distB, C = distC))

distA = lm(A ~ 1, data = gaussian.test)
distB = lm(B ~ 1, data = gaussian.test)
distC = lm(C ~ A + B, data = gaussian.test)
cfit = custom.fit(net, dist = list(A = distA, B = distB, C = distC))

library(penalized)
distC = penalized(C ~ A + B, data = gaussian.test, lambda1 = 0, lambda2 = 0.5, trace = FALSE)
cfit = custom.fit(net, dist = list(A = distA, B = distB, C = distC))



#Score functions: computing & comparing
rm(list = ls())
library(bnlearn)
data(learning.test)
data(gaussian.test)

learn.net = empty.graph(names(learning.test))
modelstring(learn.net) = "[A][C][F][B|A][D|A:C][E|B:F]"
learn.net
plot(learn.net)

gauss.net = empty.graph(names(gaussian.test))
modelstring(gauss.net) = "[A][B][E][G][C|A:B][D|B][F|A:D:E:G]"
gauss.net
plot(gauss.net)

#Computing a network score
score(learn.net, learning.test)
score(gauss.net, gaussian.test)

#Other score functions can be used by changing the type, as documented in the manual page of the function.
score(learn.net, learning.test, type = "bic")
score(learn.net, learning.test, type = "aic")
score(learn.net, learning.test, type = "bde")

score(learn.net, learning.test, type = "bde", iss = 1)
score(gauss.net, gaussian.test, type = "bge", iss = 3)

#Testing score equivalence
eq.net = set.arc(gauss.net, "D", "B")
score(gauss.net, gaussian.test, type = "bic-g")
score(eq.net, gaussian.test, type = "bic-g")
all.equal(cpdag(gauss.net), cpdag(eq.net))
noneq1.net = set.arc(gauss.net, from = "B", to = "C")
score(noneq1.net, gaussian.test, type = "bic-g")
