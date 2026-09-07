# The raw source file is build-time input only. It lives in data-raw/ (which is
# .Rbuildignore'd) so that it does not ship with the installed package --
# installed users get the much smaller data/use_of_force_raw.rda instead.
#
# Starting in versoin 2.0.0, we switched to using the NJOAG's .sav release instead 
# of the .dta release, as the .dta release through 2026-08-31 had truncated fields.
library(dplyr)

use_of_force_raw <-
  "data-raw/NJOAGUOF_Data_100120_to_083126.sav" |>
  haven::read_sav() |>
  haven::zap_formats() |>
  haven::zap_labels() |>
  dplyr::mutate(dplyr::across(
    where(rlang::is_character), stringr::str_trim))

usethis::use_data(use_of_force_raw, overwrite = TRUE)
