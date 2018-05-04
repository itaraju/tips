# https://stackoverflow.com/questions/1838806/euclidean-distance-vs-pearson-correlation-vs-cosine-similarity/27393770#27393770
#
# dist() vs cor()

## case: categorical values with differences in frequency (the scale is the same here, only values {0,1})

set.seed(93839)
x1 = rbinom(n=1e3, size=1, prob=0.1)
x2 = rbinom(n=1e3, size=1, prob=0.2)
x3 = rbinom(n=1e3, size=1, prob=0.4)

dist(rbind(x1, x2), method="euclidean")
dist(rbind(x1, x3), method="euclidean")
dist(rbind(x2, x3), method="euclidean")
cor(x1,x2)
cor(x1,x3)
cor(x2,x3)

## x1, x2, x3 are equally unrelated, in the sense that a change from a lower value in x_i[k] to a higher value is not associated with a change (to lower or higher value) in x_j[k]. Despite of this, using dist() it looks like the pair (x1,x2) is more alike than the other pairs. Which is not the same for cor()


## case: real values with differences in variance

set.seed(93839)
x1 = rnorm(n=1e3, sd=1, mean=0)
x2 = rnorm(n=1e3, sd=1, mean=0)
x3 = rnorm(n=1e3, sd=2, mean=0)

dist(rbind(x1, x2), method="euclidean")
dist(rbind(x1, x3), method="euclidean")
dist(rbind(x2, x3), method="euclidean")
cor(x1,x2)
cor(x1,x3)
cor(x2,x3)

## The same here. But this case can be argued to be similar to the differences in scale situation, as x3 will have larger values. 


## TODO: test cosine similarity