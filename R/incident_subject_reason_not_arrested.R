#' Reason subject was not arrested
#'
#' Reason subject was not arrested
#'
#' This data is extracted from the \code{ReasonNotArrest} field in
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
#' The reason subject not arrested will be one of the following:
#' \itemize{
#'  \item "Already in Custody": Subject was already in police custody when force was used
#'  \item "Deceased": Subject is deceased
#'  \item "Medical/Mental Health Incident": Subject was transported to hospital
#'  or mental health facility following force incident.
#'  \item "Subject Fled": Subject ran and was not apprehended.
#'  \item "Other"
#' }
#' @format A dataframe with 3 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{index}{Index in source field list where this value is found.}
#'  \item{reason_not_arrested}{Reason subject not arrested.}
#' }
#' @source \url{https://www.njoag.gov/force/}
#' @seealso \url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
"incident_subject_resistance"
