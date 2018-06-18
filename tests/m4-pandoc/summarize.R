require(plyr)
cars = readRDS('cars.rds')
# some processing
sum = ddply(cars, .(cyl), summarize, hp.min = min(hp), hp.max = max(hp))
