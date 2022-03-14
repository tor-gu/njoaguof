#' Type of officer medical treatment.
#'
#' Type of medical treatment received by officer.
#'
#' This data is extracted from the \code{OFFMEDTREAT2} field in
#' \code{use_of_force_raw}.
#'
#' There may be multiple rows in this table linking to a single incident.
#'
#' The injury type will be one of the following:
#' \itemize{
#'  \item "EMS on scene": Treated by Emergency Medical Services on scene.
#'  \item "Hospital": Officer transported to hospital for care.
#'  \item "Officer Administered First Aid": First aid administered by a police officer including cleaning cuts, applying antibiotic cream, bandages, or ice.
#'  \item "Refused": Officer refused medical treatment.
#'  \item "Urgent Care": Treated at an Urgent Care Facility
#' }
#'
#' @format A dataframe with 2 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{officer_medical_treatment}{Officer medical treament type. See details.}
#' }
#' @source \url{https://www.njoag.gov/force/}
#' @seealso \url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
"incident_officer_medical_treatment"
