
<!-- README.md is generated from README.Rmd. Please edit that file -->

# njoaguof

<!-- badges: start -->

[![R-CMD-check](https://github.com/tor-gu/njoaguof/workflows/R-CMD-check/badge.svg)](https://github.com/tor-gu/njoaguof/actions)
<!-- badges: end -->

This is a cleaned-up version of the NJ OAG Use of Force database
available from <https://www.njoag.gov/force/>.

## Dataset Overview

- `incident` This is the main data table. Each use of force incident is
  recorded here. A single incident may involve multiple subjects.
- `subject` The subjects of the use of force – includes persons and
  animals.
- `incident`-specific data tables. Each of these data tables are for
  multi-value fields associated to incidents. For example – a single
  incident may have both `"Rain"` and `"Fog"` weather conditions, and
  this will result in two rows in `incident_weather`.
  - `incident_contact_origin`
  - `incident_lighting`
  - `incident_location_type`
  - `incident_officer_injury_type`
  - `incident_officer_medical_treatment`
  - `incident_planned_contact`
  - `incident_type`
  - `incident_video_type`
  - `incident_weather`
- `incident`-`subject` data tables These data tables are for multi-value
  fields that should be associated to individual incident subjects.
  Unfortunately, these tables reflect some irreducible messiness of the
  source data. See the notes below.
  - `incident_subject_action`
  - `incident_subject_force_type`
  - `incident_subject_injury`
  - `incident_subject_medical_treatment`
  - `incident_subject_perceived_condition`
  - `incident_subject_reason_not_arrested`
  - `incident_subject_resistance`
- `officer_name_variants` Includes every variation in spelling and
  capitalization of the officer names found in the source data.
- `use_of_force_raw` The source data.

Each incident’s agency also carries an `agency_id` from
[njlea](https://github.com/tor-gu/njlea), a registry of NJ law
enforcement agencies shared with other NJ OAG data packages. njoaguof
re-exports njlea’s `get_agencies()`, `get_agency_municipalities()` and
`find_agency()`.

## Examples

Every incident has a unique `form_id`, and this field is used to link
the `subject` `incident_xxx` and `incident_subject_xxx` tables to
specific incidents:

``` r
library(njoaguof)
library(dplyr)
# Summarize video_type by agency_county
incident |>
  select(form_id, agency_county) |>
  right_join(incident_video_type, by = "form_id") |>
  count(agency_county, video_type)
#> # A tibble: 191 × 3
#>    agency_county   video_type              n
#>    <fct>           <fct>               <int>
#>  1 Atlantic County Body Worn            3978
#>  2 Atlantic County CED Camera             26
#>  3 Atlantic County Cell Phone             15
#>  4 Atlantic County Commercial Building   189
#>  5 Atlantic County Motor Vehicle         454
#>  6 Atlantic County Residential/Home       19
#>  7 Atlantic County Station House         175
#>  8 Atlantic County Other                  31
#>  9 Atlantic County Unknown                 7
#> 10 Bergen County   Body Worn            4848
#> # ℹ 181 more rows
```

``` r
library(njoaguof)
library(dplyr)
# Summarize subject gender by officer gender
incident |> 
  select(form_id, officer_gender) |> 
  right_join(subject, by="form_id") |>
  count(officer_gender, subject_gender=gender)
#> # A tibble: 16 × 3
#>    officer_gender subject_gender     n
#>    <fct>          <fct>          <int>
#>  1 Male           Male           27498
#>  2 Male           Female          7164
#>  3 Male           Non-Binary/X      41
#>  4 Male           <NA>             978
#>  5 Female         Male            1543
#>  6 Female         Female           961
#>  7 Female         Non-Binary/X       4
#>  8 Female         <NA>              86
#>  9 Other          Male           57611
#> 10 Other          Female         16216
#> 11 Other          Non-Binary/X      60
#> 12 Other          <NA>            1698
#> 13 <NA>           Male              35
#> 14 <NA>           Female            11
#> 15 <NA>           Non-Binary/X       4
#> 16 <NA>           <NA>               8
```

`agency_id` joins incidents to the njlea registry and to other datasets
that use it. Agencies can be renamed or disbanded, so look them up for
the year of each incident. `get_agencies()` with no year gives only
current agencies, which would miss incidents from agencies that no
longer exist.

``` r
library(njoaguof)
library(dplyr)
# Incidents by agency level and function
years <- 2020:2026
agencies <- lapply(years, \(y) mutate(get_agencies(y), year = y)) |>
  bind_rows()
incident |>
  mutate(year = as.integer(format(incident_date_1, "%Y"))) |>
  left_join(agencies, by = c("agency_id", "year")) |>
  count(agency_level, agency_function, sort = TRUE)
#> # A tibble: 15 × 3
#>    agency_level agency_function           n
#>    <fct>        <fct>                 <int>
#>  1 Municipal    Police                92686
#>  2 State        Police                 4844
#>  3 State        Authority or transit   4040
#>  4 County       Sheriff                3492
#>  5 County       Police                 3485
#>  6 State        College or university  1026
#>  7 Bi-state     Authority or transit    762
#>  8 County       Prosecutor              727
#>  9 State        Corrections             408
#> 10 County       Corrections             120
#> 11 Private      College or university    92
#> 12 State        Park and conservation    60
#> 13 County       Authority or transit     13
#> 14 State        Investigative             6
#> 15 County       College or university     5
```

## Notes

The raw data from the NJ OAG is available in table `use_of_force_raw`,
which has one row for each use of force incident. Fields with multiple
values are recorded as comma separated lists. For example:

``` r
use_of_force_raw |> count(SubjectGender) |> head(5)
#> # A tibble: 5 × 2
#>   SubjectGender                              n
#>   <chr>                                  <int>
#> 1 Female                                 23821
#> 2 Female, Female                           151
#> 3 Female, Female, Female                    16
#> 4 Female, Female, Female, Female             5
#> 5 Female, Female, Female, Female, Female     1
```

These fields are broken out into new data tables in the following
categories.

#### Subject Fields

Several fields contain one value for each subject. We presume that the
order is preserved, so that we may create one row for each subject in
the `subject` table.

``` r
use_of_force_raw |> filter(FormID == 16301) |>
  select(
    FormID,
    SubjectArrested,
    SubjectType,
    SubjectAge,
    SubjectRaceEthnicity,
    SubjectGender
  )
#> # A tibble: 1 × 6
#>   FormID SubjectArrested SubjectType    SubjectAge SubjectRaceEthnicity         
#>    <dbl> <chr>           <chr>          <chr>      <chr>                        
#> 1  16301 false, true     Person, Person 23, 26     Black or African American, H…
#> # ℹ 1 more variable: SubjectGender <chr>

subject |> filter(form_id == 16301)
#> # A tibble: 2 × 10
#>   form_id index arrested type    age juvenile race  gender injured injured_prior
#>     <dbl> <int> <lgl>    <fct> <int> <lgl>    <fct> <fct>  <lgl>   <lgl>        
#> 1   16301     1 FALSE    Pers…    23 FALSE    Black Female FALSE   FALSE        
#> 2   16301     2 NA       <NA>     26 FALSE    <NA>  <NA>   TRUE    FALSE
```

#### Multi-value incident fields

Some fields contain multiple values which apply to the entire incident.
For each such column, we create a separate table expressing this
many-to-one relationship. For example, this row in the source data has
three values for `incident_type`, and this results in three rows in the
`incident_type` table.

``` r
library(dplyr)
use_of_force_raw |> filter(FormID == 16301) |>
  select(IncidentType)
#> # A tibble: 1 × 1
#>   IncidentType                                                                  
#>   <chr>                                                                         
#> 1 Potential Mental Health Incident, Suspicious person, Disturbance (drinking, f…
incident_type |> filter(form_id == 16301)
#> # A tibble: 3 × 2
#>   form_id type                                        
#>     <dbl> <fct>                                       
#> 1   16301 Potential Mental Health Incident            
#> 2   16301 Suspicious person                           
#> 3   16301 Disturbance (drinking, fighting, disorderly)
```

#### Multi-value Incident-Subject Fields

Some fields contain multiple values which apply to individual subjects,
but there is no reliable way to assign the values to subjects. For
example, in this row of the raw data, there are two subjects and three
values in the `SubResist` field. In this case, we create three rows in
the `incident_subject_resistance` table, indicating the position of each
item in the list with the `index` value.

``` r
use_of_force_raw |> 
  filter(FormID == 19542) |> 
  select(SubjectType,SubjectResistance)
#> # A tibble: 1 × 2
#>   SubjectType    SubjectResistance                                              
#>   <chr>          <chr>                                                          
#> 1 Person, Person Verbal, Verbal, Aggressive resistance (attempt to attack or ha…
incident_subject_resistance |> filter(form_id == 19542)
#> # A tibble: 3 × 3
#>   form_id index subject_resistance                               
#>     <dbl> <int> <fct>                                            
#> 1   19542     1 Verbal                                           
#> 2   19542     2 Verbal                                           
#> 3   19542     3 Aggressive resistance (attempt to attack or harm)
```

Note that it is not clear in the source data if “Aggressive resistance”
should be associated to the first subject or to the second subject.

All of the `incident_subject_xxx` data tables are of this form, with an
`index` column included so the order information is not lost.

#### Officer name variants

In the raw data, there are two fields which identify the officer:
`UserID` (an ID field) and `OfficerName` (a name field). A single
`UserID` can be associated different spellings in the `OfficerName`
field. When building the `incident` table, we ensure that every
`officer_name_id` is associated with a single spelling of the officer
name by choosing the most common form.

But all variants of the officer names appearing in the source data are
preserved in the `officer_name_variants` table.

## Installation

You can install the latest version of njoaguof from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tor-gu/njoaguof")
```
