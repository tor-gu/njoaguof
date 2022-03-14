#' Subject medical treatment
#'
#' Subject medial treatment received.
#'
#' This data is extracted from the \code{SubMedicalTreat} field in
#' \code{use_of_force_raw}.
#'
#' There may be multiple rows in this table linking to a single incident or
#' a single subject.
#'
#' When an incident is associated to more than one subject, there is no reliable
#' way of associating rows in this table to individual subjects. The source
#' field is a comma separated list, and the \code{index} column in this
#' table indicates the position in the list (1 = first position).
#'
#' The medical treatment type will be one of the following:
#' \itemize{
#'  \item "EMS on scene": Treated by Emergency Medical Services on scene.
#'  \item "Hospital": Officer transported to hospital for care.
#'  \item "Mental Health Facility": Subject was transported to mental health facility
#'  \item "Officer Administered First Aid": First aid administered by a police officer including cleaning cuts, applying antibiotic cream, bandages, or ice.
#'  \item "Refused": Officer refused medical treatment.
#'  \item "Urgent Care": Treated at an Urgent Care Facility
#'  \item "Unknown"
#'  \item "Not Provided"
#' }
#'
#' @format A dataframe with 3 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{index}{Index in source field list where this value is found.}
#'  \item{subject_medical_treatment}{Type of force applied. See details.}
#' }
#' @source \url{https://www.njoag.gov/force/}
#' @seealso \url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
"incident_subject_medical_treatment"
