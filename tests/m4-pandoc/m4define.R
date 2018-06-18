# including all vars into .m4 file
define = function(..., file="", delim=c("`","'"), append=FALSE) {
    stopifnot(is.character(delim) && length(delim)==2)
    vars = unlist(list(...))
    strlist = character(0)
    for (i in 1:length(vars)) {
        strlist = c(
                    strlist,
                    paste(
                          'define(',
                          names(vars)[i],
                          ', `',
                          vars[i],
                          "')",
                          sep='')
                    )
    }
    writeLines(strlist, con="vars.m4")
}
