library(parallel)

cl=makePSOCKcluster(
  names=c("ag-pbg-wheatgs.ag.cornell.edu",
  "ag-pbg-wheatgs.ag.cornell.edu","localhost"))


cl=makePSOCKcluster(c("srv-bio3", "srv-bio3"))
cl=makePSOCKcluster(c("localhost", "localhost"))
cl=makePSOCKcluster(c("bio3r", "bio3r"))

  
testF <- function(n){
  M = matrix(rnorm(n*n), ncol=n)  
  x = prcomp(M)
  y = x$sdev^2
  return(sum(y[1:min(10,n)])/sum(y))
}
x = clusterCall(cl, testF, n=1500)

##################################
## using foreach
require(doParallel)
require(foreach)

registerDoParallel(cl)

x = foreach(i=1:2) %dopar% {testF(1500)}

stopCluster(cl)

##################################
## comparing forks and cluster
require(parallel)
require(doParallel)
require(doMC)
require(foreach)

registerDoMC(cores=4)

cl=makePSOCKcluster(rep("localhost",4))
registerDoParallel(cl)

system.time(x <- foreach(i=1:4) %dopar% {testF(1500)})

stopCluster(cl)


########################################
## testing notifications via pushbullet
require(RPushbullet)
require(parallel)
require(doParallel)
require(foreach)

cl=makePSOCKcluster(rep("localhost",3))
registerDoParallel(cl)
system.time(x <- foreach(i=1:4, .packages="RPushbullet") %dopar% {
  testF(1500)
  pbPost("note", paste("worker",i),"first step", channel = "svs")
  testF(1500)
  pbPost("note", paste("worker",i),"second step", channel = "svs")
})

pbPost("note", "hey", "does it work?",channel="svs")

