## ---- include = FALSE---------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)


## ----setup, include=FALSE-----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(magrittr)
library(purrr)
library(stringr)
library(tidyr)
library(njoaguof)


## -----------------------------------------------------------------------------------
#load("../../data/use_of_force_raw.rda")
data("use_of_force_raw")
uof_raw <- use_of_force_raw


## -----------------------------------------------------------------------------------
trailing_comma_regex <- "(?<=.),?$"
separating_comma_regex <- ",(?! )"


## -----------------------------------------------------------------------------------
subject <- uof_raw %>%
  select(form_id,
         SubjectsArrested,
         subject_type,
         SubectsAge,
         SubjectRace,
         SubectsGender) %>%
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
  separate(SubectsAge, 
           paste0("age__", 1:max_subjects), 
           ",",
           fill="right") %>%
  separate(SubjectRace, 
           paste0("race__", 1:max_subjects), 
           ",",
           fill="right") %>%
  separate(SubectsGender, 
           paste0("gender__", 1:max_subjects), 
           ",",
           fill="right") %>%
  pivot_longer(cols = -form_id,
               names_to="column",
               values_to="value",
               values_drop_na=TRUE) %>%
  separate(column, c("column", "index"), "__") %>%
  pivot_wider(names_from="column", values_from="value") 



## -----------------------------------------------------------------------------------
subject <- subject %>% 
  mutate(index=as.integer(index),
         arrested=as.logical(arrested)
  )



## -----------------------------------------------------------------------------------
subject_type_levels <-
  c("Person", "Animal", "Other", "Unknown Subject(s)")
gender_levels <-
  c("Male",
    "Female",
    "Gender Non-Conforming/X",
    "Other",
    "Not Provided")

subject <- subject %>% 
  mutate(type=factor(type, levels=subject_type_levels),
         gender=factor(gender, levels=gender_levels))


## -----------------------------------------------------------------------------------
as_integer_or_na <- function(x) suppressWarnings(as.integer(x))
subject <- subject %>% 
  mutate(juvenile=case_when(
    age=="Juvenile" ~ TRUE,
    !is.na(as_integer_or_na(age)) ~ FALSE
  )) %>%
  mutate(age=as_integer_or_na(age))


## -----------------------------------------------------------------------------------
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
  "Other",
  "Not Provided"
)
subject <- subject %>%
  mutate(
    race = case_when(
      race == "Black or African American" ~ "Black",
      race == "Am. Indian"                ~ "American Indian",
      TRUE                                ~ race
    ),
    race=factor(race, levels=race_levels)
  )


## -----------------------------------------------------------------------------------
subject <- subject %>% 
  select(form_id, index, arrested, type, age, juvenile, race, gender)



