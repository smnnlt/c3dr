#' @keywords internal
#'
#' @details
#'
#' An R package for working with motion capture data based on the C++ library
#' [EZC3D](https://github.com/pyomeca/ezc3d). Users can read, process, and write
#' [C3D](https://www.c3d.org/) files containing biomechanical data.
#'
#' # Main functions:
#' * Use [c3d_read()] for the import of C3D data.
#' * Use [c3d_data()] and [c3d_analog()] for retrieving the point and the analog
#'   data as a data frame.
#' * Use [c3d_write()] to write a c3d object to a C3D file.
"_PACKAGE"


## usethis namespace: start
#' @importFrom Rcpp sourceCpp
#' @useDynLib c3dr, .registration = TRUE
## usethis namespace: end
NULL
