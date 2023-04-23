# njoaguof 1.12.1

# njoaguof 1.12.0
* Update to most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 02-28-23.dta"

# njoaguof 1.11.0
* Update to most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 12-31-22.dta"
  
# njoaguof 1.10.0
* Update to  most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 11-30-22.dta"

# njoaguof 1.9.0
* Update to use most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 10-31-22.dta"
  
# njoaguof 1.8.0
* Updated to use most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 09-30-22.dta"

# njoaguof 1.7.0
* Updated to use most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 08-31-22.dta"

# njoaguof 1.6.0
* Updated to use most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 07-31-22.dta"

# njoaguof 1.5.0
* Updated to use most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 06-30-22.dta"

# njoaguof 1.4.0
* Updated to use most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 05-31-22.dta"

* Change to incident_subject_force_type:
  - New level `"CS Gas"`.
  
# njoaguof 1.3.0
* Updated to use most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 04-30-22.dta"
  
* Changes in incident_subject_reason_not_arrested:

  - New level `"No Probable Cause- Subject Not Involved"`.
  - Level `"Insufficient Probable Cause -includes continuing investigation"`
  changed to `"Insufficient Probable Cause- includes continuing investigation"`.
  (The whitespace around the `-` changed. This reflects a change in the raw data, and is more consistent with the other levels.)
  
# njoaguof 1.2.3
* Changed three agency names to agree with njoagleod v1.1.2:

  - "Toms River Township" --> "Toms River Twp PD"
  - "Hardyston Twp Police Dept" --> "Hardyston Twp PD"
  - "Linden Police Department" --> "Linden PD"

# njoaguof 1.2.2
* Changed agency "Park Police" to "New Jersey State Park Police", to agree with value in njoagleod v1.1.0.

# njoaguof 1.2.1

* Use census values for "county" and "county subdivision" for `agency_county`,
`incident_municipality` and `incident_municipality_county`. In particular, the
county values `"Other"` and `"NJSP"` now map to `NA`.

* Change some values of `agency_name` to agree with values in `NJOAGLEOD` 
package.
# njoaguof 1.2.0

* Updated to use most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 03-31-22.dta"
* New factor level `"Kneeling on Chest, Back"` in column `force_type`.
* New factor levels `"Insufficient Probable Cause -includes continuing investigation"` and `"No Probable Cause- Crime Unfounded"` in column `reason_not_arrested`.
* FIX to column `force_type`:  Previous releases erroneously treated `"Chokehold, Carotid artery restraint"` as two separate types, (`"Chokehold"` and `"Carotid artery restraint"`). This has been corrected in this release.

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
