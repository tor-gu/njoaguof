#' Reason for initial dispatch or encounter
#'
#' The type of incident during which the use of force occurred.
#'
#' This data is extracted from the \code{incident_type} field in
#' \code{use_of_force_raw}.
#'
#' There may be multiple rows in this table linking to a single incident.
#'
#' @format A dataframe with 2 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{type}{Incident type.}
#' }
#' @source \url{https://www.njoag.gov/force/}
#' @seealso \url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
"incident_type"
