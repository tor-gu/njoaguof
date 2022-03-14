#' Type of officer injury
#'
#' Type of officer injury.
#'
#' This data is extracted from the \code{OffInjuryType} field in
#' \code{use_of_force_raw}.
#'
#' There may be multiple rows in this table linking to a single incident.
#'
#' The injury type will be one of the following:
#' \itemize{
#'  \item "Abrasion/Laceration/Puncture": Any break in skin sustained during the incident.
#'  \item "Chest pains/shortness of breath": Any pain in the chest, or shortness of breath during or after theincident.
#'  \item "Complaint of pain": Any level of pain felt during the incident or as a result of the incident, including OC Spray decontamination.
#'  \item "Concussion": A head injury determined to meet the medical definition of a concussion.
#'  \item "Contusion/bruise": Any bruising as a result of the interaction.
#'  \item "Fracture/dislocation": Any fracture or dislocation of bones sustained during the incident.
#'  \item "Gunshot wound": Any physical trauma caused by a gunshot.
#'  \item "Unknown": The injury type is unknown.
#'  \item "Other"
#' }
#'
#' @format A dataframe with 2 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{officer_injury_type}{Officer injury type. See details.}
#' }
#' @source \url{https://www.njoag.gov/force/}
#' @seealso \url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
"incident_officer_injury_type"
