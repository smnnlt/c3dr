% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/c3dr-package.R
\docType{package}
\name{c3dr-package}
\alias{c3dr}
\alias{c3dr-package}
\title{c3dr: Read and Write C3D Motion Capture Files}
\description{
An wrapper for the ‘EZC3D’ library to work with C3D motion capture data.
}
\section{Main functions:}{
\itemize{
\item Use \code{\link[=c3d_read]{c3d_read()}} for the import of c3d data.
\item Use \code{\link[=c3d_data]{c3d_data()}} and \code{\link[=c3d_analog]{c3d_analog()}} for retrieving the point and the analog
data as a data frame.
\item Use \code{\link[=c3d_write]{c3d_write()}} to write a c3d object to a c3d file.
}
}

\seealso{
Useful links:
\itemize{
  \item \url{https://github.com/smnnlt/c3dr}
  \item \url{https://smnnlt.github.io/c3dr/}
  \item Report bugs at \url{https://github.com/smnnlt/c3dr/issues}
}

}
\author{
\strong{Maintainer}: Simon Nolte \email{s.nolte@dshs-koeln.de} (\href{https://orcid.org/0000-0003-1643-1860}{ORCID})

Other contributors:
\itemize{
  \item Benjamin Michaud (Author of included EZC3D library) [copyright holder]
  \item German Sport University Cologne (0189raq88) [funder]
}

}
\keyword{internal}
