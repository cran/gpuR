
#include "gpuR/windows_check.hpp"

#include <RcppEigen.h>

#include "gpuR/dynEigenMat.hpp"
#include "gpuR/dynEigenVec.hpp"

using namespace Rcpp;

template <typename T>
int 
cpp_ncol(SEXP ptrA_)
{       
    XPtr<dynEigenMat<T> > pMat(ptrA_);
    return pMat->ncol();
}

template <typename T>
int 
cpp_nrow(SEXP ptrA_)
{
    XPtr<dynEigenMat<T> > pMat(ptrA_);
    return pMat->nrow();
}

template <typename T>
int 
cpp_gpuVector_size(SEXP ptrA_)
{
    XPtr<dynEigenVec<T> > pMat(ptrA_);
    return pMat->length();
}

template <typename T>
T
cpp_gpuVector_max(
    SEXP ptrA_,
    int ctx_id)
{    
    // viennacl::context ctx(viennacl::ocl::get_context(ctx_id));
    
    // T max;
    
    XPtr<dynEigenVec<T> > ptrA(ptrA_);
    
    Eigen::Map<Eigen::Matrix<T, Eigen::Dynamic, 1> > Am = ptrA->data();
    
    // const int M = Am.size();
    // 
    // viennacl::vector_base<T> vcl_A(M, ctx = ctx);
    // 
    // // viennacl::copy(Am, vcl_A); 
    // viennacl::fast_copy(Am.data(), Am.data() + Am.size(), vcl_A.begin());
    // 
    // max = viennacl::linalg::max(vcl_A);
    
    // max =;
    
    return Am.maxCoeff();
}

template <typename T>
SEXP 
cpp_gpuMatrix_max(SEXP ptrA_)
{       
    XPtr<dynEigenMat<T> > pMat(ptrA_);
    
    Eigen::Map<Eigen::Matrix<T, Eigen::Dynamic, Eigen::Dynamic>, 0, Eigen::OuterStride<> > Am = pMat->data();

    return wrap(Am.maxCoeff());
}

template <typename T>
SEXP 
cpp_gpuMatrix_min(SEXP ptrA_)
{       
    XPtr<dynEigenMat<T> > pMat(ptrA_);
    Eigen::Ref<Eigen::Matrix<T, Eigen::Dynamic, Eigen::Dynamic> > refA = pMat->data();
    
    Eigen::Map<Eigen::Matrix<T, Eigen::Dynamic, Eigen::Dynamic>, 0, Eigen::OuterStride<> > Am(
        refA.data(), refA.rows(), refA.cols(),
        Eigen::OuterStride<>(refA.outerStride())
    );
    
    return wrap(Am.minCoeff());
}

//template <typename T>
//int cpp_gpuVecSlice_length(SEXP ptrA_)
//{
//    Rcpp::XPtr<dynEigenVec<T> > ptrA(ptrA_);
//    const int len = ptrA->end()+1 - ptrA->start();
//    return len;
//}
//
///*** Slice Vector ***/
//// [[Rcpp::export]]
//int
//cpp_gpuVecSlice_length(SEXP ptrA_, const int type_flag)
//{    
//    switch(type_flag) {
//        case 4:
//            return cpp_gpuVecSlice_length<int>(ptrA_);
//        case 6:
//            return cpp_gpuVecSlice_length<float>(ptrA_);
//        case 8:
//            return cpp_gpuVecSlice_length<double>(ptrA_);
//        default:
//            throw Rcpp::exception("unknown type detected for gpuVectorSlice object!");
//    }
//}


/*** gpuVector size ***/

// [[Rcpp::export]]
SEXP
cpp_gpuVector_size(
    SEXP ptrA,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            return wrap(cpp_gpuVector_size<int>(ptrA));
        case 6:
            return wrap(cpp_gpuVector_size<float>(ptrA));
        case 8:
            return wrap(cpp_gpuVector_size<double>(ptrA));
        default:
            throw Rcpp::exception("unknown type detected for vclVector object!");
    }
}

// [[Rcpp::export]]
SEXP
cpp_gpuVector_max(
    SEXP ptrA,
    const int type_flag,
    int ctx_id)
{
    
    switch(type_flag) {
    case 4:
        return wrap(cpp_gpuVector_max<int>(ptrA, ctx_id));
    case 6:
        return wrap(cpp_gpuVector_max<float>(ptrA, ctx_id));
    case 8:
        return wrap(cpp_gpuVector_max<double>(ptrA, ctx_id));
    default:
        throw Rcpp::exception("unknown type detected for gpuVector object!");
    }
}

// [[Rcpp::export]]
SEXP
cpp_gpuMatrix_max(
    SEXP ptrA, 
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            return cpp_gpuMatrix_max<int>(ptrA);
        case 6:
            return cpp_gpuMatrix_max<float>(ptrA);
        case 8:
            return cpp_gpuMatrix_max<double>(ptrA);
        default:
            throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}

// [[Rcpp::export]]
SEXP
cpp_gpuMatrix_min(
    SEXP ptrA, 
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            return cpp_gpuMatrix_min<int>(ptrA);
        case 6:
            return cpp_gpuMatrix_min<float>(ptrA);
        case 8:
            return cpp_gpuMatrix_min<double>(ptrA);
        default:
            throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}

// [[Rcpp::export]]
SEXP
cpp_gpuMatrix_nrow(
    SEXP ptrA, 
    const int type_flag)
{
    
    switch(type_flag) {
    case 4:
        return wrap(cpp_nrow<int>(ptrA));
    case 6:
        return wrap(cpp_nrow<float>(ptrA));
    case 8:
        return wrap(cpp_nrow<double>(ptrA));
    case 10:
        return wrap(cpp_nrow<std::complex<float> >(ptrA));
    case 12:
        return wrap(cpp_nrow<std::complex<double> >(ptrA));
    default:
        throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}

// [[Rcpp::export]]
SEXP
cpp_gpuMatrix_ncol(
    SEXP ptrA, 
    const int type_flag)
{
    
    switch(type_flag) {
    case 4:
        return wrap(cpp_ncol<int>(ptrA));
    case 6:
        return wrap(cpp_ncol<float>(ptrA));
    case 8:
        return wrap(cpp_ncol<double>(ptrA));
    case 10:
        return wrap(cpp_ncol<std::complex<float> >(ptrA));
    case 12:
        return wrap(cpp_ncol<std::complex<double> >(ptrA));
    default:
        throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}


