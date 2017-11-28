rm(list = ls())
setwd("~/R/methods/mysql/")
options(stringsAsFactors = FALSE)
#source("http://bioconductor.org/biocLite.R")
#options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
#biocLite("affyQCReport")

library(RMySQL)
conn <- dbConnect(MySQL(), dbname = "rmysql", username="alfred", password="12345", host="127.0.0.1", port=3306)

dbListTables(conn)#查表
dbRemoveTable(conn,'mtcars')#删表
dbListTables(conn)
dbWriteTable(conn, "mtcars", mtcars[1:10,1:3])#写表
dbExistsTable(conn, "mtcars")
dbReadTable(conn, "mtcars")  #读表

#SQL SELECT
dbGetQuery(conn, "SELECT * FROM mtcars")#选取所有的列
dbGetQuery(conn, "SELECT row_names,mpg,cyl FROM mtcars")#选取特定列
#SQL DISTINCT
dbGetQuery(conn, "SELECT cyl FROM mtcars")
dbGetQuery(conn, "SELECT DISTINCT cyl FROM mtcars")#仅仅列出不同（distinct）的值
#SQL WHERE
dbGetQuery(conn, "SELECT * FROM mtcars WHERE cyl = 6;")
dbGetQuery(conn, "SELECT * FROM mtcars WHERE cyl <> 6;")
dbGetQuery(conn, "SELECT * FROM mtcars WHERE cyl != 6;")
dbGetQuery(conn, "SELECT * FROM mtcars WHERE cyl < 6;")
dbGetQuery(conn, "SELECT * FROM mtcars WHERE cyl > 6;")
dbGetQuery(conn, "SELECT * FROM mtcars WHERE cyl <= 6;")
dbGetQuery(conn, "SELECT * FROM mtcars WHERE cyl >= 6;")
dbGetQuery(conn, "SELECT * FROM mtcars WHERE cyl between 4 AND 6;")
dbGetQuery(conn, "SELECT * FROM mtcars WHERE row_names LIKE '%M%';")
#SQL AND 和 OR 运算符
dbGetQuery(conn, "SELECT * FROM mtcars WHERE cyl = 6 AND mpg > 21;")
dbGetQuery(conn, "SELECT * FROM mtcars WHERE cyl = 6 OR mpg > 21;")
dbGetQuery(conn, "SELECT * FROM mtcars WHERE (cyl = 6 OR mpg > 21) AND disp < 200 ;")
#SQL ORDER BY 子句
dbGetQuery(conn, "SELECT * FROM mtcars ORDER BY cyl;")
dbGetQuery(conn, "SELECT * FROM mtcars ORDER BY cyl, disp;")
dbGetQuery(conn, "SELECT * FROM mtcars ORDER BY cyl DESC;")#逆序
dbGetQuery(conn, "SELECT * FROM mtcars ORDER BY cyl DESC, disp ASC;")#逆序,顺序

#SQL INSERT INTO 语句, , ('name_3', 3, 3, 3)
dbExecute(conn,"INSERT INTO mtcars VALUES ('name_1', 1, 1, 1)")
dbGetQuery(conn, "SELECT * FROM mtcars")
dbExecute(conn,"INSERT INTO mtcars (row_names, mpg) VALUES ('name_2',2)")
dbGetQuery(conn, "SELECT * FROM mtcars")
dbExecute(conn,"INSERT INTO mtcars (mpg, cyl) VALUES (3,3)")
dbGetQuery(conn, "SELECT * FROM mtcars")

#SQL UPDATE 语句
dbExecute(conn,"UPDATE mtcars SET row_names='name_5' where row_names='name_1'")#更新某一行中的某一列
dbGetQuery(conn, "SELECT * FROM mtcars")
dbExecute(conn,"UPDATE mtcars SET cyl=2, disp=2 where row_names='name_2'")#更新某一行中的若干列
dbGetQuery(conn, "SELECT * FROM mtcars")

#SQL DELETE 语句
dbExecute(conn,"DELETE FROM mtcars where row_names is NULL")#删除某行
dbGetQuery(conn, "SELECT * FROM mtcars")
dbExecute(conn,"DELETE FROM mtcars")#在不删除表的情况下删除所有的行
dbGetQuery(conn, "SELECT * FROM mtcars")

dbDisconnect(conn) #关闭连接
