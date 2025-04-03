#' Get path to c3dr example
#'
#' Return the file path for an example data files within the `c3dr` package.
#'
#' The test data file contains a short recording of human walking using a
#' full-body model. The test data includes analog channels (e.g., EMG) and data
#' from two force platforms. The recording was made with a Qualisys motion
#' capture system.
#'
#' The file is taken from <https://github.com/pyomeca/ezc3d-testFiles> under a
#' GPL-3.0 license.
#'
#' @return A character vector with the absolute file path of the example
#'   file.
#'
#' @examples
#' c3d_example()
#'
#' @export
c3d_example <- function() {
  system.file("extdata", "example.c3d", package = "c3dr")
}
