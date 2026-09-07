# Check the we aren't shipping a constant column (perhaps signifying a change in
# in data format)
test_that("no logical column is constant", {
  offenders <- character(0)
  for (tbl in all_tables) {
    d <- uof(tbl)
    for (col in names(d)) {
      if (!is.logical(d[[col]])) next
      present <- unique(d[[col]][!is.na(d[[col]])])
      if (length(present) < 2) {
        offenders <- c(offenders, paste0(tbl, "$", col))
      }
    }
  }
  # A logical that is never TRUE (or never FALSE) usually means the source
  # wording changed and the parsing silently stopped matching.
  expect_identical(offenders, character(0))
})

# Levels that are deliberately declared but absent from the data may signal
# a change in the source data coding.
known_empty_levels <- list(
  "incident$officer_race" = c("Asian/Pacific Islander", "Pacific Islander"),
  "incident$officer_gender" = "Non-Binary/X",
  "incident$video_footage" = "Unknown",
  "incident_subject_injury$subject_injury" = "No Injury",
  "incident_subject_medical_treatment$subject_medical_treatment" = "Not Provided",
  "incident_subject_resistance$subject_resistance" = "Dead-weight tactics(going limp)",
  "subject$race" = c(
    "Asian/Pacific Islander",
    "Native Hawaiian or other Pacific Islander",
    "Pacific Islander"
  ),
  "subject$gender" = "Other"
)

test_that("every declared factor level is used, or is a known exception", {
  unexpected <- character(0)
  for (tbl in all_tables) {
    d <- uof(tbl)
    for (col in names(d)) {
      if (!is.factor(d[[col]])) next
      key <- paste0(tbl, "$", col)
      empty <- setdiff(levels(d[[col]]), unique(as.character(d[[col]])))
      empty <- setdiff(empty, known_empty_levels[[key]])
      if (length(empty)) {
        unexpected <- c(unexpected, paste0(key, ": ", paste(empty, collapse = " | ")))
      }
    }
  }
  # An unexpected empty level means either the split dropped values that should
  # have matched it, or the level is stale and should be retired.
  expect_identical(unexpected, character(0))
})

test_that("incident dates fall in a plausible range", {
  dates <- uof("incident")$incident_date_1
  expect_false(anyNA(dates))
  # The dashboard starts at 2020-10-01 and cannot report the future.
  expect_gte(as.numeric(min(dates)), as.numeric(as.Date("2020-10-01")))
  expect_lte(as.numeric(max(dates)), as.numeric(Sys.Date()))
})

test_that("officer_age is either missing or plausible", {
  age <- uof("incident")$officer_age
  present <- age[!is.na(age)]
  expect_gte(min(present), 18)
  expect_lte(max(present), 67)
})
