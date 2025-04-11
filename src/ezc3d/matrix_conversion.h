#ifndef MATRIX_CONVERSION_H
#define MATRIX_CONVERSION_H

#include <Rcpp.h>
#include <ezc3d/ezc3d_all.h>

// Function to convert an ezc3d::Matrix to an Rcpp::NumericMatrix
Rcpp::NumericMatrix matrix_conversion(const ezc3d::Matrix& m, bool transpose = false) {
  int rows = m.nbRows();
  int cols = m.nbCols();
  Rcpp::NumericMatrix mout(transpose ? cols : rows, transpose ? rows : cols);

  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
      if (transpose) {
        mout(j,i) = m(i,j);
      } else {
        mout(i,j) = m(i,j);
      }
    }
  }

  return(mout);
}

#endif // MATRIX_CONVERSION_H
