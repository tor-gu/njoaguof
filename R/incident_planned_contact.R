#' Pre-planned contact.
#'
#' The type of pre-planned contact that initiated the police-citizen contact.
#'
#' This data is extracted from the \code{planned_contact} field in
#' \code{use_of_force_raw}.
#'
#' There may be multiple rows in this table linking to a single incident.
#'
#' The planned contact will be one of the following:
#' \itemize{
#'  \item "Arrest": An arrest of an individual executed at pre-planned time.
#'  \item "Prisoner Transfer": Transport or transfer of a person in custody planned prior to execution.
#'  \item "Processing": Processing of a person in custody planned prior to execution.
#'  \item "Search Warrant Execution": Execution of an issued search warrant.
#' }
#'
#' @format A dataframe with 2 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{planned_contact}{Type of planned contact. See details.}
#' }
#' @source \url{https://www.njoag.gov/force/}
#' @seealso \url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
"incident_planned_contact"
