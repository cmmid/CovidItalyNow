require(readr)
require(dplyr)
require(purrr)
require(magrittr)

get_regional_cases <- function() {
  
  ## Path to data
  path <- "https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni-__date__.csv"
  
  
  ## Function to get daily files
  get_daily_files = function(date){
    
    message("Reading in data from the ", date)
    suppressMessages(suppressWarnings(
      readr::read_csv(gsub("__date__", format(date, "%Y%m%d"), x=path))
    ))
    
  }
  
  ## Extract daily data
  start_date <- lubridate::ymd(20200224)
  start_date <- as.Date(format(start_date, "%Y-%m-%d"))
  end_date <-  as.Date(Sys.Date() - 1)
  
  dates <- seq(start_date, end_date, by = "day")
  
  cases <- purrr::map_dfr(dates, 
                          get_daily_files)
  
  ## Clean variables
  cases <- cases %>% 
    dplyr::mutate(date = as.Date(data),
                  region = denominazione_regione,
                  region_code = codice_regione,
                  total_cases = totale_casi) %>% 
    dplyr::select(date, region, region_code, total_cases) %>% 
    dplyr::arrange(date) %>% 
    dplyr::group_by(region) %>% 
    dplyr::mutate(
      index = 1:dplyr::n(),
      cases = total_cases - ifelse(index == 1, 0, lag(total_cases))) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(-index, -total_cases) %>% 
    ## Adjust negative cases by setting to 0
    dplyr::mutate(cases = ifelse(cases < 0 , 0, cases))
  
  
  return(cases)
  
  
}
  
