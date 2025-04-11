test_that("data setting recreates data structure", {
  d <- c3d_read(c3d_example())
  d_wide <- c3d_data(d, "wide")
  d_longest <- c3d_data(d, "longest")

  expect_identical(c3d_setdata(d, newdata = d_wide), d)
  expect_identical(c3d_setdata(d, newdata = d_longest), d)
})

test_that("analog setting recreates data structure", {
  d <- c3d_read(c3d_example())
  a <- c3d_analog(d)

  expect_identical(c3d_setdata(d, newanalog = a), d)
})

test_that("point data modification works", {
  d <- c3d_read(c3d_example())
  d_wide <- c3d_data(d, "wide")
  d_longest <- c3d_data(d, "longest")
  d_cutdata <- d_wide[-340, -(163:165)] # remove last points and last frame
  d_cut <- suppressWarnings(c3d_setdata(d, newdata = d_cutdata))

  # removed point
  expect_equal(d_cut$parameters$POINT$USED, d$parameters$POINT$USED - 1)
  expect_equal(d_cut$header$npoints, d$header$npoints - 1)
  expect_length(d_cut$data[[1]], length(d$data[[1]]) - 1)
  # removed frame
  expect_equal(d_cut$parameters$POINT$FRAMES, d$parameters$POINT$FRAMES - 1)
  expect_equal(d_cut$header$nframes, d$header$nframes - 1)
  expect_length(d_cut$data, length(d$data) - 1)
})

test_that("analog data modification works", {
  d <- c3d_read(c3d_example())
  a <- c3d_analog(d)
  # modified analog data: remove last 10 frames and last analog channel
  a_cutdata <- a[-(3301:3400), -69]
  a_cut <- suppressWarnings(c3d_setdata(d, newanalog = a_cutdata))

  # removed analog channel
  expect_equal(a_cut$parameters$ANALOG$USED, d$parameters$ANALOG$USED - 1)
  expect_equal(a_cut$header$nanalogs, d$header$nanalogs - 1)
  expect_equal(ncol(a_cut$analog[[1]]), ncol(d$analog[[1]]) - 1)
  # removed frames
  expect_length(a_cut$analog, length(d$analog) - 10)
})

test_that("input validation works", {
  d <- c3d_read(c3d_example())

  expect_error(c3d_setdata(data.frame(), d), regexp = "'x' needs to")
  expect_error(c3d_setdata(d, data.frame()), regexp = "'newdata' needs to")
  expect_error(
    c3d_setdata(d, newanalog = data.frame()),
    regexp = "'newanalog' needs to"
  )

  # empty data frames
  emp_data <- data.frame()
  class(emp_data) <- c("c3d_data", "data.frame")
  emp_analog <- data.frame()
  class(emp_analog) <- c("c3d_analog", "data.frame")
  expect_error(
    c3d_setdata(d, newdata = emp_data),
    regexp = "'newdata' is an empty data.frame."
  )
  expect_error(
    c3d_setdata(d, newanalog = emp_analog),
    regexp = "'newanalog' is an empty data.frame."
  )
})

test_that("function without data arguments returns same object", {
  d <- c3d_read(c3d_example())

  expect_identical(c3d_setdata(d), d)
})

test_that("Warnings indicate incompatible point and analog data", {
  d <- c3d_read(c3d_example())
  d_wide <- c3d_data(d, "wide")
  a <- c3d_analog(d)

  # less point frames than analog frames
  expect_warning(
    c3d_setdata(d, newdata = d_wide[-340, ]),
    regexp = "Point data has less frames"
  )
  # more point frames than analog frames
  expect_warning(
    c3d_setdata(d, newdata = rbind(d_wide, d_wide[1, ])),
    regexp = "Point data has more frames .+ corrupt"
  )
  # incorrect number of analog subframes
  expect_warning(
    c3d_setdata(d, newanalog = a[-3400, ]),
    regexp = "not a multiplier"
  )
})
