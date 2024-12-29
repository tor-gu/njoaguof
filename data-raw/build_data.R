## ----include = FALSE---------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)


## ----setup, include=FALSE----------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(magrittr)
library(purrr)
library(stringr)
library(tidyr)
library(readr)
library(njoaguof)


## ----------------------------------------------------------------------------------------
data("use_of_force_raw")
uof_raw <- use_of_force_raw


## ----------------------------------------------------------------------------------------
data("census_counties")
data("census_municipalities")


## ----------------------------------------------------------------------------------------
trailing_comma_regex <- "(?<=.),?$"
sep_comma_no_space <- ",(?! )"
sep_comma_space_no_paren <- r"( ?,(?![^(]*\)) )"
sep_comma_optional_space <- r"( ?, ?)"


## ----------------------------------------------------------------------------------------
raw_names <- c(
  "FormID"                         ,"County",
  "AgencyName"                     ,"OfficerName",
  "UserID"                         ,"IncidentID", 
  "ReportNumber"                   ,"IncidentCaseNumber",
  "IncidentDate"                   ,"OtherOfficerInvolved",
  "OfficerInUniform"               ,"IncidentMunicipality",
  "IndoorOrOutdoor"                ,"IncidentWeather",
  "VideoFootage"                   ,"VideoType",
  "IncidentLighting",
  "LocationType"                   ,"IncidentType",
  "ContactOrigin"                  ,"PlannedContact",
  "OfficerAge"                     ,"OfficerRaceEthnicity",
  "OfficerRank"                    ,"OfficerGender",
  "OfficerInjuryType"              ,"OfficerInjuriesInjured",
  "OfficerMedicalTreatment"        ,"OfficerHospitalTreatment",
  "TotalSubInjuredInIncident"      ,"SubjectInjuredInIncident",
  "SubjectInjuredPriorToIncident"  ,"PerceivedConditionOfSubject",
  "SubjectActions"                 ,"SubjectResistance",
  "SubjectMedicalTreatment"        ,"SubjectInjuryType",
  "SubjectArrested"                ,"ReasonSubjectNotArrested",
  "SubjectType"                    ,"SubjectAge",
  "SubjectRaceEthnicity"           ,"SubjectGender",
  "ForceType",
  "IncidentYear",
  "KEEPDROP"                       ,"staticContent976"
)
stopifnot(all.equal(names(uof_raw), raw_names))


## ----------------------------------------------------------------------------------------
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
    message(paste(unmatched_values, collapse = " | "))
    stop()
  }
}


## ----------------------------------------------------------------------------------------
subject_type_levels <-
  c("Person", "Animal", "Other", "Unknown Subject(s)")

gender_levels <-
  c("Male",
    "Female",
    #"Gender Non-Conforming/X",
    "Non-Binary/X",
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
  "Alcohol Establishment (bar, club, casino)",
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
  "Officer Dispatched",
  "Officer Initiated",
  "Pre-Planned Contact"
)

planned_contact_levels <- c(
  "Arrest",
  "Judicial Order Service (TRO, FRO, etc.)",
  "No Knock Warrant",
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
  "Attack with Hands fists legs",
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
  "Strike with open hand fist or elbow",
  "Threat to Kick",
  "Threat to Push or shove",
  "Threat to Strike with open hand fist or elbow",
  "Threat with Blunt object",
  "Threat with Bodily Fluids",
  "Threat with Edge Weapon",
  "Threat with Gun",
  "Threat with Hands fists legs",
  "Threat with Motor vehicle",
  "Threat with Other Weapon",
  "Verbal/Fighting stance Threat"
)

subject_resistance_levels <- c(
  "Active Assailant",
  "Active Resistor",
  "Aggressive resistance (attempt to attack or harm)",
  "Attempt to flee",
  "Dead-weight tactics(going limp)",
  "Dead-weight tactics (going limp)",
  "Non-response (consciously ignoring)",
  "Passive Resistor",
  "Resistive tension (stiffening tighening muscles)",
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
  "CS Gas",
  "Discharged Chemical at",
  "Discharged Firearm at",
  "High Volume OC Spray",
  "Intent to strike with a motor vehicle",
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
  "Insufficient Probable Cause- includes continuing investigation",
  "Medical/Mental Health Incident",
  "No Probable Cause- Crime Unfounded",
  "No Probable Cause- Subject Not Involved",  
  "Subject Fled",
  "Other"
)

county_levels <- census_counties %>% pull(county)


