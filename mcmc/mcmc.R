rm(list = ls())
setwd("D:/workspace/R/methods/mcmc")
#source("https://bioconductor.org/biocLite.R")
#biocLite("BHC")
#library(devtools)
#author: rachel @ ZJU  
#email: zrqjennifer@gmail.com  

N = 10000  
x = vector(length = N)  
x[1] = 0  

# uniform variable: u  
u = runif(N)
m_mean=1
m_sd = 5  
freedom = 5  

for (i in 2:N)  
{  
  y = rnorm(1,mean = x[i-1],sd = m_sd)  
  print(y)  
  #y = rt(1,df = freedom)  
  
  p_accept = dnorm(y,mean = 1,sd = m_sd) / dnorm(x[i-1], mean = 1,sd = m_sd)  
  #print (p_accept)  
  
  
  if ((u[i] <= p_accept))  
  {  
    x[i] = y  
    print("accept")  
  }  
  else  
  {  
    x[i] = x[i-1]  
    print("reject")  
  }  
}  

plot(x,type = 'l')  
dev.new()  
hist(x)  
sd(x)


#####
rm(list = ls())
gibbs<-function (n, r)   
{  
  mat <- matrix(ncol = 2, nrow = n)  
  x <- 0  
  y <- 0  
  mat[1, ] <- c(x, y)  
  for (i in 2:n) {  
    x <- rnorm(1, r * y, sqrt(1 - r^2))  
    y <- rnorm(1, r * x, sqrt(1 - r^2))  
    mat[i, ] <- c(x, y)  
  }  
  mat  
}  
bvn<-gibbs(10000,0.98)  

rbvn<-function (n, r)   
{  
  x <- rnorm(n, 0, 1)  
  y <- rnorm(n, r * x, sqrt(1 - r^2))  
  cbind(x, y)  
}  
bvn<-rbvn(10000,0.98)  


par(mfrow=c(3,2))  
plot(bvn,col=1:10000)  
plot(bvn,type="l")  
plot(ts(bvn[,1]))  
plot(ts(bvn[,2]))  
hist(bvn[,1],40)  
hist(bvn[,2],40)  
par(mfrow=c(1,1))  

