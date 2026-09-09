#ifndef R_MATRIX_ALLOCA_H
#define R_MATRIX_ALLOCA_H

/* MJ: alloca-using macros (currently opt-out, eventually opt-in) */

/* Copy and paste from Defn.h : */
/* 'alloca' is neither C99 nor POSIX */
#ifdef __GNUC__
/* This covers GNU, Clang and Intel compilers */
/* #undef needed in case some other header, e.g. malloc.h, already did this */
# undef alloca
# define alloca(x) __builtin_alloca((x))
#else
# ifdef HAVE_ALLOCA_H
/* This covers native compilers on Solaris and AIX */
#  include <alloca.h>
# endif
/* It might have been defined via some other standard header, e.g. stdlib.h */
# if !HAVE_DECL_ALLOCA
extern void *alloca(size_t);
# endif
#endif

#define AS_CHM_FR(x) \
	M_sexp_as_cholmod_factor((CHM_FR) alloca(sizeof(cholmod_factor)), x)

#define AS_CHM_SP(x) \
	M_sexp_as_cholmod_sparse((CHM_SP) alloca(sizeof(cholmod_sparse)), x, \
	                         (Rboolean) 1, (Rboolean) 0)

#define AS_CHM_SP__(x) \
	M_sexp_as_cholmod_sparse((CHM_SP) alloca(sizeof(cholmod_sparse)), x, \
	                         (Rboolean) 0, (Rboolean) 0)

#define AS_CHM_DN(x) \
	M_sexp_as_cholmod_dense ((CHM_DN) alloca(sizeof(cholmod_dense )), x)

#define N_AS_CHM_DN(x, m, n) \
	M_numeric_as_cholmod_dense((CHM_DN) alloca(sizeof(cholmod_dense)), x, m, n)

#endif /* R_MATRIX_ALLOCA_H */
