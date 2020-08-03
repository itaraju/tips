sed <- function(pat, s, args=NULL) {
return(
system2(command = 'sed'
       ,args    = c(sprintf('-e %s', pat), args)
       ,input   = s
       ,stdout  = TRUE
       ,wait    = TRUE
       )
)
}
