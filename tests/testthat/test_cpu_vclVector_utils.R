library(gpuR)
context("CPU vclVector Utility Functions")

current_context <- set_device_context("cpu")

set.seed(123)
ORDER <- 100
A <- sample(seq.int(10), ORDER, replace = TRUE)
D <- rnorm(ORDER)
D2 <- rnorm(ORDER)

test_that("integer vclVector length method successful", {
    
    has_cpu_skip()
    
    gpuA <- vclVector(A)
    
    s <- length(gpuA)
    
    expect_true(s == ORDER)
})

test_that("float vclVector length method successful", {
    
    has_cpu_skip()
    
    gpuA <- vclVector(A, type="float")
    
    s <- length(gpuA)
    
    expect_true(s == ORDER)
})

test_that("double vclVector length method successful", {
    
    has_cpu_skip()
    
    gpuA <- vclVector(A, type="double")
    
    s <- length(gpuA)
    
    expect_true(s == ORDER)
})

test_that("vclVector accession method successful", {
    
    has_cpu_skip()
    
    gpuA <- vclVector(A)
    gpuF <- vclVector(D, type="float")
    
    gi <- gpuA[2]
    i <- A[2]
    gs <- gpuF[2]
    s <- D[2]
    
    expect_equivalent(gi, i, info = "ivclVector element access not correct")
    expect_equal(gs, s, tolerance = 1e-07, 
                 info = "fvclVector element access not correct")
    expect_error(gpuA[101], info = "no error when outside vclVector size")
})

test_that("dvclVector accession method successful", {
    
    has_cpu_skip()
    
    gpuD <- vclVector(D, type = "double")
    
    gs <- gpuD[2]
    s <- D[2]
    
    expect_equivalent(gs, s, info = "dvclVector element access not correct")
})

test_that("vclVector set accession method successful", {

    has_cpu_skip()
    
    Ai <- sample(seq.int(10), 10, replace = TRUE)
    
    gpuA <- vclVector(Ai)
    gpuF <- vclVector(D, type="float")
    
    int = 13L
    float = rnorm(1)
    
    gpuA[2] <- int
    Ai[2] <- int
    gpuF[2] <- float
    D[2] <- float
    
    expect_equivalent(gpuA[], Ai, 
                      info = "ivclVector set element access not correct")
    expect_equal(gpuF[], D, tolerance = 1e-07, 
                 info = "fvclVector set element access not correct")
    expect_error(gpuA[101] <- 42, 
                 info = "no error when set outside ivclVector size")
    expect_error(gpuF[101] <- 42.42, 
                 info = "no error when set outside fvclVector size")
})

test_that("dvclVector set accession method successful", {
    
    has_cpu_skip()
    
    gpuD <- vclVector(D, type = "double")
    
    float = rnorm(1)
    
    gpuD[2] <- float
    D[2] <- float
    
    expect_equivalent(gpuD[], D, 
                      info = "dvclVector set element access not correct")
    expect_error(gpuD[101] <- 42.42, 
                 info = "no error when set outside dvclVector size")
})


test_that("vclVector as.vector method", {
    
    has_cpu_skip()
    
    dgpu <- vclVector(D, type = "double")
    fgpu <- vclVector(D, type="float")
    igpu <- vclVector(A)
    
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


test_that("CPU vclVector set vector access", {
    
    has_cpu_skip()
    
    gpuA <- vclVector(D, type = "double")
    gpuF <- vclVector(D, type = "float")
    
    gpuA[] <- D2
    gpuF[] <- D2
    
    expect_equivalent(gpuA[], D2,
                      info = "updated dvclVector not equivalent to assigned base vector")
    
    expect_equal(gpuF[], D2, tolerance=1e-07,
                 info = "updated fvclVector not equivalent to assigned base vector")
    
})

test_that("CPU vclVector set vclVector access", {
    
    has_cpu_skip()
    
    gpuA <- vclVector(D, type = "double")
    gpuD <- vclVector(D2, type = "double")
    gpuF <- vclVector(D, type = "float")
    gpuDF <- vclVector(D2, type = "float")
    
    gpuA[] <- gpuD
    gpuF[] <- gpuDF
    
    expect_equivalent(gpuA[], gpuD[], 
                      info = "updated dvclVector not equivalent to assigned vclVector")
    expect_equal(gpuF[], gpuDF[], tolerance=1e-07,
                 info = "updated fvclVector not equivalent to assigned base vclVector")
})

setContext(current_context)
