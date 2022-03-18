## ---- include = FALSE-------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)


## ----setup, include=FALSE---------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(magrittr)
library(purrr)
library(stringr)
library(tidyr)
library(njoaguof)


## ---------------------------------------------------------------------------------------
#load("../../data/use_of_force_raw.rda")
data("use_of_force_raw")
uof_raw <- use_of_force_raw


## ---------------------------------------------------------------------------------------
trailing_comma_regex <- "(?<=.),?$"
sep_comma_no_space <- ",(?! )"
sep_comma_space_no_paren <- r"(,(?![^(]*\)) )"


## ---------------------------------------------------------------------------------------
subject <- uof_raw %>%
  select(form_id,
         SubjectsArrested,
         subject_type,
         SubjectsAge,
         SubjectRace,
         SubjectsGender) %>%
  mutate(across(
    where(is.character),
    ~ str_replace(., trailing_comma_regex, "")
  )) %>%
  filter(if_any(-form_id, ~ . != ""))
  
max_subjects <- 
  subject$SubjectsArrested %>% 
  map_int(str_count, ",") %>% 
  max() + 1


subject <- subject %>% 
  separate(SubjectsArrested, 
           paste0("arrested__", 1:max_subjects), 
           ",",
           fill="right") %>%
  separate(subject_type, 
           paste0("type__", 1:max_subjects), 
           ",",
           fill="right") %>%
  separate(SubjectsAge, 
           paste0("age__", 1:max_subjects), 
           ",",
           fill="right") %>%
  separate(SubjectRace, 
           paste0("race__", 1:max_subjects), 
           ",",
           fill="right") %>%
  separate(SubjectsGender, 
           paste0("gender__", 1:max_subjects), 
           ",",
           fill="right") %>%
  pivot_longer(cols = -form_id,
               names_to="column",
               values_to="value",
               values_drop_na=TRUE) %>%
  separate(column, c("column", "index"), "__") %>%
  pivot_wider(names_from="column", values_from="value") 



## ---------------------------------------------------------------------------------------
subject <- subject %>% 
  mutate(index=as.integer(index),
         arrested=as.logical(arrested)
  )



## ---------------------------------------------------------------------------------------
subject <- subject %>% 
  mutate(type=factor(type, levels=njoaguof:::subject_type_levels),
         gender=factor(gender, levels=njoaguof:::gender_levels))


## ---------------------------------------------------------------------------------------
as_integer_or_na <- function(x) suppressWarnings(as.integer(x))
subject <- subject %>% 
  mutate(juvenile=case_when(
    age=="Juvenile" ~ TRUE,
    !is.na(as_integer_or_na(age)) ~ FALSE
  )) %>%
  mutate(age=as_integer_or_na(age))


## ---------------------------------------------------------------------------------------
subject <- subject %>%
  mutate(
    race = case_when(
      race == "Black or African American" ~ "Black",
      race == "Am. Indian"                ~ "American Indian",
      TRUE                                ~ race
    ),
    race=factor(race, levels=njoaguof:::race_levels)
  )


## ---------------------------------------------------------------------------------------
subject <- subject %>% 
  select(form_id, index, arrested, type, age, juvenile, race, gender)



## ---------------------------------------------------------------------------------------
### table should have two columns: form_id and list_col
make_set_membership_table <- function(table, levels, separating_regex = ",") {
  table <- table %>%
    mutate(list_col = str_replace(list_col, trailing_comma_regex, "")) %>%
    filter(list_col != "")

  max_values <- table$list_col %>%
    map_int(str_count, separating_regex) %>%
    max() + 1

  table %>%
    separate(list_col,
             paste0("list_col__", 1:max_values),
             separating_regex,
             fill="right"
    ) %>%
    pivot_longer(cols=-form_id,
                 names_to="column",
                 values_to="value",
                 values_drop_na = TRUE) %>%
    mutate(value=factor(str_trim(value), levels=levels)) %>%
    filter(!is.na(value)) %>%
    select(form_id, value)
}


