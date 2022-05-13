## ---- include = FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)


## ----setup, include=FALSE-------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(magrittr)
library(purrr)
library(stringr)
library(tidyr)
library(njoaguof)


## -------------------------------------------------------------------------
data("use_of_force_raw")
uof_raw <- use_of_force_raw


## -------------------------------------------------------------------------
data("census_counties")
data("census_municipalities")


## -------------------------------------------------------------------------
trailing_comma_regex <- "(?<=.),?$"
sep_comma_no_space <- ",(?! )"
sep_comma_space_no_paren <- r"(,(?![^(]*\)) )"


## -------------------------------------------------------------------------
raw_names <- c(
  "form_id"                          ,"County2",
  "agency_name3"                     ,"Officer_Name2",
  "officer_name"                     ,"Officer_Name_Agency",
  "INCIDENTID"                       ,"report_number",
  "incident_case_number"             ,"IncidentDate1",
  "incident_date"                    ,"IncidentDate1_old",
  "other_officer_involved"           ,"officer_in_uniform",
  "incident_municipality"            ,"indoor_or_outdoor",
  "incident_weather"                 ,"video_footage",
  "video_type"                       ,"incident_lighting",
  "location_type"                    ,"incident_type",
  "contact_origin"                   ,"planned_contact",
  "officer_age"                      ,"officer_race",
  "officer_rank"                     ,"officer_gender_fill",
  "OffInjuryType"                    ,"officer_injuries_injured",
  "OFFMEDTREAT2"                     ,"officer_hospital_treatment",
  "TotalSubInjuredIncident"          ,"SubjectInjuredInIncident",
  "SubjectInjuredPrior"              ,"PerceivedCondition",
  "SubActions"                       ,"SubResist",
  "SubMedicalTreat"                  ,"SubjectInjuries",
  "SubectsArrested"                  ,"ReasonNotArrest",
  "subject_type"                     ,"SubjectsAge",
  "SubjectRace"                      ,"SubjectsGender",
  "TypeofForce"                      ,"Incident_date1",
  "incident_lighting2"               ,"IncidentYear",
  "KEEPDROP"
)
stopifnot(all.equal(names(uof_raw), raw_names))


## -------------------------------------------------------------------------
check_list_levels <- function(tbl,
                              column,
                              separating_regex,
                              levels,
                              other_acceptable_values = character(0)) {
  message("Checking for unmatched values in ",
          rlang::as_label(rlang::enquo(column)))
  unmatched_values <- tbl %>%
    dplyr::pull({{column}}) %>%
    stringr::str_split(separating_regex) %>%
    unlist() %>% unique() %>%
    setdiff(levels) %>% setdiff(other_acceptable_values)
  if (length(unmatched_values) != 0) {
    message(paste(unmatched_values, collapse = " "))
    stop()
  }
}


## -------------------------------------------------------------------------
subject_type_levels <-
  c("Person", "Animal", "Other", "Unknown Subject(s)")

gender_levels <-
  c("Male",
    "Female",
    "Gender Non-Conforming/X",
    "Other")

incident_type_levels <- c(
  "Aggressive/Injured Animal",
  "Assault",
  "Assisting another officer",
  "Burglary",
  "Distribution of CDS",
  "Disturbance (drinking, fighting, disorderly)",
  "Domestic",
  "Eluding",
  "Medical Emergency",
  "MV Accident/Aid",
  "MV/Traffic Stop",
  "Pedestrian Stop",
  "Possession of CDS",
  "Potential Mental Health Incident",
  "Report of Gunfire",
  "Robbery",
  "Subject with a gun",
  "Subject with other weapon",
  "Suspicious person",
  "Terroristic Threats",
  "Theft/Shoplifting",
  "Trespassing",
  "Wanted Person",
  "Welfare Check",
  "Other"
)

race_levels <- c(
  "American Indian",
  "Asian",
  "Asian/Pacific Islander",
  "Black",
  "Hispanic",
  "Native Hawaiian or other Pacific Islander",
  "Pacific Islander",
  "Two or more races",
  "White",
  "Other"
)

weather_levels <- c("Clear", "Cloudy", "Fog", "Rain", "Snow/Sleet/Ice")

video_type_levels <- c(
  "Body Worn",
  "CED Camera",
  "Cell Phone",
  "Commercial Building",
  "Motor Vehicle",
  "Residential/Home",
  "Station House",
  "Other",
  "Unknown"
)

lighting_levels <- c("Artificial", "Darkness", "Dawn/Dusk", "Daylight")

