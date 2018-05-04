library(circlize)

mat = matrix(1:18, 3, 6) 
rownames(mat) = paste0("S", 1:3)
colnames(mat) = paste0("E", 1:6)


rn = rownames(mat) 
cn = colnames(mat)factors = c(rn, cn)factors = factor(factors, levels = factors)col_sum = apply(mat, 2, sum)row_sum = apply(mat, 1, sum)xlim = cbind(rep(0, length(factors)), c(row_sum, col_sum))


par(mar = c(1, 1, 1, 1))circos.par(cell.padding = c(0, 0, 0, 0))circos.initialize(factors = factors, xlim = xlim)

circos.trackPlotRegion(factors = factors, ylim = c(0, 1), bg.border = NA,	bg.col = c("red", "green", "blue", rep("grey", 6)), track.height = 0.05, 
	panel.fun = function(x, y) {
		sector.name = get.cell.meta.data("sector.index")
		xlim = get.cell.meta.data("xlim")
		circos.text(mean(xlim), 1.5, sector.name, adj = c(0.5, 0))		
	}
)

col = c("#FF000020", "#00FF0020", "#0000FF20") 

for(i in seq_len(nrow(mat))) {	for(j in seq_len(ncol(mat))) {		circos.link(rn[i], c(sum(mat[i, seq_len(j-1)]), sum(mat[i, seq_len(j)])),			cn[j], c(sum(mat[seq_len(i-1), j]), sum(mat[seq_len(i), j])), col = col[i], border = "white")	} 
}


￼set.seed(999) 
chordDiagram(mat) 
circos.clear()