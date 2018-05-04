require(inline)
require(RcppEigen)

transCpp <- "
using Eigen::Map; 
using Eigen::MatrixXi;
using Rcpp::as;

// Map the integer matrix AA from R
const Map<MatrixXi> A(as<Map<MatrixXi> >(AA)); 

// evaluate and return the transpose of A
const MatrixXi At(A.transpose()); return wrap(At);
"

ftrans <- cxxfunction(signature(AA = "matrix"), transCpp, plugin = "RcppEigen")

transCpp.copy <- "
using Eigen::Map; 
using Eigen::MatrixXi;
using Rcpp::as;

// Map the integer matrix AA from R
const MatrixXi A(as<MatrixXi>(AA)); 

// evaluate and return the transpose of A
const MatrixXi At(A.transpose()); return wrap(At);
"
ftrans.cp <- cxxfunction(signature(AA = "matrix"), transCpp.copy, plugin = "RcppEigen")


A <- matrix(1:6, ncol = 2)
ftrans(A)
system.time(replicate(1e6, {t(A)}))
system.time(replicate(1e6, {ftrans(A)})) # pretty fast
system.time(replicate(1e6, {ftrans.cp(A)})) # equaly fast



### includes
incl <- '
using Eigen::LLT;
using Eigen::Lower;
using Eigen::Map;
using Eigen::MatrixXd
using Eigen::MatrixXi;
using Eigen::Upper;
using Eigen::VectorXd;
typedef Map<MatrixXd> MapMatd;
typedef Map<MatrixXi> MapMati; 
typedef Map<VectorXd> MapVecd;
inline MatrixXd AtA(const MapMatd& A) {
  	int n(A.cols());
    return MatrixXd(n,n).setZero().selfadjointView<Lower>().rankUpdate(A.adjoint());
  }
'

cholCpp <- '
const LLT<MatrixXd> llt(AtA(as<MapMatd>(AA)));return List::create(Named("L") = MatrixXd(llt.matrixL()),Named("R") = MatrixXd(llt.matrixU()));'
fchol <- cxxfunction(signature(AA = "matrix"), cholCpp, "RcppEigen", incl)

storage.mode(A) <- "double"
ll <- fchol(A)


########################################################################
### Final functions & tests
########################################################################

###
### Eigen decomposition
###

require(inline)
require(RcppEigen)


eigens <- '
using Eigen::Map;               	
using Eigen::MatrixXd;           
using Eigen::SelfAdjointEigenSolver;
using Rcpp::as;

// Map the integer matrix MM from R (by reference, no copy)
const Map<MatrixXd> M(as<Map<MatrixXd> >(MM)); 

// computes eigen pairs and return a list with them
const SelfAdjointEigenSolver<MatrixXd> es(M);
return List::create(Named("values") = es.eigenvalues(),			   Named("vectors") = es.eigenvectors());
'

feigen <- cxxfunction(signature(MM = "matrix"), eigens, plugin = "RcppEigen")

### Compare values
set.seed(42)
X <- matrix(rnorm(4*4), 4, 4)
Z <- X %*% t(X)

eigen(Z)
feigen(Z)

### Speed test
system.time(replicate(1e5, {eigen(Z)}))
system.time(replicate(1e5, {feigen(Z)}))

###
### Matrix inverse
###

minverses <- '
using Eigen::Map;               	
using Eigen::MatrixXd; 
using Rcpp::as;

// Map the integer matrix MM from R (by reference, no copy)
const Map<MatrixXd> M(as<Map<MatrixXd> >(MM)); 

// computes inverse and returns it
const MatrixXd ret(M.inverse());
return wrap(ret);
'
finverse <- cxxfunction(signature(MM = "matrix"), minverses, plugin = "RcppEigen")

### Compare values
set.seed(4253)
X <- matrix(rnorm(5*5), 5, 5)

solve(X)
finverse(X)

### Speed test
system.time(replicate(1e5, {solve(X)}))
system.time(replicate(1e5, {finverse(X)}))