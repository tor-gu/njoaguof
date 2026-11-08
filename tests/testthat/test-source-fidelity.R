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

# A separator mismatch once left a leading space on every value after the first in
# a list, which then became NA. First subjects were fine, so the level and constant
# column checks in test-value-sanity.R did not notice.
test_that("subject keeps every known value in the source lists", {
  raw <- uof("use_of_force_raw")
  subject <- uof("subject")
  fields <- c(
    arrested = "SubjectArrested", type = "SubjectType",
    race = "SubjectRaceEthnicity", gender = "SubjectGender"
  )
  for (col in names(fields)) {
    values <- trimws(unlist(strsplit(raw[[fields[[col]]]], ",")))
    known <- values[!values %in% c("", "Not Provided")]
    expect_identical(sum(!is.na(subject[[col]])), length(known), label = col)
  }
})

# Where an injury list has one entry per subject, subject follows it by position.
# Lists of any other length are resolved in the vignette (constant -> that value,
# otherwise NA) and are not checked here.
test_that("subject$injured and injured_prior follow full-length source lists", {
  raw <- uof("use_of_force_raw")
  subject <- uof("subject")
  split <- function(x) strsplit(sub(",\\s*$", "", x), " ?, ?")
  n <- lengths(split(raw$SubjectType))
  key <- paste(subject$form_id, subject$index)
  fields <- c(injured = "SubjectInjuredInIncident",
              injured_prior = "SubjectInjuredPriorToIncident")
  for (col in names(fields)) {
    lists <- split(raw[[fields[[col]]]])
    full <- lengths(lists) == n
    values <- trimws(unlist(lists[full]))
    expected <- c(Yes = TRUE, No = FALSE)[values]
    source_key <- paste(rep(raw$FormID[full], n[full]), sequence(n[full]))
    actual <- subject[[col]][match(source_key, key)]
    expect_identical(actual, unname(expected), label = col)
  }
})

test_that("use_of_force_raw carries one row per incident", {
  expect_identical(nrow(uof("use_of_force_raw")), nrow(uof("incident")))
})

# read_sav() hangs SPSS metadata off every column it reads. data-raw/use_of_force_raw.R
# zaps it
test_that("no column carries SPSS metadata attributes", {
  baggage <- c("label", "labels", "display_width", "format.spss", "format.stata")
  offenders <- character(0)
  for (tbl in all_tables) {
    d <- uof(tbl)
    for (col in names(d)) {
      hit <- intersect(names(attributes(d[[col]])), baggage)
      if (length(hit)) {
        offenders <- c(offenders, paste0(tbl, "$", col, ": ", paste(hit, collapse = ", ")))
      }
    }
  }
  expect_identical(offenders, character(0))
})
