rm(list = ls())
setwd("D:/workspace/R/meta")
options(stringsAsFactors = FALSE)

library(metafor)

dat.bcg
#Next, we can calculate the log relative risks and corresponding sampling variances with:
dat <- escalc(measure="RR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)

dat$vi <- with(dat, sum(tneg/tpos)/(13*(tneg+tpos)) + sum(cneg/cpos)/(13*(cneg+cpos)))

#Meta-Analysis via Linear (Mixed-Effects) Models
#the empirical Bayes
res.RE <- rma(yi, vi, data=dat, method="EB")
res.RE

#Mixed-Effects Model
res.ME <- rma(yi, vi, mods=~I(ablat-33.46), data=dat, method="EB")
res.ME
I(dat$ablat-33.46)


#The amount of variance (heterogeneity) accounted for by the absolute latitude moderator is provided in the output above. 
#It can also be obtained with:
anova(res.RE, res.ME)

predict(res.ME, newmods=c(33.46,42)-33.46, transf=exp, digits=2)


#Fixed-Effects Model
res.FE <- rma(yi, vi, mods=~I(ablat-33.46), data=dat, method="FE")
res.FE


###########################
#2#Lipsey & Wilson (2001)
#The Methods and Data
rm(list = ls())
setwd("D:/workspace/R/meta")
options(stringsAsFactors = FALSE)

dat <- data.frame(
  id = c(100, 308, 1596, 2479, 9021, 9028, 161, 172, 537, 7049),
  yi = c(-0.33, 0.32, 0.39, 0.31, 0.17, 0.64, -0.33, 0.15, -0.02, 0.00),
  vi = c(0.084, 0.035, 0.017, 0.034, 0.072, 0.117, 0.102, 0.093, 0.012, 0.067),
  random = c(0, 0, 0, 0, 0, 0, 1, 1, 1, 1),
  intensity = c(7, 3, 7, 5, 7, 7, 4, 4, 5, 6))

#Fixed-Effects Model
res <- rma(yi, vi, data=dat, method="FE")
res

#Random-Effects Model
#A random-effects model (using the DerSimonian-Laird estimator) can be fitted with:
res <- rma(yi, vi, data=dat, method="DL")
res

#Analog to the ANOVA
#a fixed-effects model with the random variable as moderator can be fitted with:
res <- rma(yi, vi, mods = ~ random, data=dat, method="FE")
res

#The tests for heterogeneity within the two subgroups formed by the moderator can be obtained with:
rma(yi, vi, data=dat, method="FE", subset=random==0)
rma(yi, vi, data=dat, method="FE", subset=random==1)
#Finally, the predicted/estimated effect for random = 0 and random = 1 can be obtained with:
predict(res, newmods=c(0,1))

#Weighted Regression Analysis
res <- rma(yi, vi, mods = ~ random + intensity, data=dat, method="FE")
res

#Mixed-Effects Model
res <- rma(yi, vi, mods = ~ random + intensity, data=dat, method="DL")
res

#Heterogeneity Accounted For
res.ME <- rma(yi, vi, mods = ~ random + intensity, data=dat, method="DL")
res.RE <- rma(yi, vi, data=dat, method="DL")
anova(res.RE, res.ME)

##########################################################
#3#Normand (1999)
rm(list = ls())
options(stringsAsFactors = FALSE)
library(metafor)
dat.hine1989
# the risk differences and corresponding sampling variances
dat <- escalc(measure="RD", n1i=n1i, n2i=n2i, ai=ai, ci=ci, data=dat.hine1989)
dat

#Fixed-Effects Model
rma(yi, vi, data=dat, method="FE")
#Random-Effects Model
rma(yi, vi, data=dat)
#the random-effects model using the DerSimonian-Laird
rma(yi, vi, data=dat, method="DL", digits=2)

dat.normand1999
dat.normand1999$sdpi <- with(dat.normand1999, sqrt(((n1i-1)*sd1i^2 + (n2i-1)*sd2i^2)/(n1i+n2i-2)))

#compute the mean differences and corresponding sampling variances
dat <- escalc(m1i=m1i, sd1i=sdpi, n1i=n1i, m2i=m2i, sd2i=sdpi, n2i=n2i,
              measure="MD", data=dat.normand1999, digits=2)
dat

#Fixed-Effects Model
rma(yi, vi, data=dat, method="FE", digits=2)

#Random-Effects Model
rma(yi, vi, data=dat, method="DL", digits=2)
rma(yi, vi, data=dat, digits=2)

################################################
#4#Raudenbush & Bryk (1985)
rm(list = ls())
options(stringsAsFactors = FALSE)
library(metafor)
dat <- get(data(dat.raudenbush1985))
dat

#Random-Effects Model
res <- rma(yi, vi, data=dat, digits=3)
res

###Empirical Bayes Estimates
blup(res)


#the mixed-effects model
dat$weeks.c <- ifelse(dat$weeks > 3, 3, dat$weeks)
res <- rma(yi, vi, mods = ~ weeks.c, data=dat, digits=3)
res
blup(res)

##Scatterplot with Predictions
preds <- predict(res, newmods=seq(0,3,.1))

wi   <- 1/sqrt(dat$vi)
size <- 0.5 + 2.0 * (wi - min(wi))/(max(wi) - min(wi))

plot(dat$weeks.c, dat$yi, pch=19, cex=size, bty="l", xaxt="n",
     xlab="Weeks of Prior Contact", ylab="Standardized Mean Difference")
axis(side=1, at=c(0,1,2,3), labels=c("0", "1", "2", ">2"))

lines(seq(0,3,.1), preds$pred)
lines(seq(0,3,.1), preds$ci.lb, lty="dashed")
lines(seq(0,3,.1), preds$ci.ub, lty="dashed")

abline(h=0, lty="dotted")


#######################
#5#Berkey et al. (1998)
rm(list = ls())
options(stringsAsFactors = FALSE)
library(metafor)
dat <- get(data(dat.berkey1998))
dat
#Variance-Covariance Matrix
V <- bldiag(lapply(split(dat[,c("v1i", "v2i")], dat$trial), as.matrix))
#Multivariate Random-Effects Model
res <- rma.mv(yi, V, mods = ~ outcome - 1, random = ~ outcome | trial, struct="UN", data=dat, method="ML")
print(res, digits=3)



