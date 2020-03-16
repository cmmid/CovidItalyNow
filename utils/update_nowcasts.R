
# Packages -----------------------------------------------------------------
require(EpiNow)
require(furrr)
require(future)

# Set up cores -----------------------------------------------------

future::plan("multiprocess", workers = future::availableCores())

data.table::setDTthreads(threads = 1)



# Run pipeline ----------------------------------------------------

EpiNow::regional_rt_pipeline(
  cases = cases, 
  linelist = linelist, 
  target_folder = "results", 
  merge_onsets = FALSE
)
