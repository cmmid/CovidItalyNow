
# Load packages -----------------------------------------------------------

require(rmarkdown)
require(furrr)
require(future)


# Set up cores ------------------------------------------------------------

future::plan("multiprocess")

# Update nowcast report ---------------------------------------------------


message("Rendering report to all formats")
## Render to analysis to required output formats

output_formats <- c("html_fragment", "html_document", "pdf_document")

docs <- furrr::future_map(output_formats, function(format) {
  setwd("report")

  docs_to_render <- c("report.Rmd")

  for (doc in docs_to_render) {
    message("Rendering ", doc, " into ", format)
    rmarkdown::render(doc,
                      output_dir = ifelse(format %in% "html_fragment",
                                          "cmmid_report", "rendered_output"),
                      knit_root_dir = c("."),
                      output_format = format)
  }

  return(NULL)
},
.progress = TRUE)


