rm(list = ls())
setwd("~/R/methods/ggplot2/")
options(stringsAsFactors = FALSE)
#source("http://bioconductor.org/biocLite.R");
#biocLite("affycoretools")

#save.image(".RData")
#load(".RData")

# 安装包
install.packages("ggplot2")

# 导入包
# 帮助文档链接：http://docs.ggplot2.org/current/
library(ggplot2)

# 设置工作路径到数据存放的文件夹下
# 读数据
pathway = read.csv("example.csv",header=T)
pathway=cbind(pathway,richFactor=0.5)
colnames(pathway)
# 画图
pp = ggplot(pathway,aes(richFactor,Term))
pp + geom_point()

# 改变点的大小
pp + geom_point(aes(size=Count))

# 四维数据的展示
pbubble = pp + geom_point(aes(size=Count,color=-1*log10(PValue)))
# 自定义渐变颜色
pbubble + scale_colour_gradient(low="green",high="red")

# 绘制pathway富集散点图
pr = pbubble + scale_colour_gradient(low="green",high="red") + labs(color=expression(-log[10](PValue)),size="Gene number",x="Rich factor",y="Pathway name",title="Top18 of pathway enrichment")
# 改变图片的样式（主题）
pr + theme_bw()
## 保存图片
ggsave("out.pdf")   # 保存为pdf格式，支持 pdf，png，svg多重格式
ggsave("out.png")  # 保存为png格式
ggsave("out2.png",width=4,height=4)   # 设定图片大小




a=as.list(c('a','b'),1,3)