## ---------------------------------------------------------------------------------------
incident_weather <- uof_raw %>% 
  select(form_id, list_col=incident_weather) %>%
  make_set_membership_table(njoaguof:::weather_levels, 
                            sep_comma_space_no_paren) %>%
  rename(weather=value)


## ---------------------------------------------------------------------------------------
incident_video_type <- uof_raw %>% 
  select(form_id, list_col=video_type) %>%
  make_set_membership_table(njoaguof:::video_type_levels,
                            sep_comma_space_no_paren) %>%
  rename(video_type=value)


## ---------------------------------------------------------------------------------------
incident_lighting <- uof_raw %>% 
  select(form_id, list_col=incident_lighting) %>%
  make_set_membership_table(njoaguof:::lighting_levels,
                            sep_comma_space_no_paren) %>%
  rename(lighting=value)


## ---------------------------------------------------------------------------------------
incident_location_type <- uof_raw %>% 
  select(form_id, list_col=location_type) %>%
  make_set_membership_table(njoaguof:::location_type_levels, 
                            sep_comma_space_no_paren) %>%
  rename(location_type=value)


## ---------------------------------------------------------------------------------------
incident_type <- uof_raw %>%
  select(form_id, list_col=incident_type) %>%
  make_set_membership_table(njoaguof:::incident_type_levels,
                            sep_comma_space_no_paren) %>%
  rename(type=value)



## ---------------------------------------------------------------------------------------
incident_contact_origin <- uof_raw %>%
  select(form_id, list_col=contact_origin) %>%
  make_set_membership_table(njoaguof:::contact_origin_levels,
                            sep_comma_space_no_paren) %>%
  rename(contact_origin=value)


## ---------------------------------------------------------------------------------------
incident_planned_contact <- uof_raw %>%
  select(form_id, list_col=planned_contact) %>%
  make_set_membership_table(njoaguof:::planned_contact_levels,
                            sep_comma_space_no_paren) %>%
  rename(planned_contact=value)


## ---------------------------------------------------------------------------------------

incident_officer_injury_type <- uof_raw %>%
  select(form_id, list_col=OffInjuryType) %>%
  make_set_membership_table(njoaguof:::officer_injury_type_levels,
                            sep_comma_space_no_paren) %>%
  rename(officer_injury_type=value)


## ---------------------------------------------------------------------------------------
incident_officer_medical_treatment <- uof_raw %>%
  select(form_id, list_col=OFFMEDTREAT2) %>%
  make_set_membership_table(njoaguof:::officer_medical_treatment_levels,
                            sep_comma_space_no_paren) %>%
  rename(officer_medical_treatment=value)




## ---------------------------------------------------------------------------------------
make_messy_relationship_table <- function(table, levels, separating_regex) {
  table <- table %>%
    mutate(list_col = str_replace(list_col, trailing_comma_regex, "")) %>%
    filter(list_col != "")

  max_values <- table$list_col %>%
    map_int(str_count, separating_regex) %>%
    max() + 1

  table %>%
    separate(list_col,
             paste0("value__", 1:max_values),
             separating_regex,
             fill="right"
    ) %>%
    pivot_longer(cols = -form_id,
                 names_to="column",
                 values_to="value",
                 values_drop_na=TRUE) %>%
    separate(column, c("column", "index"), "__") %>%
    mutate(index=as.integer(index)) %>%
    pivot_wider(names_from="column", values_from="value") %>%
    mutate(value=factor(str_trim(value), levels=levels)) %>%
    filter(!is.na(value))
}


## ---------------------------------------------------------------------------------------
incident_subject_perceived_condition <- uof_raw %>%
  select(form_id, list_col=PerceivedCondition) %>%
  make_messy_relationship_table(njoaguof:::perceived_condition_levels,
                                sep_comma_no_space) %>%
  rename(perceived_condition=value)


## ---------------------------------------------------------------------------------------

incident_subject_action <- uof_raw %>% 
  select(form_id, list_col=SubActions) %>%
  make_messy_relationship_table(njoaguof:::subject_action_levels,
                                sep_comma_no_space) %>%
  rename(subject_action=value)


