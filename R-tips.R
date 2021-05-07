################################################################
## clipboard into data.frame:
#?clipboard
#OS X users can use pipe("pbpaste") and pipe("pbcopy", "w") to read from and write to that system's clipboard.
x = read.table(pipe("pbpaste"))

################################################################
## open xlsx
require(readxl)
dt = read_excel("file.xls")

require(openxlsx) # needs zip in PATH
write.xlsx(list(tab1=df1, tab2=df2, ...), file='x.xlsx')

# reads cell to cell (only xlsx types)
require(tidyxl)
dt = xlsx_cells(path=, sheets=)

## older:
options(java.parameters = "-Xmx200g")
require(XLConnect)
wb <- loadWorkbook("GBSSynOpRIL.xlsx")
getSheets(wb)
details <- readWorksheet(wb, sheet="Details", header=FALSE)

################################################################
library(txtplot)
txtdensity(x)
txtplot(x,y)
txtboxplot(v1,v2,v3)
txtbarchart(as.factor(res),pch="|")

################################################################
## hash
require(digest)
hmac('mykey', x, algo="xxhash32")

################################################################
## hacking formulas
## https://stackoverflow.com/a/35804514/7774591
equation = as.formula("Sepal.Length ~ Sepal.Width")
eval(substitute(lm(.equation, data=iris), list(.equation=equation)))

################################################################
## reg exp substitution (dynamic)
## https://stackoverflow.com/a/48389881/7774591

## example: convert to roman numerals:
sa<-c("Phase 1","Phase 2","Phase 1 | Phase 2","Phase 4")
m <- gregexpr("(\\d)", sa)
regmatches(sa, m) <- sapply(regmatches(sa, m), as.roman)

################################################################
## new R version... re-installing packages
## http://stackoverflow.com/questions/1401904/painless-way-to-install-a-new-version-of-r#3977156
## storing libraries in ~/Library/R/
# bash$ mv ~/Library/R/3.3 ~/Library/R/3.4
update.packages(checkBuilt=TRUE, ask=FALSE)

################################################################
## remove accents
## ref: https://stackoverflow.com/a/35684410
library(stringi)
stri_trans_general( <string> ,"Latin-ASCII")
