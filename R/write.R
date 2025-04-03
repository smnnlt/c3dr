#' Write a c3d file in R
#'
#' Write a c3d file using the C++ ezc3d library.
#'
#' This function takes an c3d object in R and writes it to a c3d file. The
#' function creates a new c3d file from scratch and inserts all point data,
#' analog data and parameters in the file. Note that the resulting file will
#' show minor discrepancies compared to the original file (e.g., in terms of
#' file structure). During import and export minor rounding errors can occur.
#'
#' Force platform data export is currently not supported. The header parameters
#' will not be exported but recreated based on the parameter section. If you
#' want to change the header you should change the appropriate parameters
#' instead.
#'
#' Be cautious when writing a modified c3d object to an c3d file, as internal
#' inconsistencies may lead to corrupt files. `c3d_write` and the underlying
#' ezc3d function perform some basic checks but may fail if, for example,
#' parameters and data are inconsistent. You can use the helper function
#' [c3d_setdata()] for modifying point or analog data of a c3d object. Larger
#' modifications may requires expert knowledge of the c3d file structure and
#' parameters.
#'
#' @param x A c3d object.
#' @param file A string with the file path to write to.
#' @returns Returns its input invisible.
#' @examples
#' # read an example file
#' d <- c3d_read(c3d_example())
#'
#' # create a temporary file
#' tmp <- tempfile()
#' on.exit(unlink(tmp))
#'
#' # write c3d file
#' c3d_write(d, tmp)
#'
#' @export

c3d_write <- function(x, file) {
  if (!inherits(x, "c3d")) {
    stop(
      "'x' needs to be an object of class c3d, as generated",
      " by c3d_read() or modified by c3d_setdata()."
    )
  }
  if (!inherits(file, "character")) {
    stop("'file' needs to be a character string with the path wo write to.")
  }
  out <- write(x, file)
  invisible(out)
}
