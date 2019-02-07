# number of simulations
nSimul = 1e4 # S.D. of prob ~ 3e-3
# n of my tries (or how many of the nPeople are a hit for me)
nTries = 3
# n of participants
nPeople = 10
# n of attempts (or how many drawns, or months)
nAtempts = 6

# Computing the probability of all Tries being a drawn hit within the Atempts
set.seed(83410239)
x = sum(replicate(nSimul,
              {
                  all(rowSums(replicate(nAtempts,
                                        {
                                            1:nTries %in% sample.int(size=nTries, n=nPeople)
                                        })) > 0)
              }))/nSimul
data.frame(nPeople, nAtempts, prob=x)
#   nPeople nAtempts   prob
# 1      20        6 0.2398
# 1      17        6 0.3112
# 1      10        3 0.2469
# 1      17        3 0.0707
# 1      10        6 0.6782

# questions:
# how many people are joining on each month?
# what's the evolution of nPeople in last months?
