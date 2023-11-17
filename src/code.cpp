#include <Rcpp.h>
using namespace Rcpp;

//'@parameter x the variables matrix
 //'@return mean of x

 // [[Rcpp::export]]
 double mean_rcpp(NumericVector x) {
   int n = x.size();
   double sum = 0.0;

   for (int i = 0; i < n; ++i) {
     sum += x[i];
   }

   return sum / n;
 }