## ----------------------------------------------------------------------------------------
uof_raw_trimmed <- uof_raw %>%
  dplyr::mutate(across(
  where(is.character),
  ~ stringr::str_replace(., trailing_comma_regex, "")
))

check_list_levels(
  uof_raw_trimmed,
  SubjectType,
  #sep_comma_no_space,
  sep_comma_space_no_paren,
  subject_type_levels,
  c("", "Not Provided")
)
check_list_levels(
  uof_raw_trimmed,
  SubjectGender,
  #sep_comma_no_space,
  sep_comma_space_no_paren,
  gender_levels,
  c("", "Not Provided")
)
check_list_levels(
  uof_raw_trimmed,
  SubjectRaceEthnicity,
  #sep_comma_no_space,
  sep_comma_space_no_paren,
  race_levels,
  c("Am. Indian", "Black or African American", "", "Not Provided")
)
check_list_levels(
  uof_raw_trimmed,
  IncidentWeather,
  sep_comma_space_no_paren,
  weather_levels,
  c("N/A", "", "Not Provided")
)
check_list_levels(
  uof_raw_trimmed,
  VideoType,
  sep_comma_space_no_paren,
  video_type_levels,
  c("[]", "")
)
check_list_levels(
  uof_raw_trimmed,
  IncidentLighting,
  sep_comma_space_no_paren,
  lighting_levels
)
check_list_levels(
  uof_raw_trimmed,
  LocationType,
  sep_comma_space_no_paren,
  location_type_levels,
  ""
)

check_list_levels(
  uof_raw_trimmed,
  IncidentType,
  sep_comma_space_no_paren,
  incident_type_levels,
  c("", "Not Provided")
)
check_list_levels(
  uof_raw_trimmed,
  ContactOrigin,
  sep_comma_space_no_paren,
  contact_origin_levels,
  c("", "Not Provided")
)
check_list_levels(
  uof_raw_trimmed,
  PlannedContact,
  sep_comma_space_no_paren,
  planned_contact_levels,
  c("", "Other ")
)
check_list_levels(
  uof_raw_trimmed,
  OfficerInjuryType,
  sep_comma_space_no_paren,
  officer_injury_type_levels,
  c("No Injury", "Not Provided", "Not injured")
)
check_list_levels(
  uof_raw_trimmed,
  OfficerMedicalTreatment,
  sep_comma_space_no_paren,
  officer_medical_treatment_levels,
  c("Not Provided", "")
)
check_list_levels(
  uof_raw_trimmed,
  PerceivedConditionOfSubject,
  #sep_comma_no_space,
  sep_comma_space_no_paren,
  perceived_condition_levels,
  c("Not Provided", "")
)

# For subject_actions, internal commas are used
# inconsistently. We'll normalize this field by
# internal commas before splitting
uof_raw_trimmed <- uof_raw_trimmed |> 
  mutate(SubjectActions=str_replace_all(SubjectActions, "Hands, fists, legs", "Hands fists legs")) |>
  mutate(SubjectActions=str_replace_all(SubjectActions, "Hands,fists,legs", "Hands fists legs")) |>
  mutate(SubjectActions=str_replace_all(SubjectActions, "hand, fist, or elbow", "hand fist or elbow")) 
check_list_levels(
  uof_raw_trimmed,
  SubjectActions,
  sep_comma_optional_space,
  subject_action_levels,
  c("Not Provided", "")
)
# For subject_resistance, internal commas are used
# inconsistently. We'll normalize this field by
# internal commas before splitting
uof_raw_trimmed <- uof_raw_trimmed |> 
  mutate(SubjectResistance=str_replace_all(SubjectResistance, "stiffening, tighening", "stiffening tighening")) 
check_list_levels(
  uof_raw_trimmed,
  SubjectResistance,
  sep_comma_optional_space,
  subject_resistance_levels,
  c("", "Not Provided")
)

check_list_levels(
  uof_raw_trimmed,
  SubjectMedicalTreatment,
  sep_comma_optional_space,
  subject_medical_treatment_levels,
  ""
)
check_list_levels(
  uof_raw_trimmed,
  SubjectInjuryType,
  sep_comma_optional_space,
  subject_injury_levels,
  ""
)
# For ForceType, we have to use an ad-hoc separator expression,
# because of internal commas in two levels.
sep_comma_space_force_special <- r"(, (?!Back|Carotid))"
check_list_levels(
  uof_raw_trimmed,
  ForceType,
  sep_comma_space_force_special,
  force_type_levels,
  c("Not Provided", "")
)
# There are two values here that we want to normalize --
# The values "NoProbableCause-SubjectNotInvolved and 
# Insufficient Probable Cause-includes continuing investigation. We 
# will do that later, when we build the 
# incident_subject_reason_not_arrested table.
check_list_levels(
   uof_raw_trimmed,
   ReasonSubjectNotArrested,
   sep_comma_optional_space,
   reason_not_arrested_levels,
  c("Not Provided", "", "NoProbableCause-SubjectNotInvolved", "Insufficient Probable Cause-includes continuing investigation")
)



