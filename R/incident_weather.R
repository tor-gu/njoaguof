#' Incident weather.
#'
#' Weather conditions during the use of force incident.
#'
#' This data is extracted from the \code{incident_weather} field in
#' \code{use_of_force_raw}.
#'
#' There may be multiple rows in this table linking to a single incident.
#'
#' The weather will be one of the following:
#' \itemize{
#'  \item "Clear": Clear weather. No precipitation or clouds impacting visibility.
#'  \item "Cloudy": Clouds present in the sky, overcast.
#'  \item "Rain": Liquid precipitation.
#'  \item "Snow/sleet/ice": Non-liquid precipitation typically occurring when the temperature is around or below freezing.
#'  \item "Fog": Low lying clouds suspended in the atmosphere and restrict visibility.
#' }
#'
#' @format A dataframe with 2 columns
#' \describe{
#'  \item{form_id}{Unique identifier for the \code{incident} table.}
#'  \item{weather}{Incident weather. See details.}
#' }
#' @source \url{https://www.njoag.gov/force/}
#' @seealso \url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
"incident_weather"
