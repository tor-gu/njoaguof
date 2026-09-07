# NJ OAG publishes each release in several formats and they are not equivalent.
# The .dta export for the 2026-08-31 release included truncated values and
# some invalid UTF-8. These tests fail if such an export is ever ingested.

test_that("multi-value fields are not truncated at a fixed width", {
  raw <- uof("use_of_force_raw")
  multi <- c(
    "SubjectActions", "SubjectResistance", "ForceType",
    "IncidentType", "ReasonSubjectNotArrested", "PerceivedConditionOfSubject"
  )
  widths <- vapply(
    multi,
    function(f) max(nchar(raw[[f]], type = "bytes"), na.rm = TRUE),
    integer(1)
  )
  # Genuine lists in these columns run to several hundred bytes. Anything at or
  # under the 80-byte cap of the legacy export means values have been lost.
  expect_identical(names(widths)[widths <= 80], character(0))
})

test_that("character columns are valid UTF-8", {
  raw <- uof("use_of_force_raw")
  bad <- vapply(
    Filter(is.character, raw),
    function(x) sum(is.na(iconv(x, "UTF-8", "UTF-8"))),
    integer(1)
  )
  expect_identical(names(bad)[bad > 0], character(0))
})

test_that("use_of_force_raw carries one row per incident", {
  expect_identical(nrow(uof("use_of_force_raw")), nrow(uof("incident")))
})
