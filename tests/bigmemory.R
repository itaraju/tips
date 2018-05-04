## bigmemory test
library(data.table)
require(parallel)
require(doParallel)

library(bigmemory)
library(biganalytics)

source("~/Box Sync/PhD/gs-v1/init.lib.R")

## building mm
genf <- readRDS(pathto("data", "gbs-genf.rds"))
mm <- dcast.data.table(genf, sample ~ marker, value.var = "gen")
x <- mm$sample
mm[,sample:=NULL]
mm <- as.matrix(mm)
rownames(mm) <- x
rm(x)


## building bigmatrix
dimnames(mm) <- NULL
mb <- as.big.matrix(mm, type="integer")

## silly test - counting the number of NAs per column
system.time(nna0 <- apply(mm, 2, function(x)sum(is.na(x)))) # 1.3" / 2" @CTC
system.time(nna1 <- apply(mb, 2, function(x)sum(is.na(x)))) # 1.5" / 49" @CTC !
system.time(nna1a <- colna(mb)) #8.3"

cl=makePSOCKcluster(rep("localhost",4))
registerDoParallel(cl)

system.time(nna2 <- foreach(i=1:ncol(mm), .combine=c) %dopar% {
  return(sum(is.na(mm[,i])))
}) #14.4"

z = describe(mb)
system.time(nna3 <- foreach(i=1:ncol(mm), .combine=c, .packages="bigmemory") %dopar% {
  mz = attach.big.matrix(z)
  return(sum(is.na(mz[,i])))
}) #24.4"



## more evolving operation
mmi <- apply(mm, 2, function(vec){vec[is.na(vec)] <- mean(vec, na.rm=TRUE); return(vec)})
mz <- as.big.matrix(mmi, type="integer")

system.time(sds <- foreach(i=1:8, .combine=c) %dopar% {
  pca <- prcomp(mmi[,((i-1)*2000+1):(2000*i-1)])
  return(sum(pca$sdev[1:5]^2))
}) #64"

z = describe(mz)
system.time(sds2 <- foreach(i=1:8, .combine=c, .packages="bigmemory") %dopar% {
  mz = attach.big.matrix(z)
  pca <- prcomp(mz[,((i-1)*2000+1):(2000*i-1)])
  return(sum(pca$sdev[1:5]^2))
}) #58"

stopCluster(cl)

## what's the difference in that?
system.time(pca <- prcomp(mmi[,1:2000])) # 41.1"
system.time(pca <- prcomp(mz[,1:2000])) # 40.4"


s <- Sys.time()
res <- numeric(ncol(mm))
for (i in 1:ncol(mm)) {res[i] <- sum(is.na(mm[,i]))}
print(Sys.time()-s) # 2"

s <- Sys.time()
res <- numeric(ncol(mb))
for (i in 1:ncol(mb)) {res[i] <- sum(is.na(mb[,i]))}
print(Sys.time()-s) # 2"




########################################################
### more tests on server 
source("../init.lib.R")

library(data.table)
require(parallel)
library(bigmemory)
require(foreach)
require(doParallel)

genf <- readRDS(pathto("data", "gbs-genf.rds"))
mm <- dcast.data.table(genf, sample ~ marker, value.var = "gen")
x <- mm$sample
mm[,sample:=NULL]
mm <- as.matrix(mm)
rownames(mm) <- x
rm(x)

#mb <- as.big.matrix(mm, type="integer",descriptorfile="/tmp/mm.desc")
mb <- as.big.matrix(mm, type="integer")
z = describe(mb)
 
# system.time(clusterExport(cl, "mm")) ## 22"
# system.time(l <- clusterEvalQ(cl, {nrow(mm)})) # 0.005"
# system.time(l <- clusterEvalQ(cl, {rm(mm)}))


## - initial test - worked out
cl <- makePSOCKcluster(c(rep("localhost",20)))
system.time(l <- clusterEvalQ(cl, {library(bigmemory);library(biganalytics)})) # 1"
system.time(clusterExport(cl, "z")) ## 0.15"
system.time(l <- clusterEvalQ(cl, {mb <- attach.big.matrix(z)})) # 0.058"
system.time(l <- clusterEvalQ(cl, {nrow(mb)}))
system.time(l <- clusterEvalQ(cl, {ncol(mb)}))
system.time(l <- clusterEvalQ(cl, {apply(mb, 2, function(x){sum(is.na(x))})}))
stopCluster(cl)

## more evolving and comparative test
cl <- makePSOCKcluster(c(rep("localhost",20)))

s = Sys.time()
clusterExport(cl, "z")
l <- clusterEvalQ(cl, {
  library(bigmemory);library(biganalytics)
  mb <- attach.big.matrix(z)
  apply(mb, 2, function(x){sum(is.na(x))})
})
print(Sys.time() - s) ## ## 1.096679 mins
stopCluster(cl)

## foreach version
cl <- makePSOCKcluster(c(rep("localhost",20)))
registerDoParallel(cl)

s = Sys.time()
l <- foreach(icount(10), .packages=c("bigmemory","biganalytics")) %dopar% {
  mb <- attach.big.matrix(z)
  apply(mb, 2, function(x){sum(is.na(x))})
}
print(Sys.time() - s) ## 58.71776 secs
stopCluster(cl)

## foreach version without bigmemory
cl <- makePSOCKcluster(c(rep("localhost",20)))
registerDoParallel(cl)

s = Sys.time()
l <- foreach(icount(10)) %dopar% {
  apply(mm, 2, function(x){sum(is.na(x))})
}
print(Sys.time() - s) # 29.22178 secs (apply.big.matrix is very slow in this case)
stopCluster(cl)

## foreach version without apply
cl <- makePSOCKcluster(c(rep("localhost",20)))
registerDoParallel(cl)

s = Sys.time()
l <- foreach(icount(10), .packages=c("bigmemory","biganalytics")) %dopar% {
  mb <- attach.big.matrix(z)
  res <- numeric(ncol(mb))
  for (i in 1:ncol(mb)) {res[i] <- sum(is.na(mb[,i]))}
  return(res)
}
print(Sys.time() - s) # 54 secs

stopCluster(cl)

## foreach version without apply & bigmemory
cl <- makePSOCKcluster(c(rep("localhost",20)))
registerDoParallel(cl)

s = Sys.time()
l <- foreach(icount(10), .packages=c("bigmemory","biganalytics")) %dopar% {
  res <- numeric(ncol(mm))
  for (i in 1:ncol(mm)) {res[i] <- sum(is.na(mm[,i]))}
  return(res)
}
print(Sys.time() - s) ## 29 secs. (Ok, bigmemory is very slow anyway)

stopCluster(cl)


####################################################################################
### Edit on 2017-04-05
### based on http://stackoverflow.com/questions/43214311/make-dataframe-persist-for-multiple-requests/43215246#43215246

# start 2 R sessions, 1 & 2

# on session 1
require(bigmemory)
system.time(M <- matrix(rnorm(1e8), 1e4)) # ~9"
format(object.size(M), "Mb") # ~762Mb
system.time(M <- as.big.matrix(M)) # ~ 3"

hook = describe(M)
saveRDS(hook, "shared-matrix-hook.rds")
M[1:3,1:3]

# on session 2
require(bigmemory)
system.time(hook <- readRDS("shared-matrix-hook.rds")) # 0.001"

system.time(Mshared <- attach.big.matrix(hook)) # 0.002"

Mshared[1:3,1:3] # shows the same as session 1 did
Mshared[2,2] = 0 # check on session 1 that this change is present there

