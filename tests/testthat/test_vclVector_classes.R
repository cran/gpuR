library(gpuR)
context("vclVector classes")

if(detectGPUs() >= 1){
    current_context <- set_device_context("gpu")    
}else{
    current_context <- currentContext()
}

set.seed(123)
A <- seq.int(10)
D <- rnorm(10)

test_that("vclVector integer class initializer" ,{
    
    has_gpu_skip()
    
    vclA <- vclVector(A)
    vclMiss <- vclVector(length = 3L, type = "integer")
    
    expect_is(vclA, "ivclVector")
    expect_is(vclMiss, "ivclVector")
    expect_equivalent(vclA[], A, 
                      info="vcl integer vector elements not equivalent")
    expect_equal(length(vclA), length(A))
    expect_equal(typeof(vclA), "integer")
    expect_equal(length(vclMiss), 3)
})

test_that("vclVector float class initializer" ,{
    
    has_gpu_skip()
    
    vclD <- vclVector(D, type="float")
    
    expect_is(vclD, "fvclVector")
    expect_equal(vclD[], D, tolerance=1e-07, 
                 info="vcl float vector elements not equivalent")
    expect_equal(length(vclD), length(D))
    expect_equal(typeof(vclD), "float")
})

test_that("vclVector double class initializer" ,{
    
    has_gpu_skip()
    has_double_skip()
    
    vclD <- vclVector(D, type = "double")
    
    expect_is(vclD, "dvclVector")
    expect_equal(vclD[], D, tolerance=.Machine$double.eps ^ 0.5, 
                 info="vcl double vector elements not equivalent")
    expect_equal(length(vclD), length(D))
    expect_equal(typeof(vclD), "double")
})

test_that("fvclVectorSlice class present", {
    has_gpu_skip()
    
    A <- as.numeric(seq(10))
    S <- A[2:8]
    gpuA <- vclVector(A, type = "float")
    gpuS <- slice(gpuA, 2L, 8L)
    
    expect_is(gpuS, "vclVector")
    expect_is(gpuS, "fvclVectorSlice")
    expect_is(gpuS@address, "externalptr")
    expect_match(typeof(gpuS), "float")
    
    expect_equal(gpuS[,], S, tolerance = 1e-07)
    expect_equal(length(gpuS), length(S))
    
    
    # check that slice refers back to original vector
    gpuS[3] <- 42.42
    S[3] <- 42.42
    
    expect_equal(gpuS[], S, tolerance = 1e-07)
    expect_false(isTRUE(all.equal(gpuA[], A, tolerance = 1e-07)),
                 info = "source fvclVector not modified by slice")
    expect_equal(length(gpuA), length(A), 
                 info = "source fvclVector length has been changed")
})

test_that("dvclVectorSlice class present", {
    has_gpu_skip()
    has_double_skip()
    
    A <- as.numeric(seq(10))
    S <- A[2:8]
    gpuA <- vclVector(A, type = "double")
    gpuS <- slice(gpuA, 2L, 8L)
    
    expect_is(gpuS, "vclVector")
    expect_is(gpuS, "dvclVectorSlice")
    expect_is(gpuS@address, "externalptr")
    expect_match(typeof(gpuS), "double")
    expect_equal(gpuS[,], S, tolerance = .Machine$double.eps^0.5)
    expect_equal(length(gpuS), length(S))
    
    
    # check that slice refers back to original vector
    gpuS[3] <- 42.42
    S[3] <- 42.42
    
    expect_equal(gpuS[], S, tolerance = .Machine$double.eps^0.5)
    expect_false(isTRUE(all.equal(gpuA[], A, tolerance = .Machine$double.eps^0.5)),
                 info = "source dvclVector not modified by slice")
    expect_equal(length(gpuA), length(A), 
                 info = "source dvclVector length has been changed")
})

setContext(current_context)