## -----------------------------------------------------------------------------------
### table should have two columns: form_id and list_col
make_set_membership_table <- function(table, levels) {
  table <- table %>%
    mutate(list_col = str_replace(list_col, trailing_comma_regex, "")) %>%
    filter(list_col != "")

  max_values <- table$list_col %>%
    map_int(str_count, ",") %>%
    max() + 1

  table %>%
    separate(list_col,
             paste0("list_col__", 1:max_values),
             ",",
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


## -----------------------------------------------------------------------------------
weather_levels <- c("Clear", "Cloudy", "Fog", "Rain", "Snow/Sleet/Ice")
incident_weather <- uof_raw %>% 
  select(form_id, list_col=incident_weather) %>%
  make_set_membership_table(weather_levels) %>%
  rename(weather=value)


## -----------------------------------------------------------------------------------
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
incident_video_type <- uof_raw %>% 
  select(form_id, list_col=video_type) %>%
  make_set_membership_table(video_type_levels) %>%
  rename(video_type=value)


## -----------------------------------------------------------------------------------
lighting_levels <- c("Artificial", "Darkness", "Dawn/Dusk", "Daylight")

incident_lighting <- uof_raw %>% 
  select(form_id, list_col=incident_lighting) %>%
  make_set_membership_table(lighting_levels) %>%
  rename(lighting=value)


## -----------------------------------------------------------------------------------
location_type_levels <- c(
  "Alcohol Establishment",
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

incident_location_type <- uof_raw %>% 
  select(form_id, list_col=location_type) %>%
  make_set_membership_table(location_type_levels) %>%
  rename(location_type=value)


## -----------------------------------------------------------------------------------
incident_type_levels <- c(
  "Aggressive/Injured Animal",
  "Assault",
  "Assisting another officer",
  "Burglary",
  "Distribution of CDS",
  "Disturbance",
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

incident_type <- uof_raw %>%
  select(form_id, list_col=incident_type) %>%
  make_set_membership_table(incident_type_levels) %>%
  rename(type=value)



## -----------------------------------------------------------------------------------
contact_origin_levels <- c(
  "Citizen Initiated",
  "Dispatched",
  "Officer Initiated",
  "Pre-Planned Contact"
)

incident_contact_origin <- uof_raw %>%
  select(form_id, list_col=contact_origin) %>%
  make_set_membership_table(contact_origin_levels) %>%
  rename(contact_origin=value)


## -----------------------------------------------------------------------------------
planned_contact_levels <- c(
  "Arrest",
  "Judicial Order Service",
  "Prisoner Transfer",
  "Processing",
  "Search Warrant Execution"
)

incident_planned_contact <- uof_raw %>%
  select(form_id, list_col=planned_contact) %>%
  make_set_membership_table(planned_contact_levels) %>%
  rename(planned_contact=value)


## -----------------------------------------------------------------------------------
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

incident_officer_injury_type <- uof_raw %>%
  select(form_id, list_col=OffInjuryType) %>%
  make_set_membership_table(officer_injury_type_levels) %>%
  rename(officer_injury_type=value)


## -----------------------------------------------------------------------------------
officer_medical_treatment_levels <- c(
  "EMS on scene",
  "Hospital",
  "Officer Administered First Aid",
  "Refused",
  "Urgent Care"                   
)

incident_officer_medical_treatment <- uof_raw %>%
  select(form_id, list_col=OFFMEDTREAT2) %>%
  make_set_membership_table(officer_medical_treatment_levels) %>%
  rename(officer_medical_treatment=value)




## -----------------------------------------------------------------------------------
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
    pivot_wider(names_from="column", values_from="value") %>%
    mutate(value=factor(str_trim(value), levels=levels)) %>%
    filter(!is.na(value))
}


## -----------------------------------------------------------------------------------
perceived_condition_levels <- c(
  "No unusual condition noted",            
  "Other unusual condition noted",        
  "Potential Mental Health Incident",     
  "Under influence of alcohol/drugs/both" 
)
incident_perceived_condition <- uof_raw %>%
  select(form_id, list_col=PerceivedCondition) %>%
  make_messy_relationship_table(perceived_condition_levels,
                                separating_comma_regex) %>%
  rename(perceived_condition=value)


## -----------------------------------------------------------------------------------
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

incident_subject_action <- uof_raw %>% 
  select(form_id, list_col=SubActions) %>%
  make_messy_relationship_table(subject_action_levels,
                                separating_comma_regex) %>%
  rename(subject_action=value)


## -----------------------------------------------------------------------------------
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
incident_subject_resistance <- uof_raw %>% 
  select(form_id, list_col=SubResist) %>%
  make_messy_relationship_table(subject_resistance_levels,
                                separating_comma_regex) %>%
  rename(subject_resistance=value)


## -----------------------------------------------------------------------------------
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
incident_subject_medical_treatment <- uof_raw %>% 
  select(form_id, list_col=SubMedicalTreat) %>%
  make_messy_relationship_table(subject_medical_treatment_levels,
                                separating_comma_regex) %>%
  rename(subject_medical_treatment=value)


## -----------------------------------------------------------------------------------
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
incident_subject_injury <- uof_raw %>% 
  select(form_id, list_col=SubjectInjuries) %>%
  make_messy_relationship_table(subject_injury_levels,
                                separating_comma_regex) %>%
  rename(subject_injury=value)


## -----------------------------------------------------------------------------------
force_type_levels <- c(
  "Canine bit (apprehension)",                       
  "Canine bit (spontaneous)",                        
  "Carotid artery restraint",                        
  "Chokehold",                                       
  "Compliance hold with impact weapon- not a strike",
  "Discharged Chemical at",                          
  "Discharged Firearm at",                           
  "High Volume OC Spray",             
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
incident_force_type <- uof_raw %>% 
  select(form_id, list_col=TypeofForce) %>%
  make_messy_relationship_table(force_type_levels, ",") %>%
  rename(force_type=value)


## -----------------------------------------------------------------------------------
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
    incident_date_2 = incident_date,
    incident_municipality,
    indoor_or_outdoor,
    video_footage,
    officer_age,
    officer_race,
    officer_rank,
    officer_gender = officer_gender_fill,
    officer_injured = officer_injuries_injured,
    subject_injured_count = TotalSubInjuredIncident,
    on_behalf_of_last_name = on_behalf_other_officer_last_nam,
    on_behalf_of_first_name = on_behalf_other_officer_first_na
  )


## -----------------------------------------------------------------------------------
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


## -----------------------------------------------------------------------------------
stopifnot(0 == 
              uof_raw %>% filter(IncidentDate1 != IncidentDate1_old) %>% nrow()
            )


## -----------------------------------------------------------------------------------
stopifnot(0 == uof_raw %>% filter(!is.na(other_officer_involved)) %>% nrow(),
          0 == uof_raw %>% filter(!is.na(officer_in_uniform)) %>% nrow())


## -----------------------------------------------------------------------------------
stopifnot(
  0 == uof_raw %>%
    select(OffInjuryType, officer_injuries_injured) %>%
    mutate(NoInjury = str_detect(OffInjuryType, "NoInjury")) %>%
    filter(NoInjury == (officer_injuries_injured == "1")) %>%
    nrow()
)


## -----------------------------------------------------------------------------------
stopifnot(
  0 ==
    uof_raw %>% filter(TotalSubInjuredIncident != SubjectInjuredInIncident) %>%
    nrow(),
  0 ==
    uof_raw %>% filter(TotalSubInjuredIncident != SubjectInjuredPrior) %>%
    nrow()
)


## -----------------------------------------------------------------------------------
stopifnot(
  all(uof_raw$ReasonNotArrest == ""),
  all(uof_raw$KEEPDROP == "KEEP"),
  all(
    uof_raw$IncidentYear == lubridate::year(uof_raw$IncidentDate1)
  )
)


## -----------------------------------------------------------------------------------
county_levels <- c(
  "Atlantic",
  "Bergen",
  "Burlington",
  "Camden",
  "Cape May",
  "Cumberland",
  "Essex",
  "Gloucester",
  "Hudson",
  "Hunterdon",
  "Mercer",
  "Middlesex",
  "Monmouth",
  "Morris",
  "Ocean",
  "Passaic",
  "Salem",
  "Somerset",
  "Sussex",
  "Union",
  "Warren",
  "NJSP",
  "Other"
)
incident <- incident %>% 
  mutate(agency_county = factor(agency_county, county_levels))




## -----------------------------------------------------------------------------------
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


## -----------------------------------------------------------------------------------
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


## -----------------------------------------------------------------------------------
stopifnot(0 == setdiff(
  incident %>% pull(incident_municipality_county) %>% discard(is.na),
  county_levels
) %>% length())


## -----------------------------------------------------------------------------------
incident <- incident %>%
  mutate(
    incident_municipality_county =
      factor(incident_municipality_county, levels = county_levels)
  )




## -----------------------------------------------------------------------------------
incident <- incident %>%
  mutate(
    indoors = str_detect(indoor_or_outdoor, "Indoors"),
    outdoors = str_detect(indoor_or_outdoor, "Outdoors")
  ) %>%
  select(-indoor_or_outdoor)


## -----------------------------------------------------------------------------------
video_footage_levels <- c("Yes", "No", "Unknown")
incident <- incident %>%
  mutate(video_footage=str_replace(video_footage, "Unknow", "Unknown")) %>%
  mutate(video_footage=factor(video_footage, levels=video_footage_levels))


## -----------------------------------------------------------------------------------
incident <- incident %>%
  dplyr::mutate(officer_age = ifelse(dplyr::between(officer_age, 18, 67),
                                     as.integer(officer_age),
                                     NA)) 


## -----------------------------------------------------------------------------------
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



## -----------------------------------------------------------------------------------
incident <- incident %>% 
  mutate(officer_injured = (officer_injured=="1"))


## -----------------------------------------------------------------------------------
incident <- incident %>%
  mutate(on_behalf_of_first_name=na_if(on_behalf_of_first_name, "")) %>%
  mutate(on_behalf_of_last_name=na_if(on_behalf_of_last_name, ""))


## -----------------------------------------------------------------------------------
incident <- incident %>%
  left_join(count(subject, form_id, name = "subject_count"),
            by = "form_id")


## -----------------------------------------------------------------------------------
incident <- incident %>%
  relocate(
    form_id,
    report_number,
    incident_case_number,
    incident_date_1,
    incident_date_2,
    agency_county,
    agency_name,
    incident_municipality,
    incident_municipality_county,
    officer_name_id,
    officer_name,
    on_behalf_of_last_name,
    on_behalf_of_first_name,
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

