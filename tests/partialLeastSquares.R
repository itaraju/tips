set.seed(12345)

###############

#### Matrix X and vector y
xy <- as.matrix(iris[,1:4])

train <- sample(1:150, 100)
test <- setdiff(1:150, train)

x <- xy[train, 1:3]
y <- xy[train, 4]

S <- t(x) %*% y

UDV <- svd(S)

U <- UDV$u
V <- UDV$v

xU <- x %*% U
yU <- y %*% V

beta <- lm(yU ~ xU)$coeff[-1]

xtest <- xy[test, c(1:3)]
yhattest <- xtest %*% U %*% beta %*% t(V)
cor(yhattest, xy[test, 4])

# txtplot(yhattest, xy[test, 4])


#### Matrix X and matrix Y

xy <- as.matrix(iris[,1:4])

# train <- sample(1:150, 100)
# test <- setdiff(1:150, train)

x <- xy[train, 1:2]
y <- xy[train, 3:4]

S <- t(x) %*% y

UDV <- svd(S)

U <- UDV$u
V <- UDV$v

xU <- x %*% U
yU <- y %*% V

beta <- lm(yU ~ xU)$coeff[-1, ]

xtest <- xy[test, c(1:2)]
yhattest <- xtest %*% U %*% beta

yhattest <- xtest %*% U %*% beta %*% t(V)

diag(cor(yhattest, xy[test, 3:4]))
# note that the sign is wrong. Due to svd?
# txtplot(yhattest, xy[test, 4])



