#'Multiple Linear Regression Model
#'
#'Gets the mean of x, parameters, sse, t-value, p-value, significance, correlation, R square of linear regression model
#'When compare with the lm() function, our new function can have the same effect but speed up.
#'It is more efficient.
#'When there are NAN values, our model just simply remove the NAN value.
#'
#'@param x input value, y input value
#'
#'@return the summary of linear regression model of x and y
#'
#'@examples
#'x = mtcars[,'hp']
#'y = mtcars[,'mpg']
#'lrm(y,x)
#'
#'@export
#'
# Linear Regression
lrm = function(y, x, Rcpp = F) {
  # missing value
  x = as.matrix(x)
  y = as.matrix(y)
  combined = cbind(y, x)[complete.cases(cbind(y, x)), ]
  y = combined[, 1]
  x = combined[, -1]

  # data
  x = as.matrix(x)

  if (Rcpp == F) {
    # alculate mean of x
    m_x = mean(x)

    y = as.matrix(y)
    x = cbind(1, x)
    n = dim(x)[1]
    p = dim(x)[2]
    colnames(x)[1] = "intercept"

    if (det(t(x) %*% x) == 0) {
      print("The (XT)X matrix is invertable!")
      return(0)
    }

    else {
      # ols estimate beta
      beta_hat = solve(t(x) %*% x) %*% t(x) %*% y

      # partial sse and F-test
      partial_sse = matrix(0, nrow = p)
      sse = 0
      for (i in 1: p) {
        H = x[, 1: i] %*% solve(t(x[, 1: i]) %*% x[, 1: i]) %*% t(x[, 1: i])
        partial_sse[i] = sse - t(y) %*% (diag(1, nrow = n) - H) %*% y
        sse = t(y) %*% (diag(1, nrow = n) - H) %*% y
      }

      # mse
      mse = sse / (n - p)

      # se beta_hat
      var_hat_beta_hat = mse[1] * solve(t(x) %*% x)
      se_beta_hat = sqrt(diag(var_hat_beta_hat))

      # t value
      t_test = beta_hat / se_beta_hat

      # p-value
      p_value = format(2 * (1 - pt(abs(t_test), df = n - p)), scientific = TRUE)

      # significance
      significance = ifelse(p_value <= 0.001, "***",
                            ifelse(p_value <= 0.01, "**",
                                   ifelse(p_value <= 0.05, "*", "")))

      smry = data.frame(cbind(beta_hat, partial_sse, se_beta_hat, t_test, p_value, significance))
      colnames(smry) = c("beta", "partial sse", "se beta_hat", "t value", "p value", "significance")

      # correlation
      cov_table = cov(x[, 2: p], x[, 2: p])
      se_table = apply(x[, 2: p], 2, sd) %*% t(apply(x[, 2: p], 2, sd))
      corr_table = cov_table / se_table

      # R square
      ssy = sum((y - mean(y)) ^ 2)
      r_sqr = 1 - sse / ssy

      # result
      result = list(mean_x = m_x, smry = smry, corr_table = corr_table, R_square = r_sqr)
      return(result)
    }
  } else {
    # Use Rcpp function to calculate mean of x
    return(colMeansRcpp(x))
  }
}
