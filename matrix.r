#run comand :  Rscript main.r

# Get and print current working directory.
print(getwd())

# Set current working directory.
setwd("/home/navleen/Downloads/n")

# Get and print current working directory.
print(getwd())

#disable scenttific notion
options(scipen=999)

#fileData <- read.csv("gammamatrix.csv", sep=",", row.names=1)
fileData <- read.csv("gammamatrix.csv")

print("--data frame details--")
print(is.data.frame(fileData))
print(ncol(fileData))
print(nrow(fileData))

fileDataMatrix <- as.matrix(fileData)

print("---matrix [csv]---")
print(fileDataMatrix)


# Elements are arranged sequentially by row.
print("---matrix [10X10] ---")
M <- matrix(fileDataMatrix[,"v"], nrow = 10,ncol=10, byrow = TRUE)
print(M)
M <- M[-(1), -(1)]
M <- M[-(9), -(9)]
print(M)
Q<- M
print(Q)
Qinv<-solve(Q)
print(Qinv)
M <- matrix(fileDataMatrix[,"v"], nrow = 10,ncol=10, byrow = TRUE)
print(M)
M <- M[-(1), -(1)]
print(M)
M[-c(9), -(1:8)] 
XYTrans<- M[-c(9), -(1:8)] 
print(XYTrans)
t(XYTrans)
Qinv %*% XYTrans
Beta<- Qinv %*% XYTrans
print(Beta)

#finding r sqaure
actual<- Qinv
predict<- XYTrans
R2 <- 1 - (sum((actual-predict )^2)/sum((actual-mean(actual))^2))
print(R2)