test_that("input validation works", {
  expect_error(c3d_read(TRUE), regexp = "'file' needs to ")
})

test_that("import returns c3d class list", {
  d <- c3d_read(c3d_example())

  expect_type(d, "list")
  expect_s3_class(d, c("c3d", "list"))
})

test_that("header import works", {
  d <- c3d_read(c3d_example())

  expect_type(d$header, "list")
})

test_that("data import works", {
  d <- c3d_read(c3d_example())

  # correct number of data frames
  expect_length(d$data, d$header$nframes)
  # correct number of data points
  expect_length(d$data[[1]], d$header$npoints)
  # correct number of dimensions
  expect_length(d$data[[1]][[1]], 3L)
  # correct first data record
  expect_equal(
    d$data[[1]][[1]], c(-220.1226, 306.4248, 846.3361),
    tolerance = 0.001
  )
})

test_that("label import works", {
  d <- c3d_read(c3d_example())

  expect_length(d$parameters$POINT$LABELS, d$header$npoints)
})

test_that("parameter import works", {
  d <- c3d_read(c3d_example())

  expect_snapshot(d$parameters)
})

test_that("force platform data import works", {
  d <- c3d_read(c3d_example())

  expect_length(d$forceplatform, d$parameters$FORCE_PLATFORM$USED)
  expect_identical(ncol(d$forceplatform[[1]]$forces), 3L)
  expect_identical(nrow(d$forceplatform[[1]]$forces), 3400L)
  expect_equal(
    d$forceplatform[[1]]$forces[1, ],
    c(0.1399, 0.0461, -0.1835),
    tolerance = 0.001
  )
})
