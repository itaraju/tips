source('summarize.R')
vars = vector('list', 0)
vars[['CylList']] = paste(unique(sum$cyl), collapse=", ")

# including all vars into .m4 file
strlist = character(0)
for (i in 1:length(vars)) {
    strlist = c(
                strlist,
                paste(
                      'define(',
                      names(vars)[i],
                      ', `',
                      vars[[i]],
                      "')",
                      sep='')
                )
}
writeLines(strlist, con="vars.m4")
cat("vars.m4 made\n")