## ----------------------------------------------------------------------------------------
stopifnot(all(
  setdiff(uof_raw %>% dplyr::pull(County) %>% paste0(" County"),
        county_levels) %in%
    c("Other County", "NJSP County")
  )
)


## ----------------------------------------------------------------------------------------
subject <- uof_raw %>%
  select(FormID,
         SubjectArrested,
         SubjectType,
         SubjectAge,
         SubjectRaceEthnicity,
         SubjectGender,
         SubjectInjuredInIncident,
         SubjectInjuredPriorToIncident) %>%
  mutate(across(
    where(is.character),
    ~ str_replace(., trailing_comma_regex, "")
  )) %>%
  filter(if_any(-FormID, ~ . != ""))
  
max_subjects <- 
  subject$SubjectArrested %>% 
  map_int(str_count, ",") %>% 
  max() + 1


subject <- subject %>% 
  separate(SubjectArrested, 
           paste0("arrested__", 1:max_subjects), 
           ",",
           fill="right") %>%
  separate(SubjectType, 
           paste0("type__", 1:max_subjects), 
           ",",
           fill="right") %>%
  separate(SubjectAge, 
           paste0("age__", 1:max_subjects), 
           ",",
           fill="right") %>%
  separate(SubjectRaceEthnicity, 
           paste0("race__", 1:max_subjects), 
           ",",
           fill="right") %>%
  separate(SubjectGender, 
           paste0("gender__", 1:max_subjects), 
           ",",
           fill="right") %>%
  separate(SubjectInjuredInIncident, 
           paste0("injured__", 1:max_subjects),
           ",",
           fill="right") %>%
  separate(SubjectInjuredPriorToIncident, 
           paste0("injured_prior__", 1:max_subjects),
           ",",
           fill="right") %>%
  pivot_longer(cols = -FormID,
               names_to="column",
               values_to="value",
               values_drop_na=TRUE) %>%
  separate(column, c("column", "index"), "__") %>%
  pivot_wider(names_from="column", values_from="value") %>%
  rename(form_id=FormID)



## ----------------------------------------------------------------------------------------
subject <- subject %>% 
  mutate(index=as.integer(index),
         arrested=as.logical(arrested)
  )



## ----------------------------------------------------------------------------------------
subject <- subject %>% 
  mutate(type=factor(type, levels=subject_type_levels),
         gender=factor(gender, levels=gender_levels))


## ----------------------------------------------------------------------------------------
as_integer_or_na <- function(x) suppressWarnings(as.integer(x))
subject <- subject %>% 
  mutate(juvenile=case_when(
    age=="Juvenile" ~ TRUE,
    !is.na(as_integer_or_na(age)) ~ FALSE
  )) %>%
  mutate(age=as_integer_or_na(age))


## ----------------------------------------------------------------------------------------
subject <- subject %>%
  mutate(
    race = case_when(
      race == "Black or African American" ~ "Black",
      race == "Am. Indian"                ~ "American Indian",
      TRUE                                ~ race
    ),
    race=factor(race, levels=race_levels)
  )


## ----------------------------------------------------------------------------------------
subject <- subject %>% mutate(injured = str_trim(injured),
                   injured_prior = str_trim(injured_prior))
stopifnot(
  0 == 
    subject %>% 
    filter(!(injured %in% c("Yes", "No", "Unknown", "", NA))) %>% 
    nrow()
  ,
  0 == 
    subject %>%
    filter(!(injured_prior %in% c("Yes", "No", "Unknown", "", NA))) %>% 
    nrow()
) 
subject <- subject %>% mutate(
  injured = case_when(
    injured == "Yes" ~ TRUE,
    injured == "No" ~ FALSE,
    TRUE ~ NA
  ),
  injured_prior = case_when(
    injured_prior == "Yes" ~ TRUE,
    injured_prior == "No" ~ FALSE,
    TRUE ~ NA
  )
)


## ----------------------------------------------------------------------------------------
subject <- subject %>% 
  select(form_id, index, arrested, type, age, juvenile, race, gender, injured, injured_prior)




