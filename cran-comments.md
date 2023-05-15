* This latest submission updates functions to use with quarto

## Test environments

* local R installation, x86_64-apple-darwin17.0, R 4.2.1 (1 NOTE: 1)
* win-builder (devel) x86_64-w64-mingw32 (1 NOTE: 1)
* Rhub
   * Windows Server 2022, R-devel, 64 bit (3 NOTES: 1, 2, 3)
   * Ubuntu Linux 20.04.1 LTS, R-release, GCC (2 NOTES: 1, 4)
   * Fedora Linux, R-devel, clang, gfortran (3 NOTES: 1, 4, 5)

## R CMD check results

0 errors | 0 warnings | 1-3 notes

1. New maintainer: Lisa DeBruine <debruine@gmail.com>
   Old maintainer(s): Dale Barr <dalejbarr@protonmail.com>
2. checking for non-standard things in the check directory ... NOTE
    Found the following files/directories:
      ''NULL''
3. checking for detritus in the temp directory ... NOTE
    Found the following files/directories:
      'lastMiKTeXException'
4. checking HTML version of manual ... NOTE
    Skipping checking HTML validation: no command 'tidy' found
5. checking for future file timestamps ... NOTE
    unable to verify current time

