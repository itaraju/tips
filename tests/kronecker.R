kron <- function(A, B) {
  Ar = nrow(A)
  Ac = ncol(A)
  Br = nrow(B)
  Bc = ncol(B)
  C = matrix(nrow=Ar*Br, ncol=Ac*Bc)
  
  for (i1 in 1:Ar)
    for (j1 in 1:Ac)
      for (i2 in 1:Br)
        for (j2 in 1:Bc)
          C[(i1-1)*Br+i2, (j1-1)*Bc+j2] = A[i1,j1]*B[i2,j2]
  return(C)
}