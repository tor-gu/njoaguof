#' Use of force subjects.
#'
#' Every subject in a use of force incident.
#'
#' This table contains every field that can reliably be attributed to a
#' specific subject.
#'
#' Subject types:
#' \itemize{
#'  \item "Person": Human.
#'  \item "Animal": An animal acting aggressively to an officer or other person.
#'  \item "Unknown Subject(s)": When the identity of the subject is unknown. For example: A person of unknown identity, or a crowd of people
#'  \item "Other"
#' }
#'
#' @format A dataframe with 10 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{index}{Subject index}
#'  \item{arrested}{\code{TRUE} if the subject was arrested.}
#'  \item{type}{Subject type. See details.}
#'  \item{age}{Subject age.}
#'  \item{juvenile}{Subject is a juvenile.}
#'  \item{race}{Subject race}
#'  \item{gender}{Subject gender.}
#'  \item{injured}{\code{TRUE} if the subject was injured in the incident.
#'  \code{NA} where the source recorded \code{"Unknown"} or left the field
#'  blank. \emph{C.f.} table \code{incident_subject_injury} for injury types,
#'  and note the warning on \code{incident$subject_injured_count}.}
#'  \item{injured_prior}{\code{TRUE} if the subject was injured \emph{before}
#'  the incident. \code{NA} where the source recorded \code{"Unknown"} or left
#'  the field blank.}
#' }
#' @source \url{https://www.njoag.gov/force/}
"subject"
