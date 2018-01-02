
args <- commandArgs(TRUE)
table <- args[1]
dval <- args[2]

library(RJDBC)


##hardcode diabetes

##table <-readline(prompt="ENter table: ");print(table) 
##dval <- readline(prompt="Enter d value: ");print(dval)
className= "com.vertica.jdbc.Driver"
classPath = "/opt/vertica/java/vertica-jdbc-8.1.1-0.jar"
drv <- JDBC(className, classPath, identifier.quote="`")
##conn <- dbConnect(drv, paste("jdbc:vertica://localhost/", DBName, sep=""), "team13", "team13")
conn <- dbConnect(drv, "jdbc:vertica://localhost/gamma", "navleen", "navleen1234")
query <- paste(paste("SELECT DenseGamma(i, j, v USING PARAMETERS d=", dval, sep=""),paste(") OVER (PARTITION BY MOD(i, 1) ORDER BY i,j) FROM ", table, sep = ""), sep="")
print (query)
res <- dbGetQuery(conn, query)
##res will display  the I J V

print("The result is stored in result.txt")
write.table(res,"result.txt", row.names = FALSE,  sep=",")


newDim <- as.integer(dval) + 1
reCon <- res[,3]
dim(reCon) <- c(newDim, newDim)
##the recon created here is n in the paper
##I think here we need to append an extra row with Y for it to become X
## then we matrix multiply X with x^transpose(?) to create vector outter product
##take not this will not be the same as x^t multiplied with x
t(reCon)
reCon
##attempt to extract Q and XY^T

##QMATRIX is made by extracting from the 
QMATRIX <- reCon[c(2:dval),c(2:dval)]
QMATRIX
##XY^T will be the last column with the exception of the first and last row
XYT <- reCon[c(2:dval), newDim]
XYT

Beta <- solve(QMATRIX) %*% XYT
print("Here is the Beta")

Beta
