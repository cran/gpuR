library(gpuR)
context("vclMatrix norm")

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
iX <- matrix(sample(seq.int(16), 16), 4)

o_norm <- norm(X)
i_norm <- norm(X, "I")
f_norm <- norm(X, "F")
m_norm <- norm(X, "M")
s_norm <- norm(X, "2")
o_norm_nsq <- norm(nsqA)
i_norm_nsq <- norm(nsqA, "I")
f_norm_nsq <- norm(nsqA, "F")
m_norm_nsq <- norm(nsqA, "M")
s_norm_nsq <- norm(nsqA, "2")

test_that("CPU vclMatrix Single Precision Matrix Norms",
          {
              
              has_gpu_skip()
              
              fgpuX <- vclMatrix(X, type="float")
              fgpuA <- vclMatrix(nsqA, type = "float")
              
              go_norm <- norm(fgpuX)
              gi_norm <- norm(fgpuX, "I")
              gf_norm <- norm(fgpuX, "F")
              gm_norm <- norm(fgpuX, "M")
              gs_norm <- norm(fgpuX, "2")
              go_norm_nsq <- norm(fgpuA)
              gi_norm_nsq <- norm(fgpuA, "I")
              gf_norm_nsq <- norm(fgpuA, "F")
              gm_norm_nsq <- norm(fgpuA, "M")
              # gs_norm_nsq <- norm(fgpuA, "2")
              
              expect_equal(go_norm, o_norm, tolerance=1e-05, 
                           info="float matrix one norm not equivalent") 
              expect_equal(gi_norm, i_norm, tolerance=1e-05, 
                           info="float matrix infinity norm not equivalent") 
              expect_equal(gf_norm, f_norm, tolerance=1e-05, 
                           info="float matrix frobenius norm not equivalent") 
              expect_equal(gm_norm, m_norm, tolerance=1e-05, 
                           info="float matrix max-mod norm not equivalent") 
              expect_equal(gs_norm, s_norm, tolerance=1e-05, 
                           info="float matrix spectral norm not equivalent") 
              expect_equal(go_norm_nsq, o_norm_nsq, tolerance=1e-05, 
                           info="float matrix one norm not equivalent") 
              expect_equal(gi_norm_nsq, i_norm_nsq, tolerance=1e-05, 
                           info="float matrix infinity norm not equivalent") 
              expect_equal(gf_norm_nsq, f_norm_nsq, tolerance=1e-05, 
                           info="float matrix frobenius norm not equivalent") 
              expect_equal(gm_norm_nsq, m_norm_nsq, tolerance=1e-05, 
                           info="float matrix max-mod norm not equivalent") 
              # expect_equal(gs_norm_nsq, s_norm_nsq, tolerance=1e-04, 
              #              info="float matrix spectral norm not equivalent") 
          })


test_that("CPU vclMatrix Double Precision Matrix Norms",
          {
              
              has_gpu_skip()
              has_double_skip()
              
              fgpuX <- vclMatrix(X, type="double")
              fgpuA <- vclMatrix(nsqA, type = "double")
              
              go_norm <- norm(fgpuX)
              gi_norm <- norm(fgpuX, "I")
              gf_norm <- norm(fgpuX, "F")
              gm_norm <- norm(fgpuX, "M")
              gs_norm <- norm(fgpuX, "2")
              go_norm_nsq <- norm(fgpuA)
              gi_norm_nsq <- norm(fgpuA, "I")
              gf_norm_nsq <- norm(fgpuA, "F")
              gm_norm_nsq <- norm(fgpuA, "M")
              # gs_norm_nsq <- norm(fgpuA, "2")
              
              expect_equal(go_norm, o_norm, tolerance=.Machine$double.eps^0.5, 
                           info="double matrix one norm not equivalent") 
              expect_equal(gi_norm, i_norm, tolerance=.Machine$double.eps^0.5, 
                           info="double matrix infinity norm not equivalent") 
              expect_equal(gf_norm, f_norm, tolerance=.Machine$double.eps^0.5, 
                           info="double matrix frobenius norm not equivalent") 
              expect_equal(gm_norm, m_norm, tolerance=.Machine$double.eps^0.5, 
                           info="double matrix max-mod norm not equivalent") 
              expect_equal(gs_norm, s_norm, tolerance=.Machine$double.eps^0.5, 
                           info="double matrix spectral norm not equivalent") 
              expect_equal(go_norm_nsq, o_norm_nsq, tolerance=.Machine$double.eps^0.5, 
                           info="double matrix one norm not equivalent") 
              expect_equal(gi_norm_nsq, i_norm_nsq, tolerance=.Machine$double.eps^0.5, 
                           info="double matrix infinity norm not equivalent") 
              expect_equal(gf_norm_nsq, f_norm_nsq, tolerance=.Machine$double.eps^0.5, 
                           info="double matrix frobenius norm not equivalent") 
              expect_equal(gm_norm_nsq, m_norm_nsq, tolerance=.Machine$double.eps^0.5, 
                           info="double matrix max-mod norm not equivalent") 
              # expect_equal(gs_norm_nsq, s_norm_nsq, tolerance=.Machine$double.eps^0.5, 
              #              info="double matrix spectral norm not equivalent") 
          })

setContext(current_context)
