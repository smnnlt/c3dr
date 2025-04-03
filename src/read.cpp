#include <Rcpp.h>
#include "ezc3d/ezc3d_all.h"
#include "ezc3d/matrix_conversion.h"

// [[Rcpp::export]]
Rcpp::List read(const std::string &filepath) {
  ezc3d::c3d f = ezc3d::c3d(filepath);

  // get header params
  int nframes = f.header().nbFrames();
  int nperframe = f.header().nbAnalogByFrame();
  int nanalogs = f.header().nbAnalogs();
  int npoints = f.header().nb3dPoints();

  // get header
  Rcpp::List h = Rcpp::List::create(
    Rcpp::Named("nframes") = nframes,
    Rcpp::Named("npoints") = npoints,
    Rcpp::Named("nanalogs") = nanalogs,
    Rcpp::Named("analogperframe") = nperframe,
    Rcpp::Named("framerate") = f.header().frameRate(),
    Rcpp::Named("nevents") = f.header().nbEvents()
  );

  // get parameters (organized in parameter groups)
  int ngroups = f.parameters().nbGroups(); // number of groups
  Rcpp::CharacterVector g(ngroups); // group names
  Rcpp::NumericVector np(ngroups); // number of parameters per group
  Rcpp::List p(ngroups);
  // create a list of all groups with a list of all group parameters inside
  // iterate over each group
  for (int i = 0; i < ngroups; ++i) {
    g[i] = f.parameters().group(i).name(); // group name
    np[i] = f.parameters().group(i).nbParameters(); // number of parameters
    Rcpp::List q(np[i]);
    Rcpp::CharacterVector nq(np[i]); // parameter names
    // iterate over each parameter inside a group
    for (int j = 0; j < np[i]; j++) {
      nq[j] = f.parameters().group(i).parameter(j).name();
      // convert parameter value based on data type
      ezc3d::DATA_TYPE dt(f.parameters().group(i).parameter(j).type());
      if (dt == ezc3d::DATA_TYPE::INT) {
        q[j] = f.parameters().group(i).parameter(j).valuesAsInt();
      } else if (dt == ezc3d::DATA_TYPE::FLOAT) {
        q[j] = f.parameters().group(i).parameter(j).valuesAsDouble();
      } else if (dt == ezc3d::DATA_TYPE::BYTE) {
        q[j] = f.parameters().group(i).parameter(j).valuesAsByte();
      } else if (dt == ezc3d::DATA_TYPE::WORD || dt == ezc3d::DATA_TYPE::CHAR){
        q[j] = f.parameters().group(i).parameter(j).valuesAsString();
      } else { // for example no or unknown data type
        q[j] = NA_LOGICAL;
      }
    };
    q.names() = nq; // write parameter names as list attribute
    p[i] = q;
  }
  p.names() = g; // write group names as list attribute

  // get point labels
  std::vector<std::string> label(f.parameters().group("POINT").parameter("LABELS").valuesAsString());

  // get analog labels
  std::vector<std::string> alabel(f.parameters().group("ANALOG").parameter("LABELS").valuesAsString());

  // get data
  Rcpp::List d(nframes);
  Rcpp::NumericMatrix res(nframes, npoints);
  // iterate through data
  for (int i = 0; i < nframes; ++i) {
    Rcpp::List frame(npoints);
    for (int j = 0; j < npoints; ++j) {
      float x = f.data().frame(i).points().point(j).x();
      float y = f.data().frame(i).points().point(j).y();
      float z = f.data().frame(i).points().point(j).z();
      float r = f.data().frame(i).points().point(j).residual();
      Rcpp::NumericVector v = {x,y,z};
      frame[j] = v;
      res(i,j) = r;
    }
    d[i] = frame;
  }

  // get analog data
  Rcpp::List a(nframes);
  // iterate through data
  for (int i = 0; i < nframes; ++i) {
    Rcpp::NumericMatrix aframe(nperframe, nanalogs); // subframes x analogchanels
    for (int j = 0; j < nperframe; ++j) {
      for (int k = 0; k < nanalogs; ++k) {
        float a = f.data().frame(i).analogs().subframe(j).channel(k).data();
        aframe(j,k) = a;
      }
    }
    a[i] = aframe;
  }

  // detect if force platform data is available
  std::vector<int> fused = f.parameters().group("FORCE_PLATFORM").parameter("USED").valuesAsInt();

  // if force platform data is available, import data
  Rcpp::List fp_all(fused[0]);
  if (fused[0] != 0) {
    for (int n = 0; n < fused[0]; ++n) {
      ezc3d::Modules::ForcePlatforms fp(f);
      const auto& fp_n = fp.forcePlatform(n);
      // ppp = pf_0.nbFrames();      // Number of frames
      ezc3d::Matrix forces(fp_n.forces());
      ezc3d::Matrix moments(fp_n.moments());
      ezc3d::Matrix cop(fp_n.CoP());
      ezc3d::Matrix tz(fp_n.Tz());

      // transpose all matrices to have x,y,z as columns

      Rcpp::List fp_meta = Rcpp::List::create(
        Rcpp::Named("frames") = fp_n.nbFrames(),
        Rcpp::Named("funit") = fp_n.forceUnit(),
        Rcpp::Named("munit") = fp_n.momentUnit(),
        Rcpp::Named("punit") = fp_n.positionUnit(),
        Rcpp::Named("calmatrix") = matrix_conversion(fp_n.calMatrix(), true),
        Rcpp::Named("corners") = matrix_conversion(fp_n.corners(), true),
        Rcpp::Named("origin") = matrix_conversion(fp_n.origin(), true)
      );

      Rcpp::List fdata = Rcpp::List::create(
        Rcpp::Named("forces") = matrix_conversion(forces, true),
        Rcpp::Named("moments") = matrix_conversion(moments, true),
        Rcpp::Named("cop") = matrix_conversion(cop, true),
        Rcpp::Named("tz") = matrix_conversion(tz, true),
        Rcpp::Named("meta") = fp_meta
      );
      fp_all[n] = fdata;
    }
  }

  Rcpp::List out = Rcpp::List::create(
    Rcpp::Named("header") = h,
    Rcpp::Named("parameters") = p,
    Rcpp::Named("data") = d,
    Rcpp::Named("residuals") = res,
    Rcpp::Named("analog") = a,
    Rcpp::Named("forceplatform") = fp_all
  );
  return(out);
}
