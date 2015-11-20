library(gpuR)
context("CPU gpuMatrix math operations")

# set option to use CPU instead of GPU
options(gpuR.default.device = "cpu")
options(warn=-1)

# set seed
set.seed(123)

ORDER <- 4

# Base R objects
A <- matrix(rnorm(ORDER^2), nrow=ORDER, ncol=ORDER)
B <- matrix(rnorm(ORDER^2), nrow=ORDER, ncol=ORDER)
E <- matrix(rnorm(15), nrow=5)


test_that("CPU gpuMatrix Single Precision Matrix Element-Wise Trignometry", {
    
    Sin <- sin(A)
    Asin <- asin(A)
    Hsin <- sinh(A)
    Cos <- cos(A)
    Acos <- acos(A)
    Hcos <- cosh(A)
    Tan <- tan(A) 
    Atan <- atan(A)
    Htan <- tanh(A)
    
    fgpuA <- gpuMatrix(A, type="float")
    
    fgpuS <- sin(fgpuA)
    fgpuAS <- asin(fgpuA)
    fgpuHS <- sinh(fgpuA)
    fgpuC <- cos(fgpuA)
    fgpuAC <- acos(fgpuA)
    fgpuHC <- cosh(fgpuA)
    fgpuT <- tan(fgpuA)
    fgpuAT <- atan(fgpuA)
    fgpuHT <- tanh(fgpuA)
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuS[,], Sin, tolerance=1e-07, 
                 info="sin float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuAS[,], Asin, tolerance=1e-07, 
                 info="arc sin float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuHS[,], Hsin, tolerance=1e-07, 
                 info="hyperbolic sin float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuC[,], Cos, tolerance=1e-07, 
                 info="cos float matrix elements not equivalent",
                 check.attributes=FALSE)    
    expect_equal(fgpuAC[,], Acos, tolerance=1e-07, 
                 info="arc cos float matrix elements not equivalent",
                 check.attributes=FALSE)    
    expect_equal(fgpuHC[,], Hcos, tolerance=1e-07, 
                 info="hyperbolic cos float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuT[,], Tan, tolerance=1e-06, 
                 info="tan float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuAT[,], Atan, tolerance=1e-07, 
                 info="arc tan float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuHT[,], Htan, tolerance=1e-07, 
                 info="hyperbolic tan float matrix elements not equivalent",
                 check.attributes=FALSE)  
})

test_that("CPU gpuMatrix Double Precision Matrix Element-Wise Trignometry", {
    
    Sin <- sin(A)
    Asin <- asin(A)
    Hsin <- sinh(A)
    Cos <- cos(A)
    Acos <- acos(A)
    Hcos <- cosh(A)
    Tan <- tan(A) 
    Atan <- atan(A)
    Htan <- tanh(A) 
    
    fgpuA <- gpuMatrix(A, type="double")
    
    fgpuS <- sin(fgpuA)
    fgpuAS <- asin(fgpuA)
    fgpuHS <- sinh(fgpuA)
    fgpuC <- cos(fgpuA)
    fgpuAC <- acos(fgpuA)
    fgpuHC <- cosh(fgpuA)
    fgpuT <- tan(fgpuA)
    fgpuAT <- atan(fgpuA)
    fgpuHT <- tanh(fgpuA)
    
    expect_is(fgpuC, "dgpuMatrix")    
    expect_equal(fgpuS[,], Sin, tolerance=.Machine$double.eps ^ 0.5,
                 info="sin float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuAS[,], Asin, tolerance=.Machine$double.eps ^ 0.5,
                 info="arc sin float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuHS[,], Hsin, tolerance=.Machine$double.eps ^ 0.5, 
                 info="hyperbolic sin float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuC[,], Cos, tolerance=.Machine$double.eps ^ 0.5,
                 info="cos float matrix elements not equivalent",
                 check.attributes=FALSE)    
    expect_equal(fgpuAC[,], Acos, tolerance=.Machine$double.eps ^ 0.5, 
                 info="arc cos float matrix elements not equivalent",
                 check.attributes=FALSE)    
    expect_equal(fgpuHC[,], Hcos, tolerance=.Machine$double.eps ^ 0.5, 
                 info="hyperbolic cos float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuT[,], Tan, tolerance=.Machine$double.eps ^ 0.5,
                 info="tan float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuAT[,], Atan, tolerance=.Machine$double.eps ^ 0.5, 
                 info="arc tan float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpuHT[,], Htan, tolerance=.Machine$double.eps ^ 0.5, 
                 info="hyperbolic tan float matrix elements not equivalent",
                 check.attributes=FALSE) 
})

test_that("CPU gpuMatrix Single Precision Matrix Element-Wise Logs", {
    
    R_log <- log(A)
    R_log10 <- log10(A)
    R_log2 <- log(A, base=2)
    
    fgpuA <- gpuMatrix(A, type="float")
    
    fgpu_log <- log(fgpuA)
    fgpu_log10 <- log10(fgpuA)
    fgpu_log2 <- log(fgpuA, base=2)
    
    expect_is(fgpu_log, "fgpuMatrix")
    expect_is(fgpu_log10, "fgpuMatrix")
    expect_is(fgpu_log2, "fgpuMatrix")
    expect_equal(fgpu_log[,], R_log, tolerance=1e-07, 
                 info="log float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpu_log10[,], R_log10, tolerance=1e-07, 
                 info="log10 float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpu_log2[,], R_log2, tolerance=1e-07, 
                 info="base log float matrix elements not equivalent",
                 check.attributes=FALSE) 
})

test_that("CPU gpuMatrix Double Precision Matrix Element-Wise Logs", {
    
    R_log <- log(A)
    R_log10 <- log10(A)
    R_log2 <- log(A, base=2)
    
    fgpuA <- gpuMatrix(A, type="double")
    
    fgpu_log <- log(fgpuA)
    fgpu_log10 <- log10(fgpuA)
    fgpu_log2 <- log(fgpuA, base=2)
    
    expect_is(fgpu_log, "dgpuMatrix")
    expect_is(fgpu_log10, "dgpuMatrix")
    expect_is(fgpu_log2, "dgpuMatrix")
    expect_equal(fgpu_log[,], R_log, tolerance=.Machine$double.eps ^ 0.5, 
                 info="log float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpu_log10[,], R_log10, tolerance=.Machine$double.eps ^ 0.5, 
                 info="log10 float matrix elements not equivalent",
                 check.attributes=FALSE)  
    expect_equal(fgpu_log2[,], R_log2, tolerance=.Machine$double.eps ^ 0.5, 
                 info="base log float matrix elements not equivalent",
                 check.attributes=FALSE) 
})

test_that("gpuMatrix Single Precision Matrix Exponential", {
    
    R_exp <- exp(A)
    
    fgpuA <- gpuMatrix(A, type="float")
    
    fgpu_exp <- exp(fgpuA)
    
    expect_is(fgpu_exp, "fgpuMatrix")
    expect_equal(fgpu_exp[,], R_exp, tolerance=1e-07, 
                 info="exp float matrix elements not equivalent",
                 check.attributes=FALSE)  
})

test_that("gpuMatrix Double Precision Matrix Exponential", {
    
    R_exp <- exp(A)
    
    fgpuA <- gpuMatrix(A, type="double")
    
    fgpu_exp <- exp(fgpuA)
    
    expect_is(fgpu_exp, "dgpuMatrix")
    expect_equal(fgpu_exp[,], R_exp, tolerance=1e-07, 
                 info="exp double matrix elements not equivalent",
                 check.attributes=FALSE)  
})

options(gpuR.default.device = "gpu")
options(warn=0)