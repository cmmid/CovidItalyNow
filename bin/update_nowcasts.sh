#!/bin/bash

## Check repo is up to date
git pull

## Reset data cache
Rscript -e "NCoVUtils::reset_cache()"

## Run nowcasts
Rscript inst/utils/update_nowcasts.R

## Update report
Rscript inst/utils/update_report.R

## Push new casts to GitHub
git add --all
git commit -m "Updated nowcasts"
git push
