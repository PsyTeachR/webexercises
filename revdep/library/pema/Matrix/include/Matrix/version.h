#ifndef R_MATRIX_VERSION_H
#define R_MATRIX_VERSION_H

/* Users wanting to do version comparison will include Rversion.h then do, */
/* e.g., R_MATRIX_PACKAGE_VERSION <op> R_Version(major, minor, patch) :    */

/* (version)_{10} = (major minor patch)_{256} */
#define R_MATRIX_PACKAGE_VERSION 67334
#define R_MATRIX_PACKAGE_MAJOR 1
#define R_MATRIX_PACKAGE_MINOR 7
#define R_MATRIX_PACKAGE_PATCH 6

#define R_MATRIX_ABI_VERSION 2

/* (version)_{10} = (major minor patch)_{256} */
#define R_MATRIX_SUITESPARSE_VERSION 460288
#define R_MATRIX_SUITESPARSE_MAJOR 7
#define R_MATRIX_SUITESPARSE_MINOR 6
#define R_MATRIX_SUITESPARSE_PATCH 0

#endif /* R_MATRIX_VERSION_H */
