test_that("input validation works", {
  d <- c3d_read(c3d_example())

  expect_error(c3d_write(TRUE, "newdir"), regexp = "'x' needs to")
  expect_error(c3d_write(d, TRUE), regexp = "'file' needs to")
})

test_that("reimport works", {
  d <- c3d_read(c3d_example())
  tmp <- tempfile() # create temporary file
  on.exit(unlink(tmp))
  c3d_write(d, tmp) # write c3d file
  n <- c3d_read(tmp) # reread file

  expect_identical(n$header, d$header) # same header
  expect_identical(n$labels, d$labels) # same labels
  # same analog labels
  expect_identical(n$parameters$ANALOG$LABELS, d$parameters$ANALOG$LABELS)
  # parameters are different
  expect_equal(n$data, d$data, tolerance = 0.0001) # same data
  expect_equal(n$residuals, d$residuals, tolerance = 0.0001)
  expect_equal(n$analog, d$analog, tolerance = 0.0001) # same analogs
  # force platform data is not exported at the moment
})

test_that("c3dr parameter export works", {
  d <- c3d_read(c3d_example())
  tmp <- tempfile() # create temporary file
  on.exit(unlink(tmp))
  c3d_write(d, tmp) # write c3d file
  n <- c3d_read(tmp) # reread file

  expect_identical(n$parameter$EZC3D$BINDING, "c3dr")
  expect_identical(
    n$parameter$EZC3D$C3DR_VERSION,
    as.character(packageVersion("c3dr"))
  )
})
