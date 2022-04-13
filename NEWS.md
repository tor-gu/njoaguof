# njoaguof (development version)

# njoaguof 1.1.1

* README updated.

# njoaguof 1.1.0

* Updated to use most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 02-28-22.dta"
  
#### Changes due to changes in the underlying raw dataset:

* `incident_date_2`, `on_behalf_of_last_name`, `on_behalf_of_first_name` columns removed from table `incident`
* Table `incident_subject_resistance` added.
* New factor level `"CED Spark Display"` in column `force_type`.
* In table `incident_subject_injury`, the values in the `index` column have been shuffled.

#### Other changes

* In `incident` table, columns `officer_race`, `officer_gender`, and in `subject` table, columns `race` and `gender`: The value of `"Not Provided"` is now coded as `NA`.
* In `incident_subject_xxx` tables, the `index` column is now an integer.
* `format.stata` attributes introduced by `haven` have all been removed.

# njoaguof 1.0.0

* Added a `NEWS.md` file to track changes to the package.
* First public release, based on file 
  "NJOAG Use of Force Data Dashboard 10-01-20 to 01-31-22.dta". 
