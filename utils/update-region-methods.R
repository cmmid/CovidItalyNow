

regions <- readRDS("data/region_codes.rds") %>% 
  dplyr::select(region)


purrr::walk(regions, ~ file.copy("man/region-specific-methods/template/region-template.md", 
                                 paste0("man/region-specific-methods/", ., ".md"), overwrite = TRUE)
)


