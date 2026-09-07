# The raw .dta is build-time input only. It lives in data-raw/ (which is
# .Rbuildignore'd) so that it does not ship with the installed package --
# installed users get the much smaller data/use_of_force_raw.rda instead.
library(dplyr)

use_of_force_raw <-
  "data-raw/NJOAGUOF_Data_100120_to_103124.dta" %>%
  haven::read_dta() %>%
  haven::zap_formats() %>%
  dplyr::mutate(dplyr::across(
    where(rlang::is_character), stringr::str_trim))

usethis::use_data(use_of_force_raw, overwrite = TRUE)
