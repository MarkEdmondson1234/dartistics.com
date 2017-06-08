# This script is simply a mechanism for installing all of the packages used
# in the exercises and examples on dartistics.com. Some (many/all) of these
# packages have dependencies on other packages, so more than just the packages
# listed below will be installed.

# List of packages used on the site
packages_list <- c("CausalImpact",
                   "dygraphs",
                   "forecast",
                   "googleAuthR",
                   "googleAnalyticsR",
                   "googlesheets",
                   "pander",
                   "highcharter",
                   "plotly",
                   "reshape2",
                   "RSiteCatalyst",
                   "rpart",
                   "rpart.plot",
                   "scales",
                   "searchConsoleR",
                   "shiny",
                   "tidyverse",
                   "tools",
                   "VennDiagram",
                   "WriteXLS",
                   "xts",
                   "zoo")

# Get the list of packages that are not present on the current system
packages_to_install <- packages_list[!(packages_list %in% installed.packages()[,"Package"])]

# Install those packages
if(length(packages_to_install)) install.packages(packages_to_install, repos = "http://cran.rstudio.com")