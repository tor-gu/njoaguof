# This requires a census API key
census_counties <-
  tidycensus::get_estimates(
    geography = "county",
    state = "NJ",
    year = 2019,
    variables = "POP"
  ) %>%
  separate(NAME, sep = ", ", into = c("county", "state")) %>%
  select(county) %>%
  arrange(county)

readr::write_csv(census_counties, "data-raw/census_counties.csv")
usethis::use_data(census_counties, overwrite = TRUE)
