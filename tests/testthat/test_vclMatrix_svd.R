library(gpuR)
context("vclMatrix svd decomposition")


if(detectGPUs() >= 1){
    current_context <- set_device_context("gpu")    
}else{
    current_context <- currentContext()
}

# set seed
set.seed(123)

ORDER <- 10

# Base R objects
X <- matrix(rnorm(ORDER^2), nrow=ORDER, ncol=ORDER)
nsqA <- matrix(rnorm(20), nrow = 4)

rE <- svd(X)
U <- rE$u
V <- rE$v
D <- rE$d

test_that("vclMatrix Single Precision Matrix SVD Decomposition",
          {
              
              has_gpu_skip()
              
              fgpuX <- vclMatrix(X, type="float")
              fgpuA <- vclMatrix(nsqA, type = "float")
                  
              E <- svd(fgpuX)
              
              
              # need to reorder so it matches R output
              ord <- order(-E$d[])
              
              expect_is(E, "list")
              expect_equal(E$d[][ord], D, tolerance=1e-05, 
                           info="float singular values not equivalent")  
              
              # need abs as some signs are opposite (not important with eigenvectors)
              expect_equal(abs(E$u[][,ord]), abs(U), tolerance=1e-05, 
                           info="float left singular vectors not equivalent")  
              
              # make sure X not overwritten
              expect_equal(abs(E$v[][,ord]), abs(V), tolerance=1e-05, 
                           info="float right singular vectors not equivalent") 
              expect_error(svd(fgpuA), "non-square matrix not currently supported for 'svd'",
                           info = "svd shouldn't accept non-square matrices")
          })

test_that("vclMatrix Double Precision Matrix SVD Decomposition", 
          {
              
              has_gpu_skip()
              has_double_skip()
              
              fgpuX <- vclMatrix(X, type="double")
              fgpuA <- vclMatrix(nsqA, type = "double")
              
              E <- svd(fgpuX)    
              
              # need to reorder so it matches R output
              ord <- order(-E$d[])
              
              expect_is(E, "list")
              expect_equal(E$d[][ord], D, tolerance=.Machine$double.eps ^ 0.5, 
                           info="double singular values not equivalent")  
              expect_equal(abs(E$u[][,ord]), abs(U), tolerance=.Machine$double.eps ^ 0.5, 
                           info="double left singular vectors not equivalent")  
              expect_equal(abs(E$v[][,ord]), abs(V), tolerance=.Machine$double.eps ^ 0.5, 
                           info="double right singular vectors not equivalent") 
              
              expect_error(svd(fgpuA), "non-square matrix not currently supported for 'svd'",
                           info = "svd shouldn't accept non-square matrices")
          })

setContext(current_context)
