#include "gpuR/windows_check.hpp"

#include <RcppEigen.h>

#include "viennacl/ocl/backend.hpp"

// #include "gpuR/dynEigenMat.hpp"
// #include "gpuR/dynVCLMat.hpp"
// #include "gpuR/cl_helpers.hpp"
#include "gpuR/utils.hpp"
#include "gpuR/getVCLptr.hpp"

// using namespace cl;
using namespace Rcpp;

template<typename T>
void
cpp_vclMatrix_custom_chol(
    SEXP ptrB_, 
    const bool BisVCL,
    const int upper,
    SEXP sourceCode_,
    int max_local_size,
    const int ctx_id)
{
    std::string my_kernel = as<std::string>(sourceCode_);
    
    // Rcpp::XPtr<dynVCLMat<T> > ptrA(ptrA_);
    // Rcpp::XPtr<dynVCLMat<T> > ptrB(ptrB_);
    // 
    // viennacl::matrix_range<viennacl::matrix<T> > vcl_A  = ptrA->data();
    // viennacl::matrix_range<viennacl::matrix<T> > vcl_B  = ptrB->data();
    
    viennacl::ocl::context ctx(viennacl::ocl::get_context(ctx_id));
    
    viennacl::matrix<T> *vcl_B;
    
    vcl_B = getVCLptr<T>(ptrB_, BisVCL, ctx_id);
    
    unsigned int M = vcl_B->size1();
    // // int N = vcl_B.size1();
    // int P = vcl_B.size2();
    unsigned int M_internal = vcl_B->internal_size2();
    // int P_internal = vcl_B.internal_size1();
    // viennacl::ocl::curr
    
    // add kernel to program
    viennacl::ocl::program & my_prog = ctx.add_program(my_kernel, "my_kernel");
    
    // get compiled kernel function
    viennacl::ocl::kernel & update_kk = my_prog.get_kernel("update_kk");
    viennacl::ocl::kernel & update_k = my_prog.get_kernel("update_k");
    viennacl::ocl::kernel & update_block = my_prog.get_kernel("update_block");
    cl_device_type type_check = ctx.current_device().type();
    
    if(type_check & CL_DEVICE_TYPE_CPU){
        max_local_size = 1;
    }else{
        cl_device_id raw_device = ctx.current_device().id();
        cl_kernel raw_kernel = ctx.get_kernel("my_kernel", "update_block").handle().get();
        size_t preferred_work_group_size_multiple;
        
        cl_int err = clGetKernelWorkGroupInfo(raw_kernel, raw_device, 
                                              CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE, 
                                              sizeof(size_t), &preferred_work_group_size_multiple, NULL);
        
        max_local_size = roundDown(max_local_size, preferred_work_group_size_multiple);
    }
    
    // set global work sizes
    update_kk.global_work_size(0, 1);
    update_k.global_work_size(0, M_internal);
    update_block.global_work_size(0, M_internal);
    update_block.global_work_size(1, M_internal);
    
    // set local work sizes
    update_kk.local_work_size(0, 1);
    update_k.local_work_size(0, max_local_size);
    update_block.local_work_size(0, max_local_size);
    update_block.local_work_size(1, max_local_size);
    
    // execute kernels
    for(unsigned int k=0; k < M; k++){
        viennacl::ocl::enqueue(update_kk(*vcl_B, M_internal, k));
        viennacl::ocl::enqueue(update_k(*vcl_B, upper, M, M_internal, k));
        viennacl::ocl::enqueue(update_block(*vcl_B, upper, M, M_internal, k));
    }
    
    if(!BisVCL){
        Rcpp::XPtr<dynEigenMat<T> > ptrB(ptrB_);
        
        // copy device data back to CPU
        ptrB->to_host(*vcl_B);
        ptrB->release_device();
    }
}


// [[Rcpp::export]]
void
cpp_vclMatrix_custom_chol(
    SEXP ptrB, 
    const bool BisVCL,
    const int upper,
    SEXP sourceCode,
    int max_local_size,
    const int type_flag,
    const int ctx_id)
{
    switch(type_flag) {
    case 6:
        cpp_vclMatrix_custom_chol<float>(ptrB, BisVCL, upper, sourceCode, max_local_size, ctx_id);
        return;
    case 8:
        cpp_vclMatrix_custom_chol<double>(ptrB, BisVCL, upper, sourceCode, max_local_size, ctx_id);
        return;
    default:
        throw Rcpp::exception("unknown type detected for vclMatrix object!");
    }
}