## ----------------------------------------------------------------------------------------
### table should have two columns: FormID and list_col
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
    pivot_longer(cols=-FormID,
                 names_to="column",
                 values_to="value",
                 values_drop_na = TRUE) %>%
    mutate(value=factor(str_trim(value), levels=levels)) %>%
    filter(!is.na(value)) %>%
    rename(form_id=FormID) %>%
    select(form_id, value)
}


## ----------------------------------------------------------------------------------------
incident_weather <- uof_raw %>% 
  select(FormID, list_col=IncidentWeather) %>%
  make_set_membership_table(weather_levels, 
                            sep_comma_space_no_paren) %>%
  rename(weather=value)


## ----------------------------------------------------------------------------------------
incident_video_type <- uof_raw %>% 
  select(FormID, list_col=VideoType) %>%
  make_set_membership_table(video_type_levels,
                            sep_comma_space_no_paren) %>%
  rename(video_type=value)


## ----------------------------------------------------------------------------------------
incident_lighting <- uof_raw %>% 
  select(FormID, list_col=IncidentLighting) %>%
  make_set_membership_table(lighting_levels,
                            sep_comma_space_no_paren) %>%
  rename(lighting=value)


## ----------------------------------------------------------------------------------------
incident_location_type <- uof_raw %>% 
  select(FormID, list_col=LocationType) %>%
  make_set_membership_table(location_type_levels, 
                            sep_comma_space_no_paren) %>%
  rename(location_type=value)


## ----------------------------------------------------------------------------------------
incident_type <- uof_raw %>%
  select(FormID, list_col=IncidentType) %>%
  make_set_membership_table(incident_type_levels,
                            sep_comma_space_no_paren) %>%
  rename(type=value)



## ----------------------------------------------------------------------------------------
incident_contact_origin <- uof_raw %>%
  select(FormID, list_col=ContactOrigin) %>%
  make_set_membership_table(contact_origin_levels,
                            sep_comma_space_no_paren) %>%
  rename(contact_origin=value)


## ----------------------------------------------------------------------------------------
incident_planned_contact <- uof_raw %>%
  select(FormID, list_col=PlannedContact) %>%
  make_set_membership_table(planned_contact_levels,
                            sep_comma_space_no_paren) %>%
  rename(planned_contact=value)


## ----------------------------------------------------------------------------------------

incident_officer_injury_type <- uof_raw %>%
  select(FormID, list_col=OfficerInjuryType) %>%
  make_set_membership_table(officer_injury_type_levels,
                            sep_comma_space_no_paren) %>%
  rename(officer_injury_type=value)


## ----------------------------------------------------------------------------------------
incident_officer_medical_treatment <- uof_raw %>%
  select(FormID, list_col=OfficerMedicalTreatment) %>%
  make_set_membership_table(officer_medical_treatment_levels,
                            sep_comma_space_no_paren) %>%
  rename(officer_medical_treatment=value)




## ----------------------------------------------------------------------------------------
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
    pivot_longer(cols = -FormID,
                 names_to="column",
                 values_to="value",
                 values_drop_na=TRUE) %>%
    separate(column, c("column", "index"), "__") %>%
    mutate(index=as.integer(index)) %>%
    pivot_wider(names_from="column", values_from="value") %>%
    mutate(value=factor(str_trim(value), levels=levels)) %>%
    rename(form_id=FormID) %>%
    filter(!is.na(value))
}


## ----------------------------------------------------------------------------------------
incident_subject_perceived_condition <- uof_raw %>%
  select(FormID, list_col=PerceivedConditionOfSubject) %>%
  make_messy_relationship_table(perceived_condition_levels,
                                sep_comma_space_no_paren) %>%
  rename(perceived_condition=value)


## ----------------------------------------------------------------------------------------

incident_subject_action <- uof_raw_trimmed %>% 
  select(FormID, list_col=SubjectActions) %>%
  make_messy_relationship_table(subject_action_levels,
                                sep_comma_optional_space) %>%
  rename(subject_action=value)


## ----------------------------------------------------------------------------------------
incident_subject_resistance <- uof_raw_trimmed %>% 
  select(FormID, list_col=SubjectResistance) %>%
  make_messy_relationship_table(subject_resistance_levels,
                                sep_comma_optional_space) %>%
  rename(subject_resistance=value)


