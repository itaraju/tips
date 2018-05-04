###### Some references:

# http://science.sciencemag.org/content/334/6062/1518.full (DOI: 10.1126/science.1205438)
# https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-015-0697-7#Sec8 (https://doi.org/10.1186/s12859-015-0697-7)
# https://www.nature.com/articles/s41598-017-12783-9 (doi:10.1038/s41598-017-12783-9)


## generating associated (x,y)

## this one looks linear at the central region
set.seed(12345)
N<-200
x<-seq(from=0,to=2*pi,length=N)
signal<-sin(x)
error<-rnorm(N)
y<-signal+error

## less linear version
set.seed(12345)
N<-200
x<-seq(from=0,to=3*pi,length=N)
signal<-sin(x)
error<-rnorm(N, sd=0.5)
y<-signal+error

## non associated (x,y)
set.seed(12345)
x=rnorm(N)
y=rnorm(N)

## linear case
set.seed(12345)
N<-200
x<-seq(from=0,to=2*pi,length=N)
signal<-0.5*x
error<-rnorm(N)
y<-signal+error

##
plot(x,y)
cor(x,y)


####### suggestion from https://stats.stackexchange.com/questions/35893/how-do-i-test-a-nonlinear-association#35922
library(mgcv)
g <- gam(y ~ s(x))
summary(g)
plot(g,scheme=2, ylim=range(y))
points(x,y, col="green")
lines(x,signal, col="red")

summary(g)$r.sq
summary(g)$s.table # it looks that edf/Ref.df are indicators of non-linearity. It's something to check
summary(g)$s.table[,"p-value"]


#####################################################################
### pop struct
## less linear version
set.seed(12345)
N<-200
x<-seq(from=0,to=3*pi,length=N)
signal<-sin(x)
error<-rnorm(N, sd=0.5)
y<-signal+error

## non associated (x,y)
set.seed(12345)
x=rnorm(N)
y=rnorm(N)
