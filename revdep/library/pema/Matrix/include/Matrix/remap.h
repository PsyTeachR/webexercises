#ifndef R_MATRIX_REMAP_H
#define R_MATRIX_REMAP_H

/* MJ: backwards compatibility with Matrix < 1.6-2 */

#define M_as_cholmod_sparse   M_sexp_as_cholmod_sparse
#define M_as_cholmod_dense    M_sexp_as_cholmod_dense
#define M_chm_factor_to_SEXP  M_cholmod_factor_as_sexp
#define M_chm_sparse_to_SEXP  M_cholmod_sparse_as_sexp
#define M_chm_triplet_to_SEXP M_cholmod_triplet_as_sexp
#define M_chm_factor_ldetL2   M_cholmod_factor_ldetA
#define M_chm_factor_update   M_cholmod_factor_update
#define M_R_cholmod_error     M_cholmod_error_handler
#define M_R_cholmod_start     M_cholmod_start

#endif /* R_MATRIX_REMAP_H */
