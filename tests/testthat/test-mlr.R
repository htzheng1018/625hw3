# coefficients
test_that("linear regression model works", {
  n = 50
  x1 = rnorm(n)
  x2 = rnorm(n)
  x3 = rnorm(n)
  x = cbind(x1, x2, x3)
  y = 4 + 3 * x1 + 2 * x2 - 1.5 * x3 + rnorm(n)
  expect_equal(round(as.numeric(lrm(y, x)$smry[, "beta"]), 5),
               round(summary(lm(y ~ x1 + x2 + x3))$coefficients[, "Estimate"], 5),
               check.attributes = FALSE)
})

# significance
test_that("linear regression model works", {
  n = 50
  x1 = rnorm(n)
  x2 = rnorm(n)
  x3 = rnorm(n)
  x = cbind(x1, x2, x3)
  y = 4 + 3 * x1 + 2 * x2 - 1.5 * x3 + rnorm(n)
  # significance
  expect_equal(round(as.numeric(lrm(y, x)$smry[, "p value"]), 5),
               round(summary(lm(y ~ x1 + x2 + x3))$coefficients[, "Pr(>|t|)"], 5),
               check.attributes = FALSE)
})

# correlation
test_that("linear regression model works", {
  n = 50
  x1 = rnorm(n)
  x2 = rnorm(n)
  x3 = rnorm(n)
  x = cbind(x1, x2, x3)
  y = 4 + 3 * x1 + 2 * x2 - 1.5 * x3 + rnorm(n)
  # correlation
  expect_equal(round(lrm(y, x)$corr_table, 5),
               round(cor(x), 5), check.attributes = FALSE)
})

# R square
test_that("linear regression model works", {
  n = 50
  x1 = rnorm(n)
  x2 = rnorm(n)
  x3 = rnorm(n)
  x = cbind(x1, x2, x3)
  y = 4 + 3 * x1 + 2 * x2 - 1.5 * x3 + rnorm(n)
  # r square
  expect_equal(round(lrm(y, x)$R_square, 5),
               round(summary(lm(y ~ x1 + x2 + x3))$r.square, 5), check.attributes = FALSE)
})

# If the rank of XtX is 0, the result should be 0
test_that("linear regression model works", {
  n = 50
  x1 = rnorm(n)
  x2 = rnorm(n)
  x3 = rnorm(n)
  x = matrix(0, n, 3)
  colnames(x) = c("x1", "x2", "x3")
  y = 4 + 3 * x1 + 2 * x2 - 1.5 * x3 + rnorm(n)
  # result
  expect_equal(lrm(y, x),
               0, check.attributes = FALSE)
})

# Using Rcpp to calculate mean of x
test_that("Rcpp works", {
  n = 50
  x1 = rnorm(n)
  x2 = rnorm(n)
  x3 = rnorm(n)
  x = cbind(x1, x2, x3)
  y = 4 + 3 * x1 + 2 * x2 - 1.5 * x3 + rnorm(n)
  # r square
  expect_equal(round(lrm(y, x, Rcpp = T), 5),
               round(colMeans(x), 5), check.attributes = FALSE)
})
