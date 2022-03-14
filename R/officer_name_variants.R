#' Officer name variants.
#'
#' Every officer name and name id occurring in the raw data.
#'
#' This data is extracted from the \code{officer_name} and \code{Officer_Name2}
#' fields in \code{use_of_force_raw}.
#'
#' The raw data contains an officer name id and an officer name for each
#' incident. The officer name will sometimes vary from incident to incident in
#' spelling and capitalization. This table records every variant seen.
#'
#' If you need to associate a specific name variant with a specific incident,
#' refer to the raw data.
#'
#'
#' @format A dataframe with 2 columns
#' \describe{
#'  \item{officer_name_id}{Officer name id}
#'  \item{officer_name}{Officer name variant}
#' }
#' @source \url{https://www.njoag.gov/force/}
"officer_name_variants"
