% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert.R
\name{c3d_convert}
\alias{c3d_convert}
\title{Convert between c3d point data formats}
\usage{
c3d_convert(data, format)
}
\arguments{
\item{data}{A data frame of class \code{c3d_data} as generated by \code{\link[=c3d_data]{c3d_data()}}.}

\item{format}{Either "wide", "long", or "longest" to determine the format of
the resulting data frame. The wide format has Long format has three columns
per point (x,y,z), the long format has three rows per frame per point
(x,y,z). The longest format has one row per data entry.}
}
\value{
A data frame of class \code{c3d_data} in the format specified by the
\code{format} argument.
}
\description{
Convert between different representation of point data in c3d files.
}
\examples{
# Import example data
d <- c3d_read(c3d_example())
# get point data in wide format
w <- c3d_data(d, format = "wide")
# convert to long data
l <- c3d_convert(w, "long")
head(l)
}