## ----------------------------------------------------------------------------------------
incident_subject_medical_treatment <- uof_raw %>% 
  select(FormID, list_col=SubjectMedicalTreatment) %>%
  make_messy_relationship_table(subject_medical_treatment_levels,
                                sep_comma_optional_space) %>%
  rename(subject_medical_treatment=value)


## ----------------------------------------------------------------------------------------
incident_subject_injury <- uof_raw %>% 
  select(FormID, list_col=SubjectInjuryType) %>%
  make_messy_relationship_table(subject_injury_levels,
                                sep_comma_optional_space) %>%
  rename(subject_injury=value)


## ----------------------------------------------------------------------------------------
incident_subject_force_type <- uof_raw %>% 
  select(FormID, list_col=ForceType) %>%
  make_messy_relationship_table(force_type_levels,
                                sep_comma_space_no_paren) %>%
  rename(force_type=value)


## ----------------------------------------------------------------------------------------
incident_subject_reason_not_arrested <- uof_raw %>%
  mutate(ReasonSubjectNotArrested = str_replace_all(
    ReasonSubjectNotArrested,
    "NoProbableCause-SubjectNotInvolved",
    "No Probable Cause- Subject Not Involved"
  )) %>%
  mutate(ReasonSubjectNotArrested = str_replace_all(
    ReasonSubjectNotArrested,
    "Insufficient Probable Cause-includes continuing investigation",
    "Insufficient Probable Cause- includes continuing investigation"
  )) %>%
  select(FormID, list_col="ReasonSubjectNotArrested") %>%
  make_messy_relationship_table(reason_not_arrested_levels,
                                sep_comma_optional_space) %>%
  rename(reason_not_arrested=value)


## ----------------------------------------------------------------------------------------
incident <- uof_raw %>%
  select(
    form_id = FormID,
    agency_county = County,
    agency_name = AgencyName,
    officer_name = OfficerName,
    officer_name_id = UserID,
    report_number = ReportNumber,
    incident_case_number = IncidentCaseNumber,
    incident_date_1 = IncidentDate,
    incident_municipality = IncidentMunicipality,
    other_officer_involved = OtherOfficerInvolved,
    officer_in_uniform = OfficerInUniform,
    indoor_or_outdoor = IndoorOrOutdoor,
    video_footage = VideoFootage,
    officer_age = OfficerAge,
    officer_race = OfficerRaceEthnicity,
    officer_rank = OfficerRank,
    officer_gender = OfficerGender,
    officer_injured = OfficerInjuriesInjured,
    subject_injured_count = TotalSubInjuredInIncident
  )


## ----------------------------------------------------------------------------------------
stopifnot(
  0 ==
    uof_raw %>%
    filter(
      IncidentID !=
        str_to_upper(glue::glue("{County}-{AgencyName}-{IncidentCaseNumber}"))
    ) %>%
    filter(
      IncidentID !=
        str_to_upper(glue::glue("{County}-{AgencyName}- {IncidentCaseNumber}"))
    ) %>%
    filter(
      IncidentID !=
        str_to_upper(glue::glue("{County}-{AgencyName}-\t{IncidentCaseNumber}"))
    ) %>%
    filter(
      IncidentID !=
        str_to_upper(glue::glue("{County}-{AgencyName}-  {IncidentCaseNumber}"))
    ) %>%
    nrow()
)


## ----------------------------------------------------------------------------------------
stopifnot(
  8 == uof_raw %>%
    select(OfficerInjuryType, OfficerInjuriesInjured) %>%
    mutate(NoInjury = str_detect(OfficerInjuryType, "Not injured") |
           OfficerInjuryType == "") %>%
    filter(NoInjury == (OfficerInjuriesInjured == "True")) %>%
    nrow()
)


## ----------------------------------------------------------------------------------------
stopifnot(
  all(
    uof_raw$IncidentYear == lubridate::year(uof_raw$IncidentDate)
  )
)


## ----------------------------------------------------------------------------------------
incident <- incident %>% 
  mutate(agency_county=paste0(agency_county, " County")) %>%
  mutate(agency_county = factor(agency_county, county_levels))


## ----------------------------------------------------------------------------------------
incident <- incident %>%
  mutate(
    agency_name = case_when(
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
      agency_name == "Toms River Township" ~ "Toms River Twp PD",
      agency_name == "Hardyston Twp Police Dept" ~ "Hardyston Twp PD",
      agency_name == "Linden Police Department" ~ "Linden PD",
      TRUE ~ agency_name
    )
  )




## ----------------------------------------------------------------------------------------
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