location_type_levels <- c(
  "Alcohol Establishment(bar, club, casino)",
  "Business",
  "Court House",
  "Hospital",
  "Jail/Prison",
  "Police Station",
  "Residence",
  "Restaurant",
  "School",
  "Street",
  "Other"
)

contact_origin_levels <- c(
  "Citizen Initiated",
  "Dispatched",
  "Officer Initiated",
  "Pre-Planned Contact"
)

planned_contact_levels <- c(
  "Arrest",
  "Judicial Order Service (TRO, FRO, etc.)",
  "Prisoner Transfer",
  "Processing",
  "Search Warrant Execution",
  "Other"
)

officer_injury_type_levels <- c(
  "Abrasion/Laceration/Puncture",
  "Chest pains/shortness of breath",
  "Complaint of pain",
  "Concussion",
  "Contusion/bruise",
  "Fracture/dislocation",
  "Gunshot wound",
  "Other",
  "Unknown"
)

officer_medical_treatment_levels <- c(
  "EMS on scene",
  "Hospital",
  "Officer Administered First Aid",
  "Refused",
  "Urgent Care"
)

perceived_condition_levels <- c(
  "No unusual condition noted",
  "Other unusual condition noted",
  "Potential Mental Health Incident",
  "Under influence of alcohol/drugs/both"
)

subject_action_levels <- c(
  "Attack with Blunt object",
  "Attack with Bodily fluids",
  "Attack with Edge Weapon",
  "Attack with Hands, fists, legs",
  "Attack with Motor Vehicle",
  "Attack with Other Weapon",
  "Attempt to commit crime",
  "Attempt to destroy evidence",
  "Attempt to escape from Custody",
  "Attempt to self-harm",
  "Biting",
  "Failure to Disperse",
  "Fired Gun",
  "Kick",
  "Other Attack",
  "Other Threat",
  "Prevent harm to another",
  "Push or shove",
  "Resisted arrest/police officer control",
  "Spitting",
  "Strike with open hand, fist, or elbow",
  "Threat to Kick",
  "Threat to Push or shove",
  "Threat to Strike with open hand, fist, or elbow",
  "Threat with Blunt object",
  "Threat with Bodily Fluids",
  "Threat with Edge Weapon",
  "Threat with Gun",
  "Threat with Hands, fists, legs",
  "Threat with Motor vehicle",
  "Threat with Other Weapon",
  "Verbal/Fighting stance Threat"
)

subject_resistance_levels <- c(
  "Active Assailant",
  "Active Resistor",
  "Aggressive resistance(attempt to attack or harm)",
  "Attempt to flee",
  "Dead-weight tactics(going limp)",
  "Non-response (consciously ignoring)",
  "Passive Resistor",
  "Resistive tension(stiffening, tightening muscles)",
  "Threatening Assailant",
  "Verbal",
  "Other"
)

subject_medical_treatment_levels <- c(
  "EMS on scene",
  "Hospital",
  "Mental Health Facility",
  "Officer Administered First Aid",
  "Refused",
  "Urgent Care",
  "Unknown",
  "Not Provided"
)

subject_injury_levels <- c(
  "Abrasion/Laceration/Puncture",
  "Chest pains/shortness of breath",
  "Complaint of pain",
  "Concussion",
  "Contusion/bruise",
  "Fracture/dislocation",
  "Gunshot wound",
  "No Injury",
  "Other",
  "Unknown",
  "Not Provided"
)

force_type_levels <- c(
  "Canine bit (apprehension)",
  "Canine bit (spontaneous)",
  "CED Spark Display",
  "Chokehold, Carotid artery restraint",
  "Compliance hold with impact weapon- not a strike",
  "Discharged Chemical at",
  "Discharged Firearm at",
  "High Volume OC Spray",
  "Kneeling on Chest, Back",
  "Pointing Firearm",
  "Struck",
  "Used arm bar on",
  "Used arms",
  "Used arms/hands",
  "Used CED on",
  "Used fists/punch",
  "Used head",
  "Used legs/kicks",
  "Used Less-lethal device on",
  "Used pressure points on",
  "Used take down on",
  "Other"
)

reason_not_arrested_levels <- c(
  "Already in Custody",
  "Deceased",
  "Insufficient Probable Cause -includes continuing investigation",
  "Medical/Mental Health Incident",
  "No Probable Cause- Crime Unfounded",
  "Subject Fled",
  "Other"
)

county_levels <- census_counties %>% pull(county)