## ---------------------------------------------------------------------------------------
incident_subject_resistance <- uof_raw %>% 
  select(form_id, list_col=SubResist) %>%
  make_messy_relationship_table(njoaguof:::subject_resistance_levels,
                                sep_comma_no_space) %>%
  rename(subject_resistance=value)


## ---------------------------------------------------------------------------------------
incident_subject_medical_treatment <- uof_raw %>% 
  select(form_id, list_col=SubMedicalTreat) %>%
  make_messy_relationship_table(njoaguof:::subject_medical_treatment_levels,
                                sep_comma_no_space) %>%
  rename(subject_medical_treatment=value)


## ---------------------------------------------------------------------------------------
incident_subject_injury <- uof_raw %>% 
  select(form_id, list_col=SubjectInjuries) %>%
  make_messy_relationship_table(njoaguof:::subject_injury_levels,
                                sep_comma_no_space) %>%
  rename(subject_injury=value)


## ---------------------------------------------------------------------------------------
incident_subject_force_type <- uof_raw %>% 
  select(form_id, list_col=TypeofForce) %>%
  make_messy_relationship_table(njoaguof:::force_type_levels,
                                sep_comma_space_no_paren) %>%
  rename(force_type=value)


## ---------------------------------------------------------------------------------------
incident_subject_reason_not_arrested <- uof_raw %>%
  select(form_id, list_col="ReasonNotArrest") %>%
  make_messy_relationship_table(njoaguof:::reason_not_arrested_levels,
                                sep_comma_no_space) %>%
  rename(reason_not_arrested=value)


## ---------------------------------------------------------------------------------------
incident <- uof_raw %>%
  select(
    form_id,
    agency_county = County2,
    agency_name = agency_name3,
    officer_name = Officer_Name2,
    officer_name_id = officer_name,
    report_number,
    incident_case_number,
    incident_date_1 = IncidentDate1,
    incident_municipality,
    indoor_or_outdoor,
    video_footage,
    officer_age,
    officer_race,
    officer_rank,
    officer_gender = officer_gender_fill,
    officer_injured = officer_injuries_injured,
    subject_injured_count = TotalSubInjuredIncident
  )


## ---------------------------------------------------------------------------------------
stopifnot(
  0 ==
    uof_raw %>%
    filter(
      INCIDENTID !=
        glue::glue("{County2}-{agency_name3}-{incident_case_number}")
    ) %>%
    filter(
      INCIDENTID !=
        glue::glue("{County2}-{agency_name3}- {incident_case_number}")
    ) %>%
    filter(
      INCIDENTID !=
        glue::glue("{County2}-{agency_name3}-\t{incident_case_number}")
    ) %>%
    nrow(),
  0 ==
    uof_raw %>%
    filter(
      Officer_Name_Agency !=
        glue::glue("{agency_name3}-{Officer_Name2}")
    ) %>%
    filter(
      Officer_Name_Agency !=
        glue::glue("{agency_name3}-\t\t{Officer_Name2}")
    ) %>%
    nrow()
)


## ---------------------------------------------------------------------------------------
stopifnot(0 == 
            uof_raw %>% filter(IncidentDate1 != IncidentDate1_old) %>% nrow(),
          0 ==
            uof_raw %>% filter(Incident_date1 != IncidentDate1_old) %>% nrow()
)


## ---------------------------------------------------------------------------------------
stopifnot(0 == uof_raw %>% filter(!is.na(incident_date)) %>% nrow(),
          0 == uof_raw %>% filter(!is.na(other_officer_involved)) %>% nrow(),
          0 == uof_raw %>% filter(!is.na(officer_in_uniform)) %>% nrow())


## ---------------------------------------------------------------------------------------
stopifnot(0 == uof_raw %>% filter(incident_lighting2 != 1) %>% nrow())


## ---------------------------------------------------------------------------------------
stopifnot(
  0 == uof_raw %>%
    select(OffInjuryType, officer_injuries_injured) %>%
    mutate(NoInjury = str_detect(OffInjuryType, "No Injury")) %>%
    filter(NoInjury == (officer_injuries_injured == "1")) %>%
    nrow()
)


