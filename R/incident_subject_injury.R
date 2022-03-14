#' Subject injury
#'
#' Subject’s type of injury.
#'
#' This data is extracted from the \code{SubjectInjuries} field in
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
#'  \item{subject_injury}{Subject injury}
#' }
#' @source \url{https://www.njoag.gov/force/}
#' @seealso \url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
"incident_subject_injury"
