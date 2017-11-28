rm(list = ls())
setwd("D:/workspace/R/machine_learning")

#1  K-近邻算法
library(kknn)
data(iris)
m <- dim(iris)[1]
val <- sample(1:m, size =round(m/3), replace = FALSE, prob= rep(1/m, m))  
iris.learn <- iris[-val,]  
iris.valid <- iris[val,]  
iris.kknn <- kknn(Species~.,iris.learn, iris.valid,k=5, distance = 5, kernel= "triangular") 
#summary(iris.kknn)
fit <- fitted(iris.kknn)
table(iris.valid$Species, fit)

#3  朴素贝叶斯算法
library(e1071)
data(Titanic) 
Titanic_frame=as.data.frame(Titanic)
m <- naiveBayes(Survived ~ ., data = Titanic_frame)  
pred_m <- predict(m, Titanic_frame)
table(pred_m,Titanic_frame$Survived)

data(HouseVotes84, package = "mlbench")
model <- naiveBayes(Class ~ ., data = HouseVotes84)
pred <- predict(model, HouseVotes84)
table(pred, HouseVotes84$Class)
