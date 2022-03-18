library(njoaguof)

trailing_comma_regex <- "(?<=.),?$"
sep_comma_no_space <- ",(?! )"
sep_comma_space_no_paren <- r"(,(?![^(]*\)) )"

check_list_levels <- function(tbl,
                              column,
                              separating_regex,
                              levels,
                              other_acceptable_values = character(0)) {
  message("Checking for unmatched values in ", rlang::enquo(column))
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
  "SubjectsArrested"                 ,"ReasonNotArrest",
  "subject_type"                     ,"SubjectsAge",
  "SubjectRace"                      ,"SubjectsGender",
  "TypeofForce"                      ,"Incident_date1",
  "incident_lighting2"               ,"IncidentYear",
  "KEEPDROP"
)

message("Checking column names")
stopifnot(all.equal(names(use_of_force_raw), raw_names))

uof_raw <- use_of_force_raw %>%
  dplyr::mutate(across(
  where(is.character),
  ~ stringr::str_replace(., trailing_comma_regex, "")
))

check_list_levels(
  uof_raw,
  subject_type,
  sep_comma_no_space,
  njoaguof:::subject_type_levels,
  ""
)

check_list_levels(
  uof_raw,
  SubjectsGender,
  sep_comma_no_space,
  njoaguof:::gender_levels,
  c("", "Not Provided")
)

check_list_levels(
  uof_raw,
  SubjectRace,
  sep_comma_no_space,
  njoaguof:::race_levels,
  c("Am. Indian", "Black or African American", "", "Not Provided")
)

check_list_levels(
  uof_raw,
  incident_weather,
  sep_comma_space_no_paren,
  njoaguof:::weather_levels,
  c("N/A", "")
)

check_list_levels(
  uof_raw,
  video_type,
  sep_comma_space_no_paren,
  njoaguof:::video_type_levels,
  c("[]", "")
)

check_list_levels(
  uof_raw,
  incident_lighting,
  sep_comma_space_no_paren,
  njoaguof:::lighting_levels
)

check_list_levels(
  uof_raw,
  location_type,
  sep_comma_space_no_paren,
  njoaguof:::location_type_levels,
  ""
)

check_list_levels(
  uof_raw,
  incident_type,
  sep_comma_space_no_paren,
  njoaguof:::incident_type_levels,
  ""
)

check_list_levels(
  uof_raw,
  contact_origin,
  sep_comma_space_no_paren,
  njoaguof:::contact_origin_levels,
  ""
)

check_list_levels(
  uof_raw,
  planned_contact,
  sep_comma_space_no_paren,
  njoaguof:::planned_contact_levels,
  c("", "Other ")
)

check_list_levels(
  uof_raw,
  OffInjuryType,
  sep_comma_space_no_paren,
  njoaguof:::officer_injury_type_levels,
  c("No Injury", "Not Provided")
)

check_list_levels(
  uof_raw,
  OFFMEDTREAT2,
  sep_comma_space_no_paren,
  njoaguof:::officer_medical_treatment_levels,
  c("Not Provided", "")
)

check_list_levels(
  uof_raw,
  PerceivedCondition,
  sep_comma_no_space,
  njoaguof:::perceived_condition_levels,
  c("Not Provided", "")
)

check_list_levels(
  uof_raw,
  SubActions,
  sep_comma_no_space,
  njoaguof:::subject_action_levels,
  ""
)

check_list_levels(
  uof_raw,
  SubResist,
  sep_comma_no_space,
  njoaguof:::subject_resistance_levels,
  ""
)

check_list_levels(
  uof_raw,
  SubMedicalTreat,
  sep_comma_no_space,
  njoaguof:::subject_medical_treatment_levels,
  ""
)

check_list_levels(
  uof_raw,
  SubjectInjuries,
  sep_comma_no_space,
  njoaguof:::subject_injury_levels,
  ""
)

check_list_levels(
  uof_raw,
  TypeofForce,
  sep_comma_space_no_paren,
  njoaguof:::force_type_levels,
  ""
)

check_list_levels(
  uof_raw,
  ReasonNotArrest,
  sep_comma_no_space,
  njoaguof:::reason_not_arrested_levels,
  c("Not Provided", "")
)
message("Checking county levels")
stopifnot(0 ==
            setdiff(uof_raw %>% dplyr::pull(County2), njoaguof:::county_levels))

