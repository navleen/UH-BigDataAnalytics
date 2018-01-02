
args <- commandArgs(TRUE)
table <- args[1]
d <- args[2]

library(RJDBC)

className= "com.vertica.jdbc.Driver"
classPath = "/opt/vertica/java/vertica-jdbc-8.1.1-0.jar"
drv <- JDBC(className, classPath, identifier.quote="`")

conn <- dbConnect(drv, "jdbc:vertica://localhost/gamma", "navleen", "navleen1234")

#print(table)
tmptable1 <- paste(table,"g1", sep="")
t1 <- noquote(tmptable1)
#print(t1)

tmptable2 <- paste(table, "g2", sep="")
#t2 <- data.frame(data.frame(x=c(tmptable2)), quote=FALSE)
t2 <- noquote(tmptable2)
#print(t2)


bret <- dbExistsTable(conn, tmptable1)
if(bret)
{
	dropquery <- paste("drop table", tmptable1, sep=" ")
	print(dropquery)
	dbSendUpdate(conn, dropquery);
}

bret <- dbExistsTable(conn, tmptable2)
if(bret)
{
	dropquery <- paste("drop table", tmptable2, sep=" ")
	print(dropquery)
	dbSendUpdate(conn, dropquery);
}

createquery = paste("create table ", tmptable1, " as select * from ", table, " where i in (select i from ", table, " where j=", d, "and v=1)")
print(createquery)
dbSendUpdate(conn, createquery)

createquery = paste("create table ", tmptable2, " as select * from ", table, " where i in (select i from ", table, " where j=", d, "and v=0)")
print(createquery)
dbSendUpdate(conn, createquery)


query <- paste(paste("SELECT DenseGamma(i, j, v USING PARAMETERS d=", d, sep=""),paste(") OVER (PARTITION BY MOD(i, 1) ORDER BY i,j) FROM ", tmptable1, sep = ""), sep="")
print (query)
res1 <- dbGetQuery(conn, query)
##res will display  the I J V

print("The result is stored in resultg1.txt")
write.table(res1,"resultg1.txt", row.names = FALSE,  sep=",")

query <- paste(paste("SELECT DenseGamma(i, j, v USING PARAMETERS d=", d, sep=""),paste(") OVER (PARTITION BY MOD(i, 1) ORDER BY i,j) FROM ", tmptable2, sep = ""), sep="")
print (query)
res2 <- dbGetQuery(conn, query)
##res will display  the I J V
print("The result is stored in resultg2.txt")
write.table(res2,"resultg2.txt", row.names = FALSE,  sep=",")

newDim <- as.integer(d) + 1
reCon <- res1[,3]
dim(reCon) <- c(newDim, newDim)
reCon

newDim <- as.integer(d) + 1
reCon1 <- res2[,3]
dim(reCon1) <- c(newDim, newDim)
reCon1

t(reCon)
t(reCon1)

##attempt to extract Q 
##QMATRIX1 is made by extracting from the 
QMATRIX1 <- reCon[c(2:d),c(2:d)]
QMATRIX1

##QMATRIX2 is made by extracting from the 
QMATRIX2 <- reCon1[c(2:d),c(2:d)]
QMATRIX2

N1 <- reCon[1,1]
N2 <- reCon1[1,1]
n <- N1+N2
N1
N2
n

#extracting L from gamma matrix1
maxcol = as.integer(d) - 1
L1 <- matrix(data=reCon[c(2:d),1],nrow=maxcol,ncol=1)
L1

#extracting L from gamma matrix2
L2 <- matrix(data=reCon1[c(2:d),1],nrow=maxcol,ncol=1)
L2

#Calculate mean of classes
Mean1 <- L1/N1
print("Mean 1 : ")
Mean1

Mean2 <- L2/N2
print("Mean 2 : ")
Mean2

#Calculate SD of class1
Qterm = QMATRIX1 / N1
Lterm = L1 %*% t(L1)
Lterm2 = Lterm/(N1^2)
SDClass1 = Qterm - Lterm2
print("Standard deviation 1 : ")
SDClass1

#Calculate SD of class1
Qterm2 = QMATRIX2 / N2
Lterm_ = L2 %*% t(L2)
Lterm_2 = Lterm_/(N2^2)
SDClass2 = Qterm2 - Lterm_2
print("Standard deviation 2 : ")
SDClass2


#Calculate class priors
classprior1 = N1/n
classprior2 = N2/n

print("Class prior 1 : ")
classprior1

print("Class prior 2 : ")
classprior2

#calculate feature selection
#library(dplyr)

d <-read.csv(res1)
chisq.test(d)