## -------------------------------------------------------------------------
uof_raw_trimmed <- uof_raw %>%
  dplyr::mutate(across(
  where(is.character),
  ~ stringr::str_replace(., trailing_comma_regex, "")
))

check_list_levels(
  uof_raw_trimmed,
  subject_type,
  sep_comma_no_space,
  subject_type_levels,
  ""
)
check_list_levels(
  uof_raw_trimmed,
  SubjectsGender,
  sep_comma_no_space,
  gender_levels,
  c("", "Not Provided")
)
check_list_levels(
  uof_raw_trimmed,
  SubjectRace,
  sep_comma_no_space,
  race_levels,
  c("Am. Indian", "Black or African American", "", "Not Provided")
)
check_list_levels(
  uof_raw_trimmed,
  incident_weather,
  sep_comma_space_no_paren,
  weather_levels,
  c("N/A", "")
)
check_list_levels(
  uof_raw_trimmed,
  video_type,
  sep_comma_space_no_paren,
  video_type_levels,
  c("[]", "")
)
check_list_levels(
  uof_raw_trimmed,
  incident_lighting,
  sep_comma_space_no_paren,
  lighting_levels
)
check_list_levels(
  uof_raw_trimmed,
  location_type,
  sep_comma_space_no_paren,
  location_type_levels,
  ""
)
check_list_levels(
  uof_raw_trimmed,
  incident_type,
  sep_comma_space_no_paren,
  incident_type_levels,
  ""
)
check_list_levels(
  uof_raw_trimmed,
  contact_origin,
  sep_comma_space_no_paren,
  contact_origin_levels,
  ""
)
check_list_levels(
  uof_raw_trimmed,
  planned_contact,
  sep_comma_space_no_paren,
  planned_contact_levels,
  c("", "Other ")
)
check_list_levels(
  uof_raw_trimmed,
  OffInjuryType,
  sep_comma_space_no_paren,
  officer_injury_type_levels,
  c("No Injury", "Not Provided")
)
check_list_levels(
  uof_raw_trimmed,
  OFFMEDTREAT2,
  sep_comma_space_no_paren,
  officer_medical_treatment_levels,
  c("Not Provided", "")
)
check_list_levels(
  uof_raw_trimmed,
  PerceivedCondition,
  sep_comma_no_space,
  perceived_condition_levels,
  c("Not Provided", "")
)
check_list_levels(
  uof_raw_trimmed,
  SubActions,
  sep_comma_no_space,
  subject_action_levels,
  ""
)
check_list_levels(
  uof_raw_trimmed,
  SubResist,
  sep_comma_no_space,
  subject_resistance_levels,
  ""
)
check_list_levels(
  uof_raw_trimmed,
  SubMedicalTreat,
  sep_comma_no_space,
  subject_medical_treatment_levels,
  ""
)
check_list_levels(
  uof_raw_trimmed,
  SubjectInjuries,
  sep_comma_no_space,
  subject_injury_levels,
  ""
)
# For TypeOfForce, we have to use an ad-hoc separator expression,
# because of internal commas in two levels.
sep_comma_space_force_special <- r"(, (?!Back|Carotid))"
check_list_levels(
  uof_raw_trimmed,
  TypeofForce,
  sep_comma_space_force_special,
  force_type_levels,
  ""
)
check_list_levels(
  uof_raw_trimmed,
  ReasonNotArrest,
  sep_comma_no_space,
  reason_not_arrested_levels,
  c("Not Provided", "")
)


## -------------------------------------------------------------------------
stopifnot(all(
  setdiff(uof_raw %>% dplyr::pull(County2) %>% paste0(" County"),
        county_levels) %in%
    c("Other County", "NJSP County")
  )
)


