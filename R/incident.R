#' Incidents in the NJ OAG Use of Force database
#'
#' Use of force incidents from the NJ OAG Use of Force database.
#'
#' @format A dataframe with 22 columns
#' \describe{
#'  \item{form_id}{A unique identifier for the row, present in the source data}
#'
#'  \item{report_number}{An identifier for a use of force report (potentially
#'  containing multiple incidents)}
#'
#'  \item{incident_case_number}{A unique internal agency case number assigned
#'  to the incident.}
#'
#'  \item{incident_date_1}{The date of the incident. In the source data, this
#'  is column \code{IncidentDate}, and is the date the OAG dashboard uses as the
#'  incident date.}
#'
#'  \item{agency_county}{The county of the \emph{agency}.
#'  Note that this is not the incident location. This is column
#'  \code{County}.}
#'
#'  \item{agency_name}{The name of the agency, e.g. "Essex Co Sheriffs
#'  Office".}
#'
#'  \item{incident_municipality}{The municipality where the incident occurred.}
#'
#'  \item{incident_municipality_county}{The county where the incident
#'  occurred.}
#'
#'  \item{officer_name_id}{An ID identifying the officer. In the source data,
#'  this is column \code{UserID}. }
#'
#'  \item{officer_name}{The most common name associated to the
#'  \code{officer_name_id}. In this table, each
#'  \code{officer_name_id} is associated to a single name, while in the
#'  source data (column \code{OfficerName}), names will sometimes vary in
#'  spelling and capitalization.
#'
#'  \code{officer_name} is \code{NA} whenever \code{officer_name_id} is
#'  \code{NA} (327 incidents, all from 2020 and 2021). For these rows the
#'  source gives the placeholder \code{"Not Provided Not Provided"} instead
#'  of a name.
#'
#'  For name variants, refer to table \code{officer_name_variants}. To associate
#'  a name variant to a specific incident, refer to the raw data
#'  \code{use_of_force_raw}, column \code{OfficerName}.}
#'
#'  \item{officer_age}{The officer's age.}
#'
#'  \item{officer_race}{The officer's race.}
#'
#'  \item{officer_rank}{The officer's rank.}
#'
#'  \item{officer_gender}{The officer's gender.}
#'
#'  \item{officer_injured}{\code{TRUE} if the officer was injured in the
#'  incident. \emph{C.f.} tables \code{incident_officer_injury_type} and
#'  \code{incident_officer_medical_treatment}.}
#'
#'  \item{video_footage}{Whether there is video footage of the incident:
#'  \code{"Yes"}, \code{"No"} or \code{"Unknown"}. \emph{C.f} table
#'  \code{incident_video_type}.}
#'
#'  \item{indoors}{\code{TRUE} if the incident was indoors. Not exclusive of
#'  \code{outdoors}.}
#'
#'  \item{outdoors}{\code{TRUE} if the incident was outdoors. Not exclusive of
#'  \code{indoors}.}
#'
#'  \item{subject_count}{Number of subjects involved. This will reliably match
#'  the number of subject in the \code{subject} table with same \code{form_id}.}
#'
#'  \item{subject_injured_count}{Number of injured subjects. This field
#'  corresponds to column \code{TotalSubInjuredInIncident} in the raw data.
#'  Wherever both are known, it equals the number of subjects in the
#'  \code{subject} table with \code{injured == TRUE}.
#'
#'  \emph{\strong{Warning} Before release 1.16.0 this field was not reliable:
#'  the source often gave more injured subjects than subjects (over 1,500
#'  incidents in 1.15.0). Take care when comparing with older releases.}}
#'
#'  \item{other_officer_involved}{\code{TRUE} if another officer was involved
#'  in the incident.
#'
#'  \emph{\strong{Warning} This field is largely unpopulated. The source data
#'  records \code{"Not Provided"} for more than 80\% of incidents, which
#'  becomes \code{NA} here. In practice the field was only collected during
#'  2020 and 2021 -- from 2022 onward it is \code{NA} for every incident but
#'  one.}}
#'
#'  \item{officer_in_uniform}{\code{TRUE} if the officer was in uniform. This
#'  field is populated for every incident.}
#'
#' }
#' @source \url{https://www.njoag.gov/force/}
"incident"
