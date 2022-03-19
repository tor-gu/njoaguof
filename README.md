
<!-- README.md is generated from README.Rmd. Please edit that file -->

# njoaguof

<!-- badges: start -->

[![R-CMD-check](https://github.com/tor-gu/njoaguof/workflows/R-CMD-check/badge.svg)](https://github.com/tor-gu/njoaguof/actions)
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
    -   `incident_subject_action`
    -   `incident_subject_force_type`
    -   `incident_subject_injury`
    -   `incident_subject_medical_treatment`
    -   `incident_subject_perceived_condition`
    -   `incident_subject_reason_not_arrested`
    -   `incident_subject_resistance`
-   `officer_name_variants` Includes every variation in spelling and
    capitalization of the officer names found in the source data.
-   `use_of_force_raw` The source data.

## Examples

Every incident has a unique `form_id`, and this field is used to link
the `subject` `incident_xxx` and `incident_subject_xxx` tables to
specific incidents:

``` r
library(njoaguof)
library(dplyr)
# Summarize video_type by agency_county
incident %>%
  select(form_id, agency_county) %>%
  right_join(incident_video_type, by = "form_id") %>%
  count(agency_county, video_type)
#> # A tibble: 180 × 3
#>    agency_county video_type              n
#>    <fct>         <fct>               <int>
#>  1 Atlantic      Body Worn             479
#>  2 Atlantic      CED Camera              5
#>  3 Atlantic      Cell Phone              3
#>  4 Atlantic      Commercial Building    24
#>  5 Atlantic      Motor Vehicle         132
#>  6 Atlantic      Residential/Home        2
#>  7 Atlantic      Station House          28
#>  8 Atlantic      Other                  31
#>  9 Bergen        Body Worn             480
#> 10 Bergen        CED Camera             36
#> # … with 170 more rows
```

``` r
library(njoaguof)
library(dplyr)
# Summarize subject gender by officer gender
incident %>% 
  select(form_id, officer_gender) %>% 
  right_join(subject, by="form_id") %>%
  count(officer_gender, subject_gender=gender)
#> # A tibble: 18 × 3
#>    officer_gender          subject_gender              n
#>    <fct>                   <fct>                   <int>
#>  1 Male                    Male                    14610
#>  2 Male                    Female                   3737
#>  3 Male                    Gender Non-Conforming/X    15
#>  4 Male                    <NA>                      175
#>  5 Female                  Male                      715
#>  6 Female                  Female                    412
#>  7 Female                  Gender Non-Conforming/X     2
#>  8 Female                  <NA>                        6
#>  9 Gender Non-Conforming/X Male                        9
#> 10 Gender Non-Conforming/X Female                      1
#> 11 Gender Non-Conforming/X Gender Non-Conforming/X     1
#> 12 Other                   Male                     1845
#> 13 Other                   Female                    461
#> 14 Other                   Gender Non-Conforming/X     2
#> 15 Other                   <NA>                       34
#> 16 <NA>                    Male                      221
#> 17 <NA>                    Female                     63
#> 18 <NA>                    <NA>                       40
```

## Notes

The raw data from the NJ OAG is available in table `use_of_force_raw`,
which has one row for each use of force incident. Fields with multiple
values are recorded as comma separated lists. For example:

``` r
use_of_force_raw %>% count(SubjectsGender) %>% head(5)
#> # A tibble: 5 × 2
#>   SubjectsGender                    n
#>   <chr>                         <int>
#> 1 ""                                1
#> 2 "Female,"                      4402
#> 3 "Female,Female"                  54
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
    SubjectsAge,
    SubjectRace,
    SubjectsGender,
    SubjectsGender
  )
#> # A tibble: 1 × 6
#>   form_id SubjectsArrested subject_type  SubjectsAge SubjectRace  SubjectsGender
#>     <dbl> <chr>            <chr>         <chr>       <chr>        <chr>         
#> 1   16301 True,False       Person,Person 26,23       Hispanic,Bl… Male,Female

subject %>% filter(form_id == 16301)
#> # A tibble: 2 × 8
#>   form_id index arrested type     age juvenile race     gender
#>     <dbl> <int> <lgl>    <fct>  <int> <lgl>    <fct>    <fct> 
#> 1   16301     1 TRUE     Person    26 FALSE    Hispanic Male  
#> 2   16301     2 FALSE    Person    23 FALSE    Black    Female
```

#### Multi-value incident fields

Some fields contain multiple values which apply to the entire incident.
For each such column, we create a separate table expressing this
many-to-one relationship. For example, this row in the source data has
three values for `incident_type`, and this results in three rows in the
`incident_type` table.

``` r
library(tidyverse)
use_of_force_raw %>% filter(form_id == 16301) %>%
  select(incident_type)
#> # A tibble: 1 × 1
#>   incident_type                                                                 
#>   <chr>                                                                         
#> 1 Potential Mental Health Incident, Suspicious person, Disturbance (drinking, f…
incident_type %>% filter(form_id == 16301)
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
use_of_force_raw %>% 
  filter(form_id == 19542) %>% 
  select(subject_type,SubResist)
#> # A tibble: 1 × 2
#>   subject_type  SubResist                                                      
#>   <chr>         <chr>                                                          
#> 1 Person,Person Verbal,Aggressive resistance(attempt to attack or harm),Verbal,
incident_subject_resistance %>% filter(form_id == 19542)
#> # A tibble: 3 × 3
#>   form_id index subject_resistance                              
#>     <dbl> <int> <fct>                                           
#> 1   19542     1 Verbal                                          
#> 2   19542     2 Aggressive resistance(attempt to attack or harm)
#> 3   19542     3 Verbal
```

Note that it is not clear in the source data if “Aggressive resistance”
should be associated to the first subject or to the second subject.

All of the `incident_subject_xxx` data tables are of this form, with an
`index` column included so the order information is not lost.

#### Officer name variants

In the raw data, there are two fields which identify the officer:
`officer_name` (an ID field) and `Officer_Name2` (a name field). A
single `officer_name` ID can be associated different spellings in the
`Officer_Name2` field. When building the `incident` table, we ensure
that every `officer_name_id` is associated with a single spelling of the
officer name by choosing the most common form.

But all variants of the officer names appearing in the source data are
preserved in the `officer_name_variants` table.

## Installation

You can install the latest version of njoaguof from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tor-gu/njoaguof")
```
