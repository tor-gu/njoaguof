
<!-- README.md is generated from README.Rmd. Please edit that file -->

# njoaguof

<!-- badges: start -->
<!-- badges: end -->

This is cleaned-up version of the NJ OAG Use of Force database available
from <https://www.njoag.gov/force/>.

## Dataset Overview

-   `incident` This is the main data table. Each use of force incident
    is recorded here. A single incident may involve multiple subjects.
-   `subject` The subjects of the use of force – includes persons and
    animals.
-   `incident`-specific data tables. Each of these data tables are for
    multi-value fields associated to incidents. For example – a single
    incident may have both `"Rain"` and `"Fog"` weather conditions, and
    this will result in two rows in `incident_weather`.
    -   `incident_contact_origin`
    -   `incident_lighting`
    -   `incident_location_type`
    -   `incident_officer_injury_type`
    -   `incident_officer_medical_treatment`
    -   `incident_planned_contact`
    -   `incident_type`
    -   `incident_video_type`
    -   `incident_weather`
-   `incident`-`subject` data tables These data tables are for
    multi-value fields that should be associated to individual incident
    subjects. Unfortunately, these tables reflect some irreducible
    messiness of the source data. See the notes below.
    -   `incident_force_type`
    -   `incident_perceived_condition`
    -   `incident_subject_action`
    -   `incident_subject_injury`
    -   `incident_subject_medical_treatment`
    -   `incident_subject_resistance`
-   `officer_name_variants` Includes every variation in spelling and
    capitalization of the officer names found in the source data.
-   `use_of_force_raw` The source data.

## Examples

Every incident has a unique `form_id`, and this field is used to link
the `subject` and `incident_xxx` tables to specific incidents:

``` r
library(njoaguof)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
# Summarize video_type by agency_county
incident %>%
  select(form_id, agency_county) %>%
  right_join(incident_video_type, by = "form_id") %>%
  count(agency_county, video_type)
#> # A tibble: 178 × 3
#>    agency_county video_type              n
#>    <fct>         <fct>               <int>
#>  1 Atlantic      Body Worn             461
#>  2 Atlantic      CED Camera              5
#>  3 Atlantic      Cell Phone              3
#>  4 Atlantic      Commercial Building    24
#>  5 Atlantic      Motor Vehicle         127
#>  6 Atlantic      Residential/Home        2
#>  7 Atlantic      Station House          26
#>  8 Atlantic      Other                  31
#>  9 Bergen        Body Worn             461
#> 10 Bergen        CED Camera             35
#> # … with 168 more rows
```

``` r
library(njoaguof)
library(dplyr)
# Summarize subject gender by officer gender
incident %>% 
  select(form_id, officer_gender) %>% 
  right_join(subject, by="form_id") %>%
  count(officer_gender, subject_gender=gender)
#> # A tibble: 20 × 3
#>    officer_gender          subject_gender              n
#>    <fct>                   <fct>                   <int>
#>  1 Male                    Male                    14010
#>  2 Male                    Female                   3585
#>  3 Male                    Gender Non-Conforming/X    15
#>  4 Male                    Not Provided              175
#>  5 Female                  Male                      686
#>  6 Female                  Female                    399
#>  7 Female                  Gender Non-Conforming/X     2
#>  8 Female                  Not Provided                6
#>  9 Gender Non-Conforming/X Male                        9
#> 10 Gender Non-Conforming/X Female                      1
#> 11 Gender Non-Conforming/X Gender Non-Conforming/X     1
#> 12 Other                   Male                     1779
#> 13 Other                   Female                    450
#> 14 Other                   Gender Non-Conforming/X     3
#> 15 Other                   Not Provided               34
#> 16 Not Provided            Male                      184
#> 17 Not Provided            Female                     49
#> 18 Not Provided            Not Provided               40
#> 19 <NA>                    Male                       16
#> 20 <NA>                    Female                      7
```

## Notes

The raw data from the NJ OAG is available in table `use_of_force_raw`,
which has one row for each use of force incident. Fields with multiple
values are recorded as comma separated lists. For example:

``` r
use_of_force_raw %>% count(SubectsGender) %>% head(5)
#> # A tibble: 5 × 2
#>   SubectsGender                     n
#>   <chr>                         <int>
#> 1 ""                                1
#> 2 "Female,"                      4222
#> 3 "Female,Female"                  53
#> 4 "Female,Female,Female,"           3
#> 5 "Female,Female,Female,Female"     3
```

These fields are broken out into new data tables in the following
categories.

#### Subject Fields

Several fields contain one value for each subject. We presume that the
order is preserved, so that we may create one row for each subject in
the `subject` table.

``` r
use_of_force_raw %>% filter(form_id == 16301) %>%
  select(
    form_id,
    SubjectsArrested,
    subject_type,
    SubectsAge,
    SubjectRace,
    SubectsGender,
    SubectsGender
  )
#> # A tibble: 1 × 6
#>   form_id SubjectsArrested subject_type  SubectsAge SubjectRace    SubectsGender
#>     <dbl> <chr>            <chr>         <chr>      <chr>          <chr>        
#> 1   16301 True,False       Person,Person 26,23      Hispanic,Black Male,Female

subject %>% filter(form_id == 16301)
#> # A tibble: 2 × 8
#>   form_id index arrested type     age juvenile race     gender
#>     <dbl> <int> <lgl>    <fct>  <int> <lgl>    <fct>    <fct> 
#> 1   16301     1 TRUE     Person    26 FALSE    Hispanic Male  
#> 2   16301     2 FALSE    Person    23 FALSE    Black    Female
```

#### Multi-value incident ields

Some fields contain multiple values for #### Multi-value
Incident-Subject Fields

The cleaned data is available in the following tables:

-   `incident` There is one row in this table for each incident.
-   `subject` There is one row in this table for each subject.

## Installation

You can install the development version of njoaguof from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tor-gu/njoaguof")
```
