#' Incident lighting circumstances
#'
#' All lighting circumstances during the use of force incident.
#'
#' This data is extracted from the \code{incident_lighting} field in
#' \code{use_of_force_raw}.
#'
#' There may be multiple rows in this table linking to a single incident.
#'
#' The lighting type will be one of the following:
#' \itemize{
#'  \item "Dawn/dusk": First appearance of light in the sky before sunrise or the last appearance of lightbefore sunset.
#'  \item "Daylight": Natural light of day, even during cloudy conditions.
#'  \item "Darkness": The absence of light or low level lighting making it difficult to see.
#'  \item "Artificial": Light from an artificial source such as a lamp, flashlight, or light fixture.
#' }
#'
#' @format A dataframe with 2 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{lighting}{Incident lighting. See details.}
#' }
#' @source \url{https://www.njoag.gov/force/}
#' @seealso \url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
"incident_lighting"
