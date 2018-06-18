cars.rds: getdata.R
	Rscript --vanilla getdata.R

table.md: table.R cars.rds summarize.R
	Rscript --vanilla table.R

vars.m4: vars.R cars.rds summarize.R
	Rscript --vanilla vars.R

fig.pdf: fig.R cars.rds summarize.R
	Rscript --vanilla fig.R

report: report.md fig.pdf vars.m4 table.md
	m4 vars.m4 report.md |pandoc -o report.pdf

source: report.md fig.pdf vars.m4 table.md
	m4 vars.m4 report.md > report-current.md

clean:
	rm -vf fig.pdf vars.m4 table.md cars.rds
