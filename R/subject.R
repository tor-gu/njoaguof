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
#' @format A dataframe with 8 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{index}{Subject index}
#'  \item{arrested}{\code{TRUE} if the subject was arrested.}
#'  \item{type}{Subject type. See details.}
#'  \item{age}{Subject age.}
#'  \item{juvenile}{Subject is a juvenile.}
#'  \item{race}{Subject race}
#'  \item{gender}{Subject gender.}
#' }
#' @source \url{https://www.njoag.gov/force/}
"subject"
