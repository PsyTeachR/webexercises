#include <Rinternals.h>
#include <R_ext/Error.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>

#ifndef R_MATRIX_INLINE
# define R_MATRIX_INLINE
#endif

/* ==== cholmod.h =================================================== */

#include "cholmod.h"

#ifdef __cplusplus
extern "C" {
#endif

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(aat)(CHM_SP A, int *fset, size_t fsize, int mode,
                      CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_SP, int *, size_t, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_SP, int *, size_t, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_aat");
	return fn(A, fset, fsize, mode, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(add)(CHM_SP A, CHM_SP B, double alpha[2], double beta[2],
                      int values, int sorted, CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_SP, CHM_SP, double[2], double[2],
	                    int, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_SP, CHM_SP, double[2], double[2],
		                 int, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_add");
	return fn(A, B, alpha, beta, values, sorted, Common);
}

R_MATRIX_INLINE CHM_DN attribute_hidden
R_MATRIX_CHOLMOD(allocate_dense)(size_t nrow, size_t ncol, size_t d, int xtype,
                                 CHM_CM Common)
{
	static CHM_DN (*fn)(size_t, size_t, size_t, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_DN (*)(size_t, size_t, size_t, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_allocate_dense");
	return fn(nrow, ncol, d, xtype, Common);
}

R_MATRIX_INLINE CHM_FR attribute_hidden
R_MATRIX_CHOLMOD(allocate_factor)(size_t n, CHM_CM Common)
{
	static CHM_FR (*fn)(size_t, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_FR (*)(size_t, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_allocate_factor");
	return fn(n, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(allocate_sparse)(size_t nrow, size_t ncol, size_t nzmax,
                                  int sorted, int packed, int stype, int xtype,
                                  CHM_CM Common)
{
	static CHM_SP (*fn)(size_t, size_t, size_t, int, int, int, int,
	                    CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(size_t, size_t, size_t, int, int, int, int,
		                 CHM_CM))
			R_GetCCallable("Matrix", "cholmod_allocate_sparse");
	return fn(nrow, ncol, nzmax, sorted, packed, stype, xtype, Common);
}

R_MATRIX_INLINE CHM_TR attribute_hidden
R_MATRIX_CHOLMOD(allocate_triplet)(size_t nrow, size_t ncol, size_t nzmax,
                                   int stype, int xtype, CHM_CM Common)
{
	static CHM_TR (*fn)(size_t, size_t, size_t, int, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_TR (*)(size_t, size_t, size_t, int, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_allocate_triplet");
	return fn(nrow, ncol, nzmax, stype, xtype, Common);
}

R_MATRIX_INLINE CHM_FR attribute_hidden
R_MATRIX_CHOLMOD(analyze)(CHM_SP A, CHM_CM Common)
{
	static CHM_FR (*fn)(CHM_SP, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_FR (*)(CHM_SP,CHM_CM))
			R_GetCCallable("Matrix", "cholmod_analyze");
	return fn(A, Common);
}

R_MATRIX_INLINE CHM_FR attribute_hidden
R_MATRIX_CHOLMOD(analyze_p)(CHM_SP A, int *Perm, int *fset, size_t fsize,
                            CHM_CM Common)
{
	static CHM_FR (*fn)(CHM_SP, int *, int *, size_t, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_FR (*)(CHM_SP, int *, int *, size_t, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_analyze_p");
	return fn(A, Perm, fset, fsize, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(band_inplace)(int k1, int k2, int mode, CHM_SP A,
                               CHM_CM Common)
{
	static int (*fn)(int, int, int, CHM_SP, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(int, int, int, CHM_SP, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_band_inplace");
	return fn(k1, k2, mode, A, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(change_factor)(int to_xtype, int to_ll, int to_super,
                                int to_packed, int to_monotonic,
                                CHM_FR L, CHM_CM Common)
{
	static int (*fn)(int, int, int, int, int, CHM_FR, CHM_CM) = NULL;
	if (!fn)
	fn = (int (*)(int, int, int, int, int, CHM_FR, CHM_CM))
		R_GetCCallable("Matrix", "cholmod_change_factor");
	return fn(to_xtype, to_ll, to_super, to_packed, to_monotonic, L, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(check_common)(CHM_CM Common)
{
	static int (*fn)(CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_CM))
			R_GetCCallable("Matrix", "cholmod_check_common");
	return fn(Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(check_dense)(CHM_DN A, CHM_CM Common)
{
	static int (*fn)(CHM_DN, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_DN, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_check_dense");
	return fn(A, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(check_factor)(CHM_FR L, CHM_CM Common)
{
	static int (*fn)(CHM_FR, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_FR, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_check_factor");
	return fn(L, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(check_sparse)(CHM_SP A, CHM_CM Common)
{
	static int (*fn)(CHM_SP, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_SP, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_check_sparse");
	return fn(A, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(check_triplet)(CHM_TR T, CHM_CM Common)
{
	static int (*fn)(CHM_TR, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_TR, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_check_triplet");
	return fn(T, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(copy)(CHM_SP A, int stype, int mode, CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_SP, int, int, CHM_CM) = NULL;
	if (!fn)
	fn = (CHM_SP (*)(CHM_SP, int, int, CHM_CM))
		R_GetCCallable("Matrix", "cholmod_copy");
	return fn(A, stype, mode, Common);
}

R_MATRIX_INLINE CHM_DN attribute_hidden
R_MATRIX_CHOLMOD(copy_dense)(CHM_DN A, CHM_CM Common)
{
	static CHM_DN (*fn)(CHM_DN, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_DN (*)(CHM_DN, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_copy_dense");
	return fn(A, Common);
}

R_MATRIX_INLINE CHM_FR attribute_hidden
R_MATRIX_CHOLMOD(copy_factor)(CHM_FR L, CHM_CM Common)
{
	static CHM_FR (*fn)(CHM_FR, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_FR (*)(CHM_FR, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_copy_factor");
	return fn(L, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(copy_sparse)(CHM_SP A, CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_SP, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_SP, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_copy_sparse");
	return fn(A, Common);
}

R_MATRIX_INLINE CHM_TR attribute_hidden
R_MATRIX_CHOLMOD(copy_triplet)(CHM_TR T, CHM_CM Common)
{
	static CHM_TR (*fn)(CHM_TR, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_TR (*)(CHM_TR, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_copy_triplet");
	return fn(T, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(defaults)(CHM_CM Common)
{
	static int (*fn)(CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_CM))
			R_GetCCallable("Matrix", "cholmod_defaults");
	return fn(Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(dense_to_sparse)(CHM_DN X, int values, CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_DN, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_DN, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_dense_to_sparse");
	return fn(X, values, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(factor_to_sparse)(CHM_FR L, CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_FR, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_FR, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_factor_to_sparse");
	return fn(L, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(factorize)(CHM_SP A, CHM_FR L, CHM_CM Common)
{
	static int (*fn)(CHM_SP, CHM_FR, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_SP, CHM_FR, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_factorize");
	return fn(A, L, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(factorize_p)(CHM_SP A, double beta[2], int *fset,
                      size_t fsize, CHM_FR L, CHM_CM Common)
{
	static int (*fn)(CHM_SP, double[2], int *, size_t, CHM_FR, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_SP, double[2], int *, size_t, CHM_FR, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_factorize_p");
	return fn(A, beta, fset, fsize, L, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(finish)(CHM_CM Common)
{
	static int (*fn)(CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_CM))
			R_GetCCallable("Matrix", "cholmod_finish");
	return fn(Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(free_dense)(CHM_DN *A, CHM_CM Common)
{
	static int (*fn)(CHM_DN *, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_DN *,CHM_CM))
			R_GetCCallable("Matrix", "cholmod_free_dense");
	return fn(A, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(free_factor)(CHM_FR *L, CHM_CM Common)
{
	static int (*fn)(CHM_FR *,CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_FR *, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_free_factor");
	return fn(L, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(free_sparse)(CHM_SP *A, CHM_CM Common)
{
	static int (*fn)(CHM_SP *, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_SP *, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_free_sparse");
	return fn(A, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(free_triplet)(CHM_TR *T, CHM_CM Common)
{
	static int (*fn)(CHM_TR *, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_TR *,CHM_CM))
			R_GetCCallable("Matrix", "cholmod_free_triplet");
	return fn(T, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(nnz)(CHM_SP A, CHM_CM Common)
{
	static int (*fn)(CHM_SP, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_SP, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_nnz");
	return fn(A, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(horzcat)(CHM_SP A, CHM_SP B, int mode, CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_SP, CHM_SP, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_SP, CHM_SP, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_horzcat");
	return fn(A, B, mode, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(scale)(CHM_DN S, int scale, CHM_SP A, CHM_CM Common)
{
	static int (*fn)(CHM_DN, int, CHM_SP, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_DN, int, CHM_SP, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_scale");
	return fn(S, scale, A, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(sdmult)(CHM_SP A, int transpose,
                         double alpha[2], double beta[2],
                         CHM_DN X, CHM_DN Y, CHM_CM Common)
{
	static int (*fn)(CHM_SP, int, double[2], double[2],
	                 CHM_DN, CHM_DN, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_SP, int, double[2], double[2],
		              CHM_DN, CHM_DN, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_sdmult");
	return fn(A, transpose, alpha, beta, X, Y, Common);
}

R_MATRIX_INLINE CHM_DN attribute_hidden
R_MATRIX_CHOLMOD(solve)(int sys, CHM_FR L, CHM_DN B, CHM_CM Common)
{
	static CHM_DN (*fn)(int, CHM_FR, CHM_DN, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_DN (*)(int, CHM_FR, CHM_DN, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_solve");
	return fn(sys, L, B, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(solve2)(int sys, CHM_FR L, CHM_DN B,
                         CHM_DN *X_Handle, CHM_DN *Y_Handle, CHM_DN *E_Handle,
                         CHM_CM Common)
{
	static int (*fn)(int, CHM_FR, CHM_DN, CHM_SP,
	                 CHM_DN *, CHM_SP *, CHM_DN *, CHM_DN *, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(int, CHM_FR, CHM_DN, CHM_SP,
		              CHM_DN *, CHM_SP *, CHM_DN *, CHM_DN *, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_solve2");
	return fn(sys, L, B, NULL, X_Handle, NULL, Y_Handle, E_Handle, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(sort)(CHM_SP A, CHM_CM Common)
{
	static int (*fn)(CHM_SP, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_SP, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_sort");
	return fn(A, Common);
}

R_MATRIX_INLINE CHM_DN attribute_hidden
R_MATRIX_CHOLMOD(sparse_to_dense)(CHM_SP A, CHM_CM Common)
{
	static CHM_DN (*fn)(CHM_SP, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_DN (*)(CHM_SP, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_sparse_to_dense");
	return fn(A, Common);
}

R_MATRIX_INLINE CHM_TR attribute_hidden
R_MATRIX_CHOLMOD(sparse_to_triplet)(CHM_SP A, CHM_CM Common)
{
	static CHM_TR (*fn)(CHM_SP, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_TR (*)(CHM_SP, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_sparse_to_triplet");
	return fn(A, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(speye)(size_t nrow, size_t ncol, int xtype, CHM_CM Common)
{
	static CHM_SP (*fn)(size_t, size_t, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(size_t, size_t, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_speye");
	return fn(nrow, ncol, xtype, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(spsolve)(int sys, CHM_FR L, CHM_SP B, CHM_CM Common)
{
	static CHM_SP (*fn)(int, CHM_FR, CHM_SP, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(int,CHM_FR, CHM_SP, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_spsolve");
	return fn(sys, L, B, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(ssmult)(CHM_SP A, CHM_SP B,
                 int stype, int values, int sorted, CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_SP, CHM_SP, int, int, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_SP, CHM_SP, int, int, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_ssmult");
	return fn(A, B, stype, values, sorted, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(submatrix)(CHM_SP A, int *rset, int rsize, int *cset,
                            int csize, int values, int sorted, CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_SP, int *, int, int *,
	                    int, int, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_SP, int *, int, int *,
		                 int, int, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_submatrix");
	return fn(A, rset, rsize, cset, csize, values, sorted, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(transpose)(CHM_SP A, int values, CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_SP, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_SP, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_transpose");
	return fn(A, values, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(triplet_to_sparse)(CHM_TR T, int nzmax, CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_TR, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_TR, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_triplet_to_sparse");
	return fn(T, nzmax, Common);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(updown)(int update, CHM_SP C, CHM_FR L, CHM_CM Common)
{
	static int (*fn)(int, CHM_SP, CHM_FR, CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(int, CHM_SP, CHM_FR, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_updown");
	return fn(update, C, L, Common);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
R_MATRIX_CHOLMOD(vertcat)(CHM_SP A, CHM_SP B, int values, CHM_CM Common)
{
	static CHM_SP (*fn)(CHM_SP, CHM_SP, int, CHM_CM) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_SP, CHM_SP, int, CHM_CM))
			R_GetCCallable("Matrix", "cholmod_vertcat");
	return fn(A, B, values, Common);
}


/* ---- cholmod_start ----------------------------------------------- */
/* NB: keep synchronized with analogues in ../../src/cholmod-common.c */

R_MATRIX_INLINE void attribute_hidden
R_MATRIX_CHOLMOD(error_handler)(int status, const char *file, int line,
                                const char *message)
{
	/* NB: Matrix itself uses cholmod_common_env(ini|set|get) to preserve
	   settings through error calls.  Consider defining *your* own error
	   handler and restoring the instance of cholmod_common that *you* use.
	*/

	if (status < 0)
		Rf_error("CHOLMOD error '%s' at file '%s', line %d",
		         message, file, line);
	else
		Rf_warning("CHOLMOD warning '%s' at file '%s', line %d",
		           message, file, line);
}

R_MATRIX_INLINE int attribute_hidden
R_MATRIX_CHOLMOD(start)(CHM_CM Common)
{
	static int (*fn)(CHM_CM) = NULL;
	if (!fn)
		fn = (int (*)(CHM_CM))
			R_GetCCallable("Matrix", "cholmod_start");
	int ans = fn(Common);
	Common->error_handler = R_MATRIX_CHOLMOD(error_handler);
	return ans;
}

#ifdef	__cplusplus
}
#endif


/* ==== cholmod-utils.h ============================================= */

#ifndef R_MATRIX_NO_CHOLMOD_UTILS

#include "cholmod-utils.h"

#ifdef __cplusplus
extern "C" {
#endif

R_MATRIX_INLINE CHM_FR attribute_hidden
M_sexp_as_cholmod_factor(CHM_FR L, SEXP from)
{
	static CHM_FR (*fn)(CHM_FR, SEXP) = NULL;
	if (!fn)
		fn = (CHM_FR (*)(CHM_FR, SEXP))
			R_GetCCallable("Matrix", "sexp_as_cholmod_factor");
	return fn(L, from);
}

R_MATRIX_INLINE CHM_SP attribute_hidden
M_sexp_as_cholmod_sparse(CHM_SP A, SEXP from,
                         Rboolean checkUnit, Rboolean sortInPlace)
{
	static CHM_SP (*fn)(CHM_SP, SEXP, Rboolean, Rboolean) = NULL;
	if (!fn)
		fn = (CHM_SP (*)(CHM_SP, SEXP, Rboolean, Rboolean))
			R_GetCCallable("Matrix", "sexp_as_cholmod_sparse");
	return fn(A, from, checkUnit, sortInPlace);
}

R_MATRIX_INLINE CHM_TR attribute_hidden
M_sexp_as_cholmod_triplet(CHM_TR A, SEXP from,
                          Rboolean checkUnit)
{
	static CHM_TR (*fn)(CHM_TR, SEXP, Rboolean) = NULL;
	if (!fn)
		fn = (CHM_TR (*)(CHM_TR, SEXP, Rboolean))
			R_GetCCallable("Matrix", "sexp_as_cholmod_triplet");
	return fn(A, from, checkUnit);
}

R_MATRIX_INLINE CHM_DN attribute_hidden
M_sexp_as_cholmod_dense(CHM_DN A, SEXP from)
{
	static CHM_DN (*fn)(CHM_DN, SEXP) = NULL;
	if (!fn)
		fn = (CHM_DN (*)(CHM_DN, SEXP))
			R_GetCCallable("Matrix", "sexp_as_cholmod_dense");
	return fn(A, from);
}

R_MATRIX_INLINE CHM_DN attribute_hidden
M_numeric_as_cholmod_dense(CHM_DN A, double *data, int nrow, int ncol)
{
	static CHM_DN (*fn)(CHM_DN, double *, int, int) = NULL;
	if (!fn)
		fn = (CHM_DN (*)(CHM_DN, double *, int, int))
			R_GetCCallable("Matrix", "numeric_as_cholmod_dense");
	return fn(A, data, nrow, ncol);
}

R_MATRIX_INLINE SEXP attribute_hidden
M_cholmod_factor_as_sexp(CHM_FR L, int doFree)
{
	static SEXP (*fn)(CHM_FR, int) = NULL;
	if (!fn)
		fn = (SEXP (*)(CHM_FR, int))
			R_GetCCallable("Matrix", "cholmod_factor_as_sexp");
	return fn(L, doFree);
}

R_MATRIX_INLINE SEXP attribute_hidden
M_cholmod_sparse_as_sexp(CHM_SP A, int doFree,
                         int ttype, int doLogic, const char *diagString,
                         SEXP dimnames)
{
	static SEXP (*fn)(CHM_SP, int, int, int, const char *, SEXP) = NULL;
	if (!fn)
		fn = (SEXP (*)(CHM_SP, int, int, int, const char *, SEXP))
			R_GetCCallable("Matrix", "cholmod_sparse_as_sexp");
	return fn(A, doFree, ttype, doLogic, diagString, dimnames);
}

R_MATRIX_INLINE SEXP attribute_hidden
M_cholmod_triplet_as_sexp(CHM_TR A, int doFree,
                          int ttype, int doLogic, const char *diagString,
                          SEXP dimnames)
{
	static SEXP (*fn)(CHM_TR, int, int, int, const char *, SEXP) = NULL;
	if (!fn)
		fn = (SEXP (*)(CHM_TR, int, int, int, const char *, SEXP))
			R_GetCCallable("Matrix", "cholmod_triplet_as_sexp");
	return fn(A, doFree, ttype, doLogic, diagString, dimnames);
}

R_MATRIX_INLINE SEXP attribute_hidden
M_cholmod_dense_as_sexp(CHM_DN A, int doFree)
{
	static SEXP (*fn)(CHM_DN, int) = NULL;
	if (!fn)
		fn = (SEXP (*)(CHM_DN, int))
			R_GetCCallable("Matrix", "cholmod_dense_as_sexp");
	return fn(A, doFree);
}

R_MATRIX_INLINE double attribute_hidden
M_cholmod_factor_ldetA(CHM_FR L)
{
	static double (*fn)(CHM_FR) = NULL;
	if (!fn)
		fn = (double (*)(CHM_FR))
			R_GetCCallable("Matrix", "cholmod_factor_ldetA");
	return fn(L);
}

R_MATRIX_INLINE CHM_FR attribute_hidden
M_cholmod_factor_update(CHM_FR L, CHM_SP A, double beta)
{
	static CHM_FR (*fn)(CHM_FR, CHM_SP, double) = NULL;
	if (!fn)
		fn = (CHM_FR (*)(CHM_FR, CHM_SP, double))
			R_GetCCallable("Matrix", "cholmod_factor_update");
	return fn(L, A, beta);
}

#ifdef __cplusplus
}
#endif

#endif /* !defined(R_MATRIX_NO_CHOLMOD_UTILS) */