## ---------------------------------------------------------------------------------------
stopifnot(
  0 ==
    uof_raw %>% filter(TotalSubInjuredIncident != SubjectInjuredInIncident) %>%
    nrow(),
  0 ==
    uof_raw %>% filter(TotalSubInjuredIncident != SubjectInjuredPrior) %>%
    nrow()
)


## ---------------------------------------------------------------------------------------
stopifnot(
  all(uof_raw$KEEPDROP == "KEEP"),
  all(
    uof_raw$IncidentYear == lubridate::year(uof_raw$IncidentDate1)
  )
)


## ---------------------------------------------------------------------------------------
incident <- incident %>% 
  mutate(agency_county = factor(agency_county, njoaguof:::county_levels))




## ---------------------------------------------------------------------------------------
incident <- incident %>% 
  mutate(officer_name = na_if(officer_name, ""))

standard_names <- incident %>% 
  count(officer_name, officer_name_id) %>%
  group_by(officer_name_id) %>%
  slice(which.max(n)) %>%
  ungroup() %>%
  select(officer_name_id, officer_name)

officer_name_variants <- incident %>%
  select(officer_name_id, officer_name) %>%
  unique()

incident <- incident %>% 
  select(-officer_name) %>%
  left_join(standard_names, by="officer_name_id") 

rm(standard_names)


## ---------------------------------------------------------------------------------------
incident <- incident %>% 
  separate(
    incident_municipality,
    c("incident_municipality", "incident_municipality_county"),
    sep = ",",
    fill = "right"
  ) %>%
  mutate(incident_municipality_county =
           str_trim(incident_municipality_county)) %>%
  mutate(incident_municipality_county =
           str_remove(incident_municipality_county, " County"))


## ---------------------------------------------------------------------------------------
stopifnot(0 == setdiff(
  incident %>% pull(incident_municipality_county) %>% discard(is.na),
  njoaguof:::county_levels
) %>% length())


## ---------------------------------------------------------------------------------------
incident <- incident %>%
  mutate(
    incident_municipality_county =
      factor(incident_municipality_county, levels = njoaguof:::county_levels)
  )




## ---------------------------------------------------------------------------------------
incident <- incident %>%
  mutate(
    indoors = str_detect(indoor_or_outdoor, "Indoors"),
    outdoors = str_detect(indoor_or_outdoor, "Outdoors")
  ) %>%
  select(-indoor_or_outdoor)


## ---------------------------------------------------------------------------------------
video_footage_levels <- c("Yes", "No", "Unknown")
incident <- incident %>%
  mutate(video_footage=str_replace(video_footage, "Unknow", "Unknown")) %>%
  mutate(video_footage=factor(video_footage, levels=video_footage_levels))


## ---------------------------------------------------------------------------------------
incident <- incident %>%
  dplyr::mutate(officer_age = ifelse(dplyr::between(officer_age, 18, 67),
                                     as.integer(officer_age),
                                     NA)) 


## ---------------------------------------------------------------------------------------
incident <- incident %>%
  mutate(
    officer_race = case_when(
      officer_race == "Black or African American" ~ "Black",
      officer_race == "Am. Indian"                ~ "American Indian",
      TRUE                                        ~ officer_race
    ),
    officer_race = factor(officer_race, levels = njoaguof:::race_levels)
  )

incident <- incident %>% 
  mutate(officer_gender=factor(officer_gender, levels=njoaguof:::gender_levels))



## ---------------------------------------------------------------------------------------
incident <- incident %>% 
  mutate(officer_injured = (officer_injured=="1"))


## ---------------------------------------------------------------------------------------
incident <- incident %>%
  left_join(count(subject, form_id, name = "subject_count"),
            by = "form_id")


## ---------------------------------------------------------------------------------------
incident <- incident %>%
  relocate(
    form_id,
    report_number,
    incident_case_number,
    incident_date_1,
    agency_county,
    agency_name,
    incident_municipality,
    incident_municipality_county,
    officer_name_id,
    officer_name,
    officer_age,
    officer_race,
    officer_rank,
    officer_gender,
    officer_injured,
    video_footage,
    indoors,
    outdoors,
    subject_count,
    subject_injured_count
  )

