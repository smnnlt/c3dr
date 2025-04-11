test_that("formatting works", {
  d <- c3d_read(c3d_example())
  expect_equal(
    format(d),
    paste0(
      "A c3d object with\n- 55 data points and 340 frames\n- 1.70 s ",
      "measurement duration (200 fps)\n- 69 analog channels (2000 fps)\n- 2 ",
      "force platforms with 3400 frames"
    )
  )
})

test_that("printing works", {
  d <- c3d_read(c3d_example())

  expect_snapshot(d)
})

test_that("prints no force platform data if no data is available", {
  d <- c3d_read(c3d_example())
  d_nof <- d # copy without force platform data
  d_nof$parameters$FORCE_PLATFORM$USED <- 0

  expect_snapshot(d_nof)
})

test_that("prints that force platforms have different number of frames", {
  d <- c3d_read(c3d_example())
  d_drate <- d # copy with different frames per force platform
  d_drate$forceplatform[[1]]$meta$frames <- 6800

  expect_snapshot(d_drate)
})
