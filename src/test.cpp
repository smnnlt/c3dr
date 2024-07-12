#include <Rcpp.h>
#include "ezc3d.h"
#include "Header.h"
using namespace Rcpp;
using namespace ezc3d;

// [[Rcpp::export]]
int read(const std::string &filepath) {
  ezc3d::c3d x = c3d(filepath);
  return x.header().nbFrames();
}
