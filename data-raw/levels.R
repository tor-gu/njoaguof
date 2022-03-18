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
  "Carotid artery restraint",
  "CED Spark Display",
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

reason_not_arrested_levels <- c(
  "Already in Custody",
  "Deceased",
  "Medical/Mental Health Incident",
  "Subject Fled",
  "Other"
)

usethis::use_data(
  incident_type_levels,
  subject_type_levels,
  gender_levels,
  race_levels,
  weather_levels,
  video_type_levels,
  lighting_levels,
  location_type_levels,
  contact_origin_levels,
  planned_contact_levels,
  officer_injury_type_levels,
  officer_medical_treatment_levels,
  perceived_condition_levels,
  subject_action_levels,
  subject_resistance_levels,
  subject_medical_treatment_levels,
  subject_injury_levels,
  force_type_levels,
  county_levels,
  reason_not_arrested_levels,
  internal = TRUE,
  overwrite = TRUE)
