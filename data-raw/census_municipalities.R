library(dplyr)
library(purrr)
library(readr)
library(tidyr)

census_counties <- read_csv("data-raw/census_counties.csv")

census_municipalities <- census_counties %>%
  pull(county) %>%
  purrr::map_dfr(
    ~ tidycensus::get_estimates(geography="county subdivision",
                                state="NJ",
                                county=.,
                                year=2019,
                                variables="POP")
  ) %>%
  separate(NAME, sep=", ", into=c("municipality_and_type","county","state")) %>%
  separate(municipality_and_type,
           sep=" (?=[a-z]+$)",
           into=c("municipality","type"),
           fill="right",
           remove=FALSE) %>%
  select(municipality, type, municipality_and_type, county) %>%
  arrange(county, municipality_and_type)

write_csv(census_municipalities, "data-raw/census_municipalities.csv")
usethis::use_data(census_municipalities, overwrite = TRUE)