## -------------------------------------------------------------------------
subject <- uof_raw %>%
  select(form_id,
         SubectsArrested,
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
  subject$SubectsArrested %>% 
  map_int(str_count, ",") %>% 
  max() + 1


subject <- subject %>% 
  separate(SubectsArrested, 
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



## -------------------------------------------------------------------------
subject <- subject %>% 
  mutate(index=as.integer(index),
         arrested=as.logical(arrested)
  )



## -------------------------------------------------------------------------
subject <- subject %>% 
  mutate(type=factor(type, levels=subject_type_levels),
         gender=factor(gender, levels=gender_levels))


## -------------------------------------------------------------------------
as_integer_or_na <- function(x) suppressWarnings(as.integer(x))
subject <- subject %>% 
  mutate(juvenile=case_when(
    age=="Juvenile" ~ TRUE,
    !is.na(as_integer_or_na(age)) ~ FALSE
  )) %>%
  mutate(age=as_integer_or_na(age))


## -------------------------------------------------------------------------
subject <- subject %>%
  mutate(
    race = case_when(
      race == "Black or African American" ~ "Black",
      race == "Am. Indian"                ~ "American Indian",
      TRUE                                ~ race
    ),
    race=factor(race, levels=race_levels)
  )


## -------------------------------------------------------------------------
subject <- subject %>% 
  select(form_id, index, arrested, type, age, juvenile, race, gender)




## -------------------------------------------------------------------------
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


## -------------------------------------------------------------------------
incident_weather <- uof_raw %>% 
  select(form_id, list_col=incident_weather) %>%
  make_set_membership_table(weather_levels, 
                            sep_comma_space_no_paren) %>%
  rename(weather=value)


## -------------------------------------------------------------------------
incident_video_type <- uof_raw %>% 
  select(form_id, list_col=video_type) %>%
  make_set_membership_table(video_type_levels,
                            sep_comma_space_no_paren) %>%
  rename(video_type=value)


## -------------------------------------------------------------------------
incident_lighting <- uof_raw %>% 
  select(form_id, list_col=incident_lighting) %>%
  make_set_membership_table(lighting_levels,
                            sep_comma_space_no_paren) %>%
  rename(lighting=value)


## -------------------------------------------------------------------------
incident_location_type <- uof_raw %>% 
  select(form_id, list_col=location_type) %>%
  make_set_membership_table(location_type_levels, 
                            sep_comma_space_no_paren) %>%
  rename(location_type=value)


## -------------------------------------------------------------------------
incident_type <- uof_raw %>%
  select(form_id, list_col=incident_type) %>%
  make_set_membership_table(incident_type_levels,
                            sep_comma_space_no_paren) %>%
  rename(type=value)



## -------------------------------------------------------------------------
incident_contact_origin <- uof_raw %>%
  select(form_id, list_col=contact_origin) %>%
  make_set_membership_table(contact_origin_levels,
                            sep_comma_space_no_paren) %>%
  rename(contact_origin=value)


## -------------------------------------------------------------------------
incident_planned_contact <- uof_raw %>%
  select(form_id, list_col=planned_contact) %>%
  make_set_membership_table(planned_contact_levels,
                            sep_comma_space_no_paren) %>%
  rename(planned_contact=value)


## -------------------------------------------------------------------------

incident_officer_injury_type <- uof_raw %>%
  select(form_id, list_col=OffInjuryType) %>%
  make_set_membership_table(officer_injury_type_levels,
                            sep_comma_space_no_paren) %>%
  rename(officer_injury_type=value)


## -------------------------------------------------------------------------
incident_officer_medical_treatment <- uof_raw %>%
  select(form_id, list_col=OFFMEDTREAT2) %>%
  make_set_membership_table(officer_medical_treatment_levels,
                            sep_comma_space_no_paren) %>%
  rename(officer_medical_treatment=value)




## -------------------------------------------------------------------------
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


## -------------------------------------------------------------------------
incident_subject_perceived_condition <- uof_raw %>%
  select(form_id, list_col=PerceivedCondition) %>%
  make_messy_relationship_table(perceived_condition_levels,
                                sep_comma_no_space) %>%
  rename(perceived_condition=value)


## -------------------------------------------------------------------------

incident_subject_action <- uof_raw %>% 
  select(form_id, list_col=SubActions) %>%
  make_messy_relationship_table(subject_action_levels,
                                sep_comma_no_space) %>%
  rename(subject_action=value)


## -------------------------------------------------------------------------
incident_subject_resistance <- uof_raw %>% 
  select(form_id, list_col=SubResist) %>%
  make_messy_relationship_table(subject_resistance_levels,
                                sep_comma_no_space) %>%
  rename(subject_resistance=value)


## -------------------------------------------------------------------------
incident_subject_medical_treatment <- uof_raw %>% 
  select(form_id, list_col=SubMedicalTreat) %>%
  make_messy_relationship_table(subject_medical_treatment_levels,
                                sep_comma_no_space) %>%
  rename(subject_medical_treatment=value)


## -------------------------------------------------------------------------
incident_subject_injury <- uof_raw %>% 
  select(form_id, list_col=SubjectInjuries) %>%
  make_messy_relationship_table(subject_injury_levels,
                                sep_comma_no_space) %>%
  rename(subject_injury=value)


## -------------------------------------------------------------------------
incident_subject_force_type <- uof_raw %>% 
  select(form_id, list_col=TypeofForce) %>%
  make_messy_relationship_table(force_type_levels,
                                sep_comma_space_no_paren) %>%
  rename(force_type=value)


## -------------------------------------------------------------------------
incident_subject_reason_not_arrested <- uof_raw %>%
  select(form_id, list_col="ReasonNotArrest") %>%
  make_messy_relationship_table(reason_not_arrested_levels,
                                sep_comma_no_space) %>%
  rename(reason_not_arrested=value)


## -------------------------------------------------------------------------
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


## -------------------------------------------------------------------------
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


## -------------------------------------------------------------------------
stopifnot(0 == 
            uof_raw %>% filter(IncidentDate1 != IncidentDate1_old) %>% nrow(),
          0 ==
            uof_raw %>% filter(Incident_date1 != IncidentDate1_old) %>% nrow()
)


## -------------------------------------------------------------------------
stopifnot(0 == uof_raw %>% filter(!is.na(incident_date)) %>% nrow(),
          0 == uof_raw %>% filter(!is.na(other_officer_involved)) %>% nrow(),
          0 == uof_raw %>% filter(!is.na(officer_in_uniform)) %>% nrow())


## -------------------------------------------------------------------------
stopifnot(0 == uof_raw %>% filter(incident_lighting2 != 1) %>% nrow())


## -------------------------------------------------------------------------
stopifnot(
  0 == uof_raw %>%
    select(OffInjuryType, officer_injuries_injured) %>%
    mutate(NoInjury = str_detect(OffInjuryType, "No Injury")) %>%
    filter(NoInjury == (officer_injuries_injured == "1")) %>%
    nrow()
)


## -------------------------------------------------------------------------
stopifnot(
  0 ==
    uof_raw %>% filter(TotalSubInjuredIncident != SubjectInjuredInIncident) %>%
    nrow(),
  0 ==
    uof_raw %>% filter(TotalSubInjuredIncident != SubjectInjuredPrior) %>%
    nrow()
)


## -------------------------------------------------------------------------
stopifnot(
  all(uof_raw$KEEPDROP == "KEEP"),
  all(
    uof_raw$IncidentYear == lubridate::year(uof_raw$IncidentDate1)
  )
)


## -------------------------------------------------------------------------
incident <- incident %>% 
  mutate(agency_county=paste0(agency_county, " County")) %>%
  mutate(agency_county = factor(agency_county, county_levels))


## -------------------------------------------------------------------------
incident <- incident %>%
  mutate(
    agency_name = case_when(
      # TODO map park police name 
      agency_name == "Burlington County Sheriffs Office" ~ "Burlington Co Sheriffs Office",
      agency_name == "Mercer Co Prosecutor Off" ~ "Mercer Co Prosecutors Office",
      agency_name == "Hudson Co ProsecutorOff-S/Force" ~ "Hudson Co Prosecutors Office",
      agency_name == "Somerset Co Sheriffs Dept" ~ "Somerset Co Sheriffs Office",
      agency_name == "Middle Twsp PD" ~ "Middle Twp PD",
      agency_name == "State Police" ~ "New Jersey State Police",
      agency_name == "Rutgers Univ Police" ~ "Rutgers University PD",
      agency_name == "Division Of Fish And Wildlife" ~ "NJ Division Of Fish And Wildlife",
      agency_name == "NJ State Human Services Police" ~ "NJ Department Of Human Services",
      agency_name == "Division of Criminal Justice" ~ "NJ Division of Criminal Justice",
      agency_name == "Park Police" ~ "New Jersey State Park Police",
      TRUE ~ agency_name
    )
  )




## -------------------------------------------------------------------------
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


## -------------------------------------------------------------------------
incident <- incident %>%
  separate(
    incident_municipality,
    c("incident_municipality", "incident_municipality_county"),
    sep = ",",
    fill = "right"
  ) %>%
  mutate(incident_municipality_county =
           str_trim(incident_municipality_county))


## -------------------------------------------------------------------------
unique_municipalities <- incident %>%
  select(incident_municipality_county, incident_municipality) %>%
  unique()


## -------------------------------------------------------------------------
lookup_1 <- unique_municipalities %>%
  inner_join(census_municipalities,
             by=c("incident_municipality"="municipality_and_type",
                  "incident_municipality_county"="county")) %>%
  mutate(census_municipality=incident_municipality) %>%
  select(incident_municipality, incident_municipality_county, census_municipality)


## -------------------------------------------------------------------------
lookup_2 <- unique_municipalities %>%
  anti_join(lookup_1,
            by=c("incident_municipality", "incident_municipality_county")) %>%
  inner_join(census_municipalities,
             by=c("incident_municipality"="municipality",
                  "incident_municipality_county"="county")) %>%
  mutate(census_municipality=municipality_and_type) %>%
  select(incident_municipality, incident_municipality_county, census_municipality)


## -------------------------------------------------------------------------
lookup_3 <- unique_municipalities %>%
  anti_join(
    lookup_1,
    by = c("incident_municipality", "incident_municipality_county")
  ) %>%
  anti_join(
    lookup_2,
    by = c("incident_municipality", "incident_municipality_county")
  ) %>%
  mutate(
    census_municipality = case_when(
      # Name changes:  Dover, Ocean County -->           Toms River
      #                Washington, Mercer County -->     Robbinsville
      #                West Paterson, Essex County -->   Woodland Park
      #                South Belmar, Monmouth County --> Spring Lake
      incident_municipality_county == "Ocean County" &
        incident_municipality == "Dover" ~ "Toms River township",
      incident_municipality_county == "Mercer County" &
        incident_municipality == "Washington" ~ "Robbinsville township",
      incident_municipality_county == "Passaic County" &
        incident_municipality == "West Paterson" ~ "Woodland Park borough",
      incident_municipality_county == "Monmouth County" &
        incident_municipality == "South Belmar" ~ "Spring Lake borough",
      # "Princeton township" and "Princeton borough" merged to form just-plain
      # "Princeton" -- the only municipality in NJ without a type!
      incident_municipality_county == "Mercer County" &
        incident_municipality == "Princeton township" ~ "Princeton",
      # Cleanup miscellaneous idiosyncrasies.
      incident_municipality_county == "Essex County" &
        incident_municipality == "Village of South Orange" ~ "South Orange Village township",
      incident_municipality_county == "Essex County" &
        incident_municipality == "Caldwell Borough" ~ "Caldwell borough",
      incident_municipality_county == "Monmouth County" &
        incident_municipality == "Spring Lake Boro" ~ "Spring Lake borough"
    )
  )


## -------------------------------------------------------------------------
lookup <- rbind(lookup_1, lookup_2, lookup_3)


## -------------------------------------------------------------------------
stopifnot(0 ==
  lookup %>% count(incident_municipality, incident_municipality_county) %>%
    filter(n>1) %>% nrow()
)
stopifnot("Other" == 
            lookup %>% filter(is.na(census_municipality)) %>% pull(incident_municipality)
)


## -------------------------------------------------------------------------
incident <- incident %>% 
  left_join(lookup, 
            by = c("incident_municipality", "incident_municipality_county")) %>% 
  mutate(incident_municipality=census_municipality) %>%
  select(-census_municipality) 


## -------------------------------------------------------------------------
incident <- incident %>%
  mutate(incident_municipality_county =
         factor(incident_municipality_county, county_levels))




## -------------------------------------------------------------------------
incident <- incident %>%
  mutate(
    indoors = str_detect(indoor_or_outdoor, "Indoors"),
    outdoors = str_detect(indoor_or_outdoor, "Outdoors")
  ) %>%
  select(-indoor_or_outdoor)


## -------------------------------------------------------------------------
video_footage_levels <- c("Yes", "No", "Unknown")
incident <- incident %>%
  mutate(video_footage=str_replace(video_footage, "Unknow", "Unknown")) %>%
  mutate(video_footage=factor(video_footage, levels=video_footage_levels))


## -------------------------------------------------------------------------
incident <- incident %>%
  dplyr::mutate(officer_age = ifelse(dplyr::between(officer_age, 18, 67),
                                     as.integer(officer_age),
                                     NA)) 


## -------------------------------------------------------------------------
incident <- incident %>%
  mutate(
    officer_race = case_when(
      officer_race == "Black or African American" ~ "Black",
      officer_race == "Am. Indian"                ~ "American Indian",
      TRUE                                        ~ officer_race
    ),
    officer_race = factor(officer_race, levels = race_levels)
  )

incident <- incident %>% 
  mutate(officer_gender=factor(officer_gender, levels=gender_levels))



## -------------------------------------------------------------------------
incident <- incident %>% 
  mutate(officer_injured = (officer_injured=="1"))


## -------------------------------------------------------------------------
incident <- incident %>%
  left_join(count(subject, form_id, name = "subject_count"),
            by = "form_id")


## -------------------------------------------------------------------------
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

