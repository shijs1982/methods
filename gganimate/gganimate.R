rm(list = ls())
setwd("~/R/methods/gganimate/")
options(stringsAsFactors = FALSE)
#source("http://bioconductor.org/biocLite.R");
#options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
#biocLite("gganimate")
#save.image(".RData")
#load(".RData")
#devtools::install_github("dgrtwo/gganimate")#
library(plyr)
library(dplyr)
library(ggmap)
library(ggplot2)
library(gganimate)

library(httr)
set_config(use_proxy(url="18.91.12.23", port=8080, username="user",password="password"))