#' Printing c3d objects
#'
#' Printing method for c3d objects
#'
#' Prints c3d objects by calling [format.c3d()].
#'
#' @param x A `list` of the class `c3d` to be printed.
#' @param ... empty argument, currently not used.
#'
#' @return The function prints basic information for the c3d object and returns
#'   it invisibly.
#'
#' @examples
#' # Import example data
#' d <- c3d_read(c3d_example())
#'
#' print(d)
#' @export
print.c3d <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
  invisible(x)
}


#' Formatting c3d objects
#'
#' Formatting method for c3d objects
#'
#' @param x A `list` of the class `c3d` to be formatted.
#' @param ... empty argument, currently not used.
#'
#' @return A character string with basic information for the c3d object.
#'
#' @examples
#' # Import example data
#' d <- c3d_read(c3d_example())
#'
#' format(d)
#' @export
format.c3d <- function(x, ...) {
  h <- x$header
  dur <- h$nframes / h$framerate
  afps <- h$analogperframe * h$framerate
  m <- paste0(
    sprintf(
      "A c3d object with\n- %d data points and %d frames\n- %.2f s ",
      h$npoints, h$nframes, dur
    ),
    sprintf(
      "measurement duration (%d fps)\n- %d analog channels (%d fps)",
      h$framerate, h$nanalogs, afps
    )
  )

  # add force platform information if platforms are available
  fp_n <- x$parameters$FORCE_PLATFORM$USED
  if (fp_n != 0) {
    # get number of frames
    # in rare situations this might differ between platforms
    fp_frames <- vector("integer", fp_n)
    for (i in seq_along(x$forceplatform)) {
      fp_frames[i] <- x$forceplatform[[i]]$meta$frames
      # test if all platforms have the same number of frames
      if (length(unique(fp_frames)) == 1) {
        fp_f <- fp_frames[1]
      } else {
        fp_f <- paste(fp_frames, collapse = "/")
      }
    }
    m <- paste0(m, "\n- ", fp_n, " force platforms with ", fp_f, " frames")
  }
  m
}
