test_that("create_project with path creates full structure and scaffolding", {
  tmp <- tempdir()
  root <- create_project("test-proj", path = tmp)
  on.exit(unlink(root, recursive = TRUE))

  expect_true(dir.exists(root))
  expect_true(dir.exists(file.path(root, "data", "raw")))
  expect_true(dir.exists(file.path(root, "data", "fmt")))
  expect_true(dir.exists(file.path(root, "data", "output")))
  expect_true(dir.exists(file.path(root, "output", "tables")))
  expect_true(dir.exists(file.path(root, "output", "figures")))
  expect_true(dir.exists(file.path(root, "output", "numbers")))
  expect_true(file.exists(file.path(root, "test-proj.Rproj")))
  expect_true(file.exists(file.path(root, ".gitignore")))
  expect_true(file.exists(file.path(root, "README.md")))
})

test_that("create_project without path creates subdirs in current directory", {
  tmp <- file.path(tempdir(), "inplace-test")
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE))

  withr::with_dir(tmp, {
    create_project()
    expect_true(dir.exists(file.path(tmp, "data", "raw")))
    expect_true(dir.exists(file.path(tmp, "data", "fmt")))
    expect_true(dir.exists(file.path(tmp, "data", "output")))
    expect_true(dir.exists(file.path(tmp, "output", "tables")))
    expect_true(dir.exists(file.path(tmp, "output", "figures")))
    expect_true(dir.exists(file.path(tmp, "output", "numbers")))
    expect_false(file.exists(file.path(tmp, ".Rproj")))
    expect_false(file.exists(file.path(tmp, "README.md")))
  })
})

test_that("create_project errors on invalid name when path is supplied", {
  expect_error(create_project("my project", path = tempdir()), "letters, numbers, and hyphens")
  expect_error(create_project("my_project", path = tempdir()), "letters, numbers, and hyphens")
})

test_that("create_project errors when path supplied but name missing", {
  expect_error(create_project(path = tempdir()), "'name' is required")
})

test_that("create_project errors when name supplied without path", {
  expect_error(create_project("my-project"), "only be used together with 'path'")
})

test_that("create_project errors if directory already exists", {
  tmp <- tempdir()
  root <- create_project("dup-proj", path = tmp)
  on.exit(unlink(root, recursive = TRUE))

  expect_error(create_project("dup-proj", path = tmp), "already exists")
})
