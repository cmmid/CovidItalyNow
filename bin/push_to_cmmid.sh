#!/bin/bash

# Get or update CMMID
cd ..
base_url="https://github.com/cmmid/"
project="cmmid.github.io"

# Update git or clone if not present
if ([ -e $project ]); then
printf "\tUpdating project: %s \n" $project
cd $project
git pull
cd ..
else
  printf "\tCloning project: %s into projects: %s\n" $project $1
git clone "$base_url$project.git"
fi

# Add new report to Repo

cd CovidItalyNow

Rscript -e "EpiNow::copy_report(
               yaml = 'man/report-yaml.md',
               report = 'report/cmmid_report/report.html',
               date = Sys.Date(),
               lines_to_cut = 1:7,
               report_target = '../cmmid.github.io/topics/covid19/current-patterns-transmission/_posts/2020-03-17-italy-time-varying-transmission.html')"


# Copy across summary pdf reports
cp  report/rendered_output/report.pdf ../cmmid.github.io/topics/covid19/current-patterns-transmission/reports/national-time-varying-transmission/italy.pdf
# Update Repo

cd ../$project

git add --all
git commit -m "Update Italy time-varying rt"
git push

cd ../$source
