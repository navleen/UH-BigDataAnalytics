
args <- commandArgs(TRUE)
table <- args[1]

#Code to calculate linear regression in R
#removes all objects from the current workspace (R memory)
#rm(list=ls())

#Read data from csv files
matrixdata = read.csv(file=tables, head=TRUE, sep=",")

#retrieve dimension of matrixdata output would be rows, column 768*9
d = dim(matrixdata);
d

#take column dimension
dd = d[2];
dd


#Extract all columns except last one
SubMatrix1 = matrixdata[-c(dd)];
SubMatrix1

#Last column will contain class like 0, 1
SubMatrix2 = matrixdata[,c(dd)];
SubMatrix2

# build linear regression model on full data
#parameter
#1 : Formula
#2 : data
# dot means "any columns from data that are otherwise not used"
LR= lm(SubMatrix2 ~ ., data = SubMatrix1)

#to print model summary
summary(LR)
