# The package exports nothing, so datasets are reached through data() rather
# than by name.
uof <- function(name) {
  e <- new.env(parent = emptyenv())
  utils::data(list = name, package = "njoaguof", envir = e)
  get(name, envir = e)
}

# Every table below keys to `incident` on `form_id`.
child_tables <- c(
  "subject",
  "incident_contact_origin",
  "incident_lighting",
  "incident_location_type",
  "incident_officer_injury_type",
  "incident_officer_medical_treatment",
  "incident_planned_contact",
  "incident_type",
  "incident_video_type",
  "incident_weather",
  "incident_subject_action",
  "incident_subject_force_type",
  "incident_subject_injury",
  "incident_subject_medical_treatment",
  "incident_subject_perceived_condition",
  "incident_subject_reason_not_arrested",
  "incident_subject_resistance"
)

# Tables carrying an `index` column recording position in the source list.
indexed_tables <- c(
  "subject",
  "incident_subject_action",
  "incident_subject_force_type",
  "incident_subject_injury",
  "incident_subject_medical_treatment",
  "incident_subject_perceived_condition",
  "incident_subject_reason_not_arrested",
  "incident_subject_resistance"
)

# Every table that ships, for sweeps that apply to all of them.
all_tables <- c(
  "incident", "use_of_force_raw", "officer_name_variants",
  "census_counties", "census_municipalities", child_tables
)
