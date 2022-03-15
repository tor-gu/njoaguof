#' Origin(s) of initial police-citizen contact
#'
#' Origin of initial police-citizen contact
#'
#' This data is extracted from the \code{contact_origin} field in
#' \code{use_of_force_raw}.
#'
#' There may be multiple rows in this table linking to a single incident.
#'
#' The contact origin will be one of the following:
#'
#' \itemize{
#'  \item "Dispatched": Incidents initiated when an officer receives
#' notification of a call from a communication dispatcher or headquarters to a
#' specific location or situation; calls for service.
#'  \item "Officer Initiated": Incidents initiated when an officer initiates
#' the situation; on view incidents.
#'  \item "Citizen Initiated": Incidents initiated when a citizen initiates
#' contact by directly communicating with an officer.
#'  \item "Pre-planned Contact": Incidents planned prior to contact including
#' search warrant executions, prisoner transports, judicial order service, etc.  \emph{C.f.} table \code{incident_planned_contact}.
#' }
#'
#' @format A dataframe with 2 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{contact_origin}{Contact origin. See details.}
#' }
#' @source \url{https://www.njoag.gov/force/}
#' @seealso \url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
"incident_contact_origin"
