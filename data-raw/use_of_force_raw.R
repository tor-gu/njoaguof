use_of_force_raw <-
  system.file("extdata",
              "NJOAGUOF_Data_100120_to_083122.dta",
              package = "njoaguof") %>%
  haven::read_dta() %>%
  haven::zap_formats() %>%
  dplyr::mutate(dplyr::across(
    where(rlang::is_character), stringr::str_trim))

usethis::use_data(use_of_force_raw, overwrite = TRUE)

