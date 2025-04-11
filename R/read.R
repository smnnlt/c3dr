#' Read a c3d file in R
#'
#' Import a c3d file using the C++ ezc3d library.
#'
#' This function reads a c3d file with biomechanical data. It returns a c3d
#' object, which is a list of all imported data.
#'
#' The resulting c3d object has the following entries:
#' * **header**: A list with header parameters containing general
#'   meta data for the recording. `nframes` is the total number of frames
#'   recorded. `npoints` is the total number of points recorded. `nanalogs` is
#'   the number of analog channels. `analogperframe` is the rate of analog
#'   frames per point recording frame. `framerate` is the number of point frames
#'   per second. `nevents` is the number of recorded events.
#' * **parameters**: A list with meta data of the recording. The parameters are
#'   organized in groups, similarly to the original structure in the c3d file.
#' * **data**: A list with the point data of the recording. Each element in the
#'   list corresponds to one frame. Use [c3d_data()] to convert the data to a
#'   data frame.
#' * **analog**: A list with the analog data of the recording. Each element of
#'   the list corresponds to one frame of the point recording and contains a
#'   matrix with all analog channels (as columns) for all subframes (as rows).
#'   Use [c3d_analog()] to convert the data to a data frame.
#' * **forceplatform**: A list with force platform data, if available. Each
#'   element in the list corresponds to one force platform. Each force platform
#'   is another list with the following elements: `forces` is a matrix of the
#'   forces. `moments` is a matrix of the moments. `tz` is a matrix of the
#'   moments on the center of pressure. `meta` is a list with further meta data
#'   of the force platform recording (`frames`, `funit` unit of force, `munit`
#'   unit of moments, `punit` unit of center of pressure position, `calmatrix`
#'   calibration matrix, `corners` position of the corners, `origin` position of
#'   the origin).
#' @param file A string with the path of a c3d file.
#'
#' @return A list of class `c3d`.
#'
#' @examples
#' # get example data path
#' path <- c3d_example()
#'
#' d <- c3d_read(path)
#' str(d)
#' @export

c3d_read <- function(file) {
  if (!inherits(file, "character")) {
    stop("'file' needs to be a character string with the path of a C3D file.")
  } else if (!file.exists(file)) {
    stop(
      "'file' needs to be a correct path to a c3d file. Please check that you ",
      "provided the correct path"
    )
  }
  out <- read(file)
  class(out) <- c("c3d", "list")
  out
}
