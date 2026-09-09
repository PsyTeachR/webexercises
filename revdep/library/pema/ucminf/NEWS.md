# ucminf 1.2.3

## OTHER USER NON VISIBLE CHANGES

* Updated native code for compatibility with upcoming R changes, including 
stricter native routine registration

## WARNING SUPPRESSION

* Remove non-API call to R: 'Rf_findVarInFrame' in interface.c file to suppress 
warnings

# ucminf 1.2.2

## WARNING SUPPRESSION

* Making Fortran 2018 as default and loop changes to suppress warnings

# ucminf 1.2.1

## BUG FIXES

* Fixed warnings associated with arguments format in interface.c file

# ucminf 1.2.0

* Added a `NEWS.md` file to track changes to the package.

* Use of roxygen comments to generate package elements

* K Hervé Dakpo takes over package maintenance
