# njoaguof 2.4.0
* Fixes for `subject`:
  - Since 1.16.0, every subject after the first in an incident lost `arrested`,
    `type`, `race` and `gender`, and some lost `juvenile`. The source's lists
    switched to `", "` as a separator and the split did not allow for the space.
    Counts of subjects by race or gender from 1.16.0 to 2.3.0 are too low: for
    example, 1,177 more subjects now have a known race.
  - Removed 851 rows that were not subjects (113,918 rows are now 113,067). On 838
    incidents from 2020-10 to 2022-10, the source's injury lists have more entries
    than there are subjects, and each extra entry made a row. Rows now follow the
    source's `SubjectType` list.
  - `injured` and `injured_prior` are now `NA` where the source's list cannot be
    matched to subjects: a list that is too short, or too long with differing
    entries. A too-long list whose entries are all the same gives that value to
    every subject.
  - `gender`: `Non-Binary/X` is now `Gender Non-Conforming/X` (110 rows), the
    label used for officers and on the reporting form.

* Fixes for `incident`:
  - `officer_gender`: 48 `Gender Non-Conforming/X` values, `NA` since 1.16.0,
    are restored.
  - `subject_count` was too high on 838 incidents (see above).

* `subject$gender` no longer has the level `Other`, which the source never uses
  for subjects. `incident$officer_gender` keeps it.

* Warning for `incident$officer_gender`: the source value `Other` (74,331
  incidents, two thirds of the data) is not an option on the reporting form,
  NJ OAG has not said what it means, and later source releases replaced about
  20,500 recorded officer genders with it. It is kept as published.

* Links to the NJ OAG Use of Force Reporting Portal Guide in the README and in
  the `incident`, `subject` and `use_of_force_raw` documentation.

* Warning for `incident$subject_injured_count`, which is unchanged: on 77
  single-subject incidents from 2021-12 to 2022-10, the source repeats the
  subject's injury entry (`"Yes, Yes"`) and counts each repeat, giving 2 or 3
  injured subjects for one subject. For a count per subject, use
  `subject$injured`.

# njoaguof 2.3.0
* Update to most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 10-31-26.sav"

# njoaguof 2.2.0
* New column `incident$agency_id`: the agency's
  [njlea](https://github.com/tor-gu/njlea) 0.1.0 ID, for joining with other NJ law
  enforcement datasets. Every incident has one (538 agencies).

* njoaguof now imports njlea and re-exports `get_agencies()`,
  `get_agency_municipalities()` and `find_agency()`, for canonical agency
  names, level and function, and the municipalities each agency serves.
  These are the package's first exports; the datasets are still reached with
  `data()`.

# njoaguof 2.1.2
* Fix for `incident` and `officer_name_variants`:
  - The source placeholder "Not Provided Not Provided", which has appeared
    since 1.16.0, is now treated as an `NA` `officer_name`.

* Documentation fixes:
  - Source column names updated to match the current source file throughout.
  - The `subject_injured_count` warning now says the field has been reliable
    since 1.16.0.

# njoaguof 2.1.1
* Fix for `incident`:
  - `video_footage` was `NA` instead of `Unknown` for 1,981 rows.

* Change to `incident_subject_resistance`:
  - Removed the unused level `Dead-weight tactics(going limp)` from
    `subject_resistance`.

# njoaguof 2.1.0
* Update to most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 09-30-26.sav"

* Six incident reports (`form_id`s) present in the 2026-08-31 release are
  absent from this release. All are Union City PD forms; the incidents
  themselves remain, via other officers' forms.
  - `2400274` (`HUDSON-UNION CITY PD-26-045085`)
  - `2446802` (`HUDSON-UNION CITY PD-26-060557`)
  - `2467408` (`HUDSON-UNION CITY PD-26-066523`)
  - `2545044` (`HUDSON-UNION CITY PD-26-087867`)
  - `2578443` (`HUDSON-UNION CITY PD-26-097016`)
  - `2578618` (`HUDSON-UNION CITY PD-26-097016`)

# njoaguof 2.0.1
* Removed the superfluous SPSS metadata attributes (`label` and `display_width`) that the
  `.sav` reader introduced in 2.0.0. No values are changed.

# njoaguof 2.0.0
* Breaking changes:
  - `Depends: R (>= 4.1)`, up from `3.5`
  - magrittr pipe `%>%` no longer exported.

* Update to most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 08-31-26.sav"

* Fix for `incident`:
  - `officer_injured` was `FALSE` for every row 1.17.0.

* Fix for `subject`:
  - `juvenile` was never `TRUE` for every row in 1.17.0.

* Fix for `incident_subject_force_type`:
  - Two force types containing an internal comma, `"Kneeling on Chest, Back"`
    and `"Chokehold, Carotid artery restraint"`, previously dropped, are restored.

* Change to `incident_subject_force_type`:
  - Collapsed `Kneeling on Chest, Back` and 
    `Kneeling on Chest, Back for prolonged period`. The OAG started using
    using the longer form in 2025. We have combined them, using the current,
    longer form.

* Added a `testthat` suite. It covers referential integrity between the tables
  and the three miscoding patterns behind the fixes above: a logical column that
  is never `TRUE`, a declared factor level that never appears, and a source
  export whose fixed-width columns truncate the multi-value fields.

# njoaguof 1.17.0
* Update to most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 10-31-24.dta"

# njoaguof 1.16.0
* Update to most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 09-30-24.dta"

* Change to `incident`:
  - New variable `other_officer_involved`
  - New variable `officer_in_uniform`

* Change to `subject`:
  - New variable `injured`
  - New variable `injured_prior`

* Change to `incident_contact_origin`:
  - New level `Officer Dispatched`
  
* Change to `incident_planned_contact`:
  - New level `No Knock Warrant`
  
# njoaguof 1.15.0
* Update to most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 05-31-23.dta"

* Change to incident_subject_force_type:
  - New level `"Intent to strike with a motor vehicle"`.

# njoaguof 1.14.0
* Update to most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 04-30-23.dta"

# njoaguof 1.13.0
* Update to most recent dataset from NJ OAG:
  "NJOAG Use of Force Data Dashboard 10-01-20 to 03-31-23.dta"

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
