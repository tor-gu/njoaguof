% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/incident_subject_action.R
\docType{data}
\name{incident_subject_action}
\alias{incident_subject_action}
\title{Subject action}
\format{
A dataframe with 3 columns
\describe{
\item{form_id}{Unique identifier for the \code{incident} table.}
\item{index}{Index in source field list where this value is found.}
\item{subject_action}{Subject action}
}
}
\source{
\url{https://www.njoag.gov/force/}
}
\usage{
incident_subject_action
}
\description{
Subject’s action that elicited a use of force response.
}
\details{
This data is extracted from the \code{SubActions} field in
\code{use_of_force_raw}.

There may be multiple rows in this table linking to a single incident or
a single subject.

When an incident is associated to more than one subject, there is no reliable
way of associating rows in this table to individual subjects. The source
field is a comma separated list, and the \code{index} column in this
table indicates the position in the list (1 = first position).
}
\seealso{
\url{https://nj.gov/oag/excellence/docs/Use-of-Force-Reporting-Portal-Guide.pdf}
}
\keyword{datasets}
