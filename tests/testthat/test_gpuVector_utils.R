library(gpuR)
context("gpuVector Utility Functions")

if(detectGPUs() >= 1){
    current_context <- set_device_context("gpu")    
}else{
    current_context <- currentContext()
}

set.seed(123)
ORDER <- 100
A <- sample(seq.int(10), ORDER, replace = TRUE)
D <- rnorm(ORDER)

test_that("integer vector length method successful", {
    
    has_gpu_skip()
    
    gpuA <- gpuVector(A)
    
    s <- length(gpuA)
    
    expect_true(s == ORDER)
})

test_that("float vector length method successful", {
    
    has_gpu_skip()
    
    gpuA <- gpuVector(A, type="float")
    
    s <- length(gpuA)
    
    expect_true(s == ORDER)
})

test_that("double vector length method successful", {
    
    has_gpu_skip()
    has_double_skip()
    
    gpuA <- gpuVector(A, type="double")
    
    s <- length(gpuA)
    
    expect_true(s == ORDER)
})

test_that("gpuVector accession method successful", {
    
    has_gpu_skip()
    
    gpuA <- gpuVector(A)
    gpuF <- gpuVector(D, type="float")
    
    gi <- gpuA[2]
    i <- A[2]
    gs <- gpuF[2]
    s <- D[2]
    
    expect_equivalent(gi, i, info = "igpuVector element access not correct")
    expect_equal(gs, s, tolerance = 1e-07, 
                 info = "fgpuVector element access not correct")
    expect_error(gpuA[101], info = "no error when outside gpuVector size")
})

test_that("dgpuVector accession method successful", {
    
    has_gpu_skip()
    has_double_skip()
    
    gpuD <- gpuVector(D, type = "double")
    
    gs <- gpuD[2]
    s <- D[2]
    
    expect_equivalent(gs, s, info = "dgpuVector element access not correct")
})

test_that("gpuVector set accession method successful", {
    
    has_gpu_skip()
    
    Ai <- sample(seq.int(10), 10, replace = TRUE)
    
    gpuA <- gpuVector(Ai)
    gpuF <- gpuVector(D, type="float")
    
    int = 13L
    float = rnorm(1)
    
    gpuA[2] <- int
    Ai[2] <- int
    gpuF[2] <- float
    D[2] <- float
    
    expect_equivalent(gpuA[], Ai, 
                      info = "igpuVector set element access not correct")
    expect_equal(gpuF[], D, tolerance = 1e-07, 
                 info = "fgpuVector set element access not correct")
    expect_error(gpuA[101] <- 42, 
                 info = "no error when set outside igpuVector size")
    expect_error(gpuF[101] <- 42.42, 
                 info = "no error when set outside fgpuVector size")
})

test_that("dgpuVector set accession method successful", {
    
    has_gpu_skip()
    has_double_skip()
    
    gpuD <- gpuVector(D, type = "double")
    
    float = rnorm(1)
    
    gpuD[2] <- float
    D[2] <- float
    
    expect_equivalent(gpuD[], D, 
                      info = "dgpuVector set element access not correct")
    expect_error(gpuD[101] <- 42.42, 
                 info = "no error when set outside dgpuVector size")
})

test_that("gpuVector as.vector method", {
    
    has_gpu_skip()
    has_double_skip()
    
    dgpu <- gpuVector(D, type = "double")
    fgpu <- gpuVector(D, type="float")
    igpu <- gpuVector(A)
    
    expect_equal(as.vector(dgpu), D,
                      info = "double as.vector not equal")
    expect_equal(as.vector(fgpu), D,
                      info = "float as.vector not equal",
                      tolerance = 1e-07)
    expect_equal(as.vector(dgpu), D,
                      info = "integer as.vector not equal")
    
    
    expect_is(as.vector(dgpu), 'numeric',
              info = "double as.vector not producing 'vector' class")
    expect_is(as.vector(fgpu), 'numeric',
              info = "float as.vector not producing 'vector' class")
    expect_is(as.vector(igpu), 'integer',
              info = "integer as.vector not producing 'vector' class")
})

setContext(current_context)
