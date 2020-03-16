
# Packages -----------------------------------------------------------------
require(EpiNow)
require(NCoVUtils)
require(furrr)
require(future)
require(readr)
require(dplyr)
require(tidyr)
require(purrr)
require(magrittr)


# Get resources -----------------------------------------------------------


source("utils/get_regional_cases.R")

# Get cases ---------------------------------------------------------------

cases <- get_regional_cases()


region_codes <- cases %>% 
  dplyr::select(region, region_code) %>% 
  unique() %>% 
  dplyr::mutate(region_code = as.numeric(region_code))

saveRDS(region_codes, "data/region_codes.rds")

cases <- cases %>% 
  dplyr::rename(local = cases) %>% 
  dplyr::mutate(imported = 0) %>% 
  tidyr::gather(key = "import_status", value = "cases", local, imported)


# Get linelist ------------------------------------------------------------

linelist <- NCoVUtils::get_international_linelist("Italy")

# Set up cores -----------------------------------------------------

future::plan("multiprocess", workers = future::availableCores())

data.table::setDTthreads(threads = 1)


# Run pipeline ----------------------------------------------------

EpiNow::regional_rt_pipeline(
  cases = cases, 
  linelist = linelist, 
  regional_delay = FALSE,
  target_folder = "results", 
  merge_onsets = FALSE
)
