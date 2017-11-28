rm(list = ls())
setwd("~/R/methods/RSNNS")
options(stringsAsFactors = FALSE)
#source("http://bioconductor.org/biocLite.R");
#biocLite("affycoretools")

######RSNNS案例  
library(RSNNS)  
data(iris)  
inputs <- normalizeData(iris[,1:4], "norm")  #数据标准化  

model <- som(inputs, mapX=16, mapY=16, maxit=500,  
             calculateActMaps=TRUE, targets=iris[,5])  

par(mfrow=c(3,3))  
for(i in 1:ncol(inputs)) plotActMap(model$componentMaps[[i]],  
                                    col=rev(topo.colors(12)))  

plotActMap(model$map, col=rev(heat.colors(12)))  
plotActMap(log(model$map+1), col=rev(heat.colors(12)))  
persp(1:model$archParams$mapX, 1:model$archParams$mapY, log(model$map+1),  
      theta = 30, phi = 30, expand = 0.5, col = "lightblue")  

plotActMap(model$labeledMap)  

model$componentMaps  
model$labeledUnits  
model$map  

names(model)  
#################


#foo$data源数据
#init 初始化方法 
#xdim x的维数  
#ydim   y的维数
#code   初始矩阵行索引=x维度+y维度*x向量值（行）
#visual 每一案例，地图上的维数坐标 qerror是初始向量和最后测试向量的差的平方距离，这个就是分类
#alpha0 学习速率
#alpha  学习训练函数形式
#neigh  近邻函数类型
#topol  输出层近邻函数类型
#qerror 误差的平均   
#code.sum xy的计数矩阵（类似混淆矩阵）

#som案例 
rm(list = ls())
library(som)
data(yeast)
yeast <- yeast[, -c(1, 11)]
yeast.f <- filtering(yeast)
yeast.f.n <- normalize(yeast.f)
foo <- som(yeast.f.n, xdim=6, ydim=6)
foo <- som(yeast.f.n, xdim=5, ydim=6, topol="hexa", neigh="gaussian")
plot(foo)
names(foo)
print(foo)


##
load("~/R/comparison/mRNA_glo_final_correction.RData")
mRNA_MN_glo_final=mRNA_glo_final_correction[,c(grep('^n',colnames(mRNA_glo_final_correction)),grep('^ma',colnames(mRNA_glo_final_correction)),grep('^mb',colnames(mRNA_glo_final_correction)))]
rm(mRNA_glo_final_correction,groups_glo)
datExpr_MN_glo_final=t(mRNA_MN_glo_final)
source('~/R/myfunction/my_double_filter.R', encoding = 'UTF-8')
datExpr_MN_glo_final=my_double_filter(datExpr_MN_glo_final)
datExpr_MN_glo_final_n=normalize(datExpr_MN_glo_final)
MN_glo_som=som(datExpr_MN_glo_final_n,xdim = 3, ydim = 1, topol="hexa", neigh="gaussian")
#plot(MN_glo_som)
#print(MN_glo_som)
out_MN_glo_som=MN_glo_som$visual
rownames(out_MN_glo_som)=rownames(datExpr_MN_glo_final_n)

##
library(mclust) 
mod1 = Mclust(datExpr_MN_glo_final, G=3) 

mod1$classification 

summary(mod1) 

colnames(datExpr_MN_glo_final) 

mclust2Dplot(datExpr_MN_glo_final[,c(1,2)],parameters = mod1$parameters,z=mod1$z,what="classification",main=T) 

#
library(kohonen)
datExpr_MN_glo_final_sc=scale(datExpr_MN_glo_final,center = T,scale = T)
pre.som=xyf(data = datExpr_MN_glo_final_sc, 
            Y= scale())

