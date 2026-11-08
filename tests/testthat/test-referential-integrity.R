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

# The test above counts from the same rows it checks, so it cannot catch extra
# subject rows. Releases 1.16.0-2.3.0 made one for every surplus entry in the
# source's injury lists, overcounting 838 incidents.
test_that("incident$subject_count matches the SubjectType list in the source", {
  raw <- uof("use_of_force_raw")
  incident <- uof("incident")
  listed <- lengths(strsplit(sub(",\\s*$", "", raw$SubjectType), " ?, ?"))
  names(listed) <- raw$FormID
  expect_identical(
    as.integer(incident$subject_count),
    unname(listed[as.character(incident$form_id)])
  )
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

# A missing officer_name_id does not identify an officer. Releases 1.1.0-1.15.0
# grouped all such rows as a single officer, which replaced about 200 real
# names with NA.
test_that("officer_name_variants has no missing officer_name_id", {
  expect_false(anyNA(uof("officer_name_variants")$officer_name_id))
})

# Guards against an NA officer_name_id picking up a name through the join.
# Only this direction is checked: the source itself has had rows with an id
# but no name (two in 2022).
test_that("incident$officer_name is NA wherever officer_name_id is NA", {
  incident <- uof("incident")
  expect_true(all(is.na(incident$officer_name[is.na(incident$officer_name_id)])))
})

# The source's marker for a missing name changed from "" to
# "Not Provided Not Provided" in 2024. If a new variant appears, add it to
# officer_name_placeholders in the vignette.
test_that("no officer_name is a 'Not Provided' placeholder", {
  names <- c(
    uof("incident")$officer_name,
    uof("officer_name_variants")$officer_name
  )
  expect_identical(grep("^Not Provided", names, value = TRUE), character(0))
})

# R/incident.R documents this equality. Before 1.16.0 the source count was
# unreliable (often more injured subjects than subjects).
#
# The exceptions are the 77 single-subject incidents (Dec 2021 - Oct 2022) where
# the source repeats the subject's injury entry ("Yes, Yes") and counts each
# repeat. subject_injured_count keeps the published value, so they disagree.
# The list must match exactly: a new mismatch, or one that disappears, fails.
subject_injured_count_exceptions <- c(
  195068, 195476, 195687, 200925, 204422, 213125, 213136, 217488, 227742,
  232312, 239233, 241663, 243227, 247496, 251717, 256866, 257229, 257237,
  259059, 260200, 260951, 263208, 263778, 266592, 267693, 271366, 272767,
  273435, 286603, 290543, 292919, 296775, 302748, 304157, 309091, 313239,
  314701, 315247, 317497, 318321, 318891, 329076, 330794, 344433, 346748,
  346943, 347682, 349330, 351376, 358480, 362384, 362773, 365010, 365230,
  366996, 368389, 371583, 377732, 386004, 388497, 388580, 389718, 392704,
  399689, 400078, 400167, 406241, 406721, 408240, 410355, 420906, 424637,
  425339, 426610, 428895, 446882, 447655
)

test_that("incident$subject_injured_count matches subject$injured", {
  incident <- uof("incident")
  subject <- uof("subject")
  injured <- tapply(subject$injured, subject$form_id, sum)
  key <- as.character(incident$form_id)
  # Incidents with an NA count, or any subject with NA injured, can't be compared.
  known <- !is.na(incident$subject_injured_count) & !is.na(injured[key])
  differs <- known &
    as.integer(incident$subject_injured_count) != as.integer(injured[key])
  expect_identical(
    sort(as.numeric(incident$form_id[differs])),
    sort(subject_injured_count_exceptions)
  )
  # On every exception the source counts more injured subjects than subjects.
  exceptions <- incident$form_id %in% subject_injured_count_exceptions
  expect_true(all(
    incident$subject_injured_count[exceptions] > incident$subject_count[exceptions]
  ))
})

test_that("incident$agency_id is complete and exists in njlea", {
  agency_id <- uof("incident")$agency_id
  expect_false(anyNA(agency_id))
  expect_identical(setdiff(agency_id, njlea::agency$agency_id), character(0))
})

test_that("incident$agency_id agrees with njlea's aliases and agency years", {
  incident <- uof("incident")
  year <- as.integer(format(incident$incident_date_1, "%Y"))
  # Re-resolving against the installed njlea catches a stale build: an alias
  # that njlea has since repointed, or a registry newer than the shipped data.
  expect_identical(
    njlea::resolve_agency(
      "njoaguof", as.character(incident$agency_county), incident$agency_name,
      year = year
    ),
    incident$agency_id
  )
  expect_true(njlea::check_agency_years(incident$agency_id, year))
})

test_that("each (agency_county, agency_name) maps to one agency_id", {
  pairs <- unique(uof("incident")[c("agency_county", "agency_name", "agency_id")])
  expect_identical(anyDuplicated(pairs[c("agency_county", "agency_name")]), 0L)
})
