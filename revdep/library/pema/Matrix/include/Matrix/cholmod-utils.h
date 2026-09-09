#ifndef R_MATRIX_CHOLMOD_UTILS_H
#define R_MATRIX_CHOLMOD_UTILS_H

#include <Rinternals.h>
#include "cholmod.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef R_MATRIX_INLINE
# define R_MATRIX_INLINE
#endif

R_MATRIX_INLINE CHM_FR M_sexp_as_cholmod_factor(
	CHM_FR, SEXP);
R_MATRIX_INLINE CHM_SP M_sexp_as_cholmod_sparse(
	CHM_SP, SEXP, Rboolean, Rboolean);
R_MATRIX_INLINE CHM_TR M_sexp_as_cholmod_triplet(
	CHM_TR, SEXP, Rboolean);
R_MATRIX_INLINE CHM_DN M_sexp_as_cholmod_dense(
	CHM_DN, SEXP);
R_MATRIX_INLINE CHM_DN M_numeric_as_cholmod_dense(
	CHM_DN, double *, int, int);

R_MATRIX_INLINE   SEXP M_cholmod_factor_as_sexp(
	CHM_FR, int);
R_MATRIX_INLINE   SEXP M_cholmod_sparse_as_sexp(
	CHM_SP, int, int, int, const char *, SEXP);
R_MATRIX_INLINE   SEXP M_cholmod_triplet_as_sexp(
	CHM_TR, int, int, int, const char *, SEXP);
R_MATRIX_INLINE   SEXP M_cholmod_dense_as_sexp(
	CHM_DN, int);

R_MATRIX_INLINE double M_cholmod_factor_ldetA(
	CHM_FR);
R_MATRIX_INLINE CHM_FR M_cholmod_factor_update(
	CHM_FR, CHM_SP, double);

#ifdef __cplusplus
}
#endif

#endif /* R_MATRIX_CHOLMOD_UTILS_H */