## ----------------------------------------------------------------------------------------
incident <- incident %>%
  separate(
    incident_municipality,
    c("incident_municipality", "incident_municipality_county"),
    sep = ",",
    fill = "right"
  ) %>%
  mutate(incident_municipality_county =
           str_trim(incident_municipality_county))


## ----------------------------------------------------------------------------------------
unique_municipalities <- incident %>%
  select(incident_municipality_county, incident_municipality) %>%
  unique()


## ----------------------------------------------------------------------------------------
lookup_1 <- unique_municipalities %>%
  inner_join(census_municipalities,
             by=c("incident_municipality"="municipality_and_type",
                  "incident_municipality_county"="county")) %>%
  mutate(census_municipality=incident_municipality) %>%
  select(incident_municipality, incident_municipality_county, census_municipality)


## ----------------------------------------------------------------------------------------
lookup_2 <- unique_municipalities %>%
  anti_join(lookup_1,
            by=c("incident_municipality", "incident_municipality_county")) %>%
  inner_join(census_municipalities,
             by=c("incident_municipality"="municipality",
                  "incident_municipality_county"="county")) %>%
  mutate(census_municipality=municipality_and_type) %>%
  select(incident_municipality, incident_municipality_county, census_municipality)


## ----------------------------------------------------------------------------------------
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
        incident_municipality == "Spring Lake Boro" ~ "Spring Lake borough",
      incident_municipality_county == "Somerset County" &
        incident_municipality == "Peapack & Gladstone" ~ "Peapack and Gladstone borough"
    )
  )


## ----------------------------------------------------------------------------------------
lookup <- rbind(lookup_1, lookup_2, lookup_3)


## ----------------------------------------------------------------------------------------
stopifnot(0 ==
  lookup %>% count(incident_municipality, incident_municipality_county) %>%
    filter(n>1) %>% nrow()
)
stopifnot("Other" == 
            lookup %>% filter(is.na(census_municipality)) %>% pull(incident_municipality)
)


## ----------------------------------------------------------------------------------------
incident <- incident %>% 
  left_join(lookup, 
            by = c("incident_municipality", "incident_municipality_county")) %>% 
  mutate(incident_municipality=census_municipality) %>%
  select(-census_municipality) 


## ----------------------------------------------------------------------------------------
incident <- incident %>%
  mutate(incident_municipality_county =
         factor(incident_municipality_county, county_levels))


## ----------------------------------------------------------------------------------------
incident <- incident %>% mutate(
  other_officer_involved = as.logical(other_officer_involved),
  officer_in_uniform = as.logical(officer_in_uniform)
)




## ----------------------------------------------------------------------------------------
incident <- incident %>%
  mutate(
    indoors = str_detect(indoor_or_outdoor, "Indoors"),
    outdoors = str_detect(indoor_or_outdoor, "Outdoors")
  ) %>%
  select(-indoor_or_outdoor)


## ----------------------------------------------------------------------------------------
video_footage_levels <- c("Yes", "No", "Unknown")
incident <- incident %>%
  mutate(video_footage=str_replace(video_footage, "Unknow", "Unknown")) %>%
  mutate(video_footage=factor(video_footage, levels=video_footage_levels))


## ----------------------------------------------------------------------------------------
incident <- incident |> 
  mutate(officer_age = str_remove(officer_age, regex("\\s*years\\s*old", ignore_case=TRUE))) |>
  mutate(officer_age = str_remove_all(officer_age, "/|`")) |>
  mutate(officer_age = str_replace(officer_age, regex("twenty-nine", ignore_case=TRUE), "29")) |>
  mutate(officer_age = str_replace(officer_age, regex("twenty four", ignore_case=TRUE), "24"))

# After this cleanup, we expect only three exceptions
exceptions <- c("NA", "3.5", "NEWARK POLICE VEST")
stopifnot(
  exceptions == incident |> filter(!str_detect(officer_age, "^\\d+$")) |> pull(officer_age) |> unique()
)

# Convert to integer and remove implausible ages
incident <- incident |> 
  mutate(officer_age = parse_integer(officer_age, na=exceptions)) |>
  mutate(officer_age = ifelse(between(officer_age, 18, 67), officer_age, NA))


## ----------------------------------------------------------------------------------------
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



## ----------------------------------------------------------------------------------------
incident <- incident %>% 
  mutate(officer_injured = (officer_injured=="1"))


## ----------------------------------------------------------------------------------------
incident <- incident %>%
  left_join(count(subject, form_id, name = "subject_count"),
            by = "form_id")


## ----------------------------------------------------------------------------------------
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

