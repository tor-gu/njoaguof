test_that("incident$form_id is a complete, unique key", {
  form_id <- uof("incident")$form_id
  expect_false(anyNA(form_id))
  expect_identical(anyDuplicated(form_id), 0L)
})

test_that("every child table's form_id exists in incident", {
  known <- uof("incident")$form_id
  orphans <- vapply(
    child_tables,
    function(tbl) length(setdiff(uof(tbl)$form_id, known)),
    integer(1)
  )
  expect_identical(names(orphans)[orphans > 0], character(0))
})

test_that("incident$subject_count matches the rows in subject", {
  incident <- uof("incident")
  counted <- table(uof("subject")$form_id)
  expected <- as.integer(counted[as.character(incident$form_id)])
  # Every incident should have at least one subject, so no NA here.
  expect_false(anyNA(expected))
  expect_identical(as.integer(incident$subject_count), expected)
})

test_that("index columns are positive integers", {
  bad <- vapply(
    indexed_tables,
    function(tbl) {
      idx <- uof(tbl)$index
      as.integer(anyNA(idx) || !is.integer(idx) || any(idx < 1L))
    },
    integer(1)
  )
  expect_identical(names(bad)[bad > 0], character(0))
})

test_that("subject index is contiguous from 1 within each incident", {
  subject <- uof("subject")
  # split() is over 100k groups but still cheap enough for a check that
  # guards the positional assumption the subject table depends on.
  runs <- tapply(subject$index, subject$form_id, function(i) {
    identical(sort(i), seq_along(i))
  })
  expect_true(all(runs))
})
