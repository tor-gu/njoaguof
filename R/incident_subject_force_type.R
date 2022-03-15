#' Type of force applied.
#'
#' Type of force applied.
#'
#' This data is extracted from the \code{TypeofForce} field in
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
#' @format A dataframe with 3 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{index}{Index in source field list where this value is found.}
#'  \item{force_type}{Type of force applied}
#' }
#' @source \url{https://www.njoag.gov/force/}
#' @seealso \url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
"incident_subject_force_type"
