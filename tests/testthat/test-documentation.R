# The roxygen @format counts can drift without being caught my R CMD check.
rd_text <- function(rd) {
  paste(utils::capture.output(tools::Rd2txt(rd)), collapse = " ")
}

# Only available when the package was installed with its help database, which
# R CMD check does but a bare devtools::test() against a --no-docs install does
# not. Skip rather than error in that case.
rd_db <- function() {
  tryCatch(tools::Rd_db("njoaguof"), error = function(e) NULL)
}

test_that("every shipped dataset is documented", {
  db <- rd_db()
  skip_if(is.null(db) || length(db) == 0, "installed help database not available")
  undocumented <- setdiff(paste0(all_tables, ".Rd"), names(db))
  expect_identical(undocumented, character(0))
})

test_that("documented column counts match the data", {
  db <- rd_db()
  skip_if(is.null(db) || length(db) == 0, "installed help database not available")
  mismatches <- character(0)
  for (tbl in all_tables) {
    rd <- db[[paste0(tbl, ".Rd")]]
    if (is.null(rd)) next
    found <- regmatches(rd_text(rd), regexpr("with [0-9]+ columns", rd_text(rd)))
    if (!length(found)) next
    documented <- as.integer(sub("with ([0-9]+) columns", "\\1", found))
    actual <- ncol(uof(tbl))
    if (!identical(documented, actual)) {
      mismatches <- c(
        mismatches,
        sprintf("%s: documented %d, actual %d", tbl, documented, actual)
      )
    }
  }
  expect_identical(mismatches, character(0))
})
