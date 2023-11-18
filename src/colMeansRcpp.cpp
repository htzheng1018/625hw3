#include <Rcpp.h>
using namespace Rcpp;

//' Function to calculate column means of a NumericMatrix
//' @param x predictors matrix
//' @return mean of x
// [[Rcpp::export]]
NumericVector colMeansRcpp(NumericMatrix x) {
  int numRows = x.nrow();
  int numCols = x.ncol();

  NumericVector means(numCols);

  for (int j = 0; j < numCols; ++j) {
    double colSum = 0.0;
    for (int i = 0; i < numRows; ++i) {
      colSum += x(i, j);
    }
    means[j] = colSum / numRows;
  }

  return means;
}
