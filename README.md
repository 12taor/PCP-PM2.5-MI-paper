# PCP-PM2.5-MI-paper
Code associated with the manuscript: Applying Principal Component Pursuit (PCP) to investigate the association between source-specific fine particulate matter (PM2.5) and myocardial infarction (MI) hospitalizations in New York City 

This repo contains 3 .Rmd files and 1 .R file. They are meant to be run in the following order:

1. root_ncnvx_pcp_paper.Rmd^
2. paper_figures.Rmd
3. main_effect_paper.Rmd

^This script refers to the function contained in eda-latest-nyc-data.R, but there is no need to separately run eda-latest-nyc-data.R

### pcpr and PCPHelpers Packages
To run the scripts in this repo, you will need the pcpr and PCPHelpers packages, which can be found on github at the following pages:
pcpr: https://github.com/Columbia-PRIME/pcpr
PCPHelpers: https://github.com/Columbia-PRIME/PCPhelpers

To use these packages, clone the repos or download the .zip files. Locate the folder, unzip if applicable, and use the following code. Replace path_to_folder with your local path.

install.packages("path_to_folder", repos = NULL, type="source")
library(pcpr)
library(PCPHelpers)

### Datasets:
Main datasets (all in the 'data' folder):
* nyc_daily_pm2.5_components.csv: This was compiled by averaging all available data from the 3 NYC Air Quality System monitors, to get the maximum amount of coverage. This means that for some observations in the nyc file, only one monitor contributed to the value, while for others, 2-3 monitors influenced the value. 
* pm2.5_total_components_daily_nyc_avg.csv: Daily average for total PM_[2.5] in NYC, averaging across monitors.
* monitor_sites.csv: geographic information for NYC AQS monitors
* cb_2018_us_county_500k: .shp files to create map of monitor sites

Generated datasets:

* pcp_nmf_loadings_offset.csv: loadings from NMF applied to low-rank matrix from PCP (included in data folder)
* pcp_nmf_scores_offset.csv: scores from NMF applied to low-rank matrix from PCP (included in data folder)
* MI_pcp_nmf.csv (NOT included in data folder)

### 1: Non-convex Root PCP
In this script, we apply non-convex square-root principal component pursuit (PCP) to speciated PM_[2.5] data in NYC, then apply non-negative matrix factorization (NMF) to the resulting low-rank matrix. This process involvles the following steps:

1. Install pcpr and PCPHelpers R packages according to the above instructions and load all other packages.
2. Load speciated PM_[2.5] data from nyc_daily_pm2.5_components.csv and pm2.5_total_components_daily_nyc_avg.csv for the years 2007-2016. For this step, we use the function prep_data, located in eda-latest-nyc-data.R, to load speciated PM_[2.5] data, so that we can load both scaled and unscaled versions to be used in the following analyses. Prep_data formats the data as a list.
3. Create correlation matrix visualization (Figure S3).
4. Use cross-validation to select hyperparameters for PCP (this step takes some time to run, and will not affect the rest of the output if not run)
5. Run PCP using selected hyperparameters.
6. Select the NMF algorithm with the lowest residual error and run NMF on low-rank matrix from PCP.
7. Compute estimated concentrations
8. Export PCP-NMF loadings (pcp_nmf_loadings_offset.csv) and PCP-NMF scores (pcp_nmf_scores_offset.csv).
9. Create PCP-NMF loadings figure (Figure 1).
10. Create heatmap of sparse matrix from PCP (Figure S11).

### 2: Paper figures
This script was originally used for exploratory data analysis prior to running the health model. These analyses are mainly incorporated into the manuscript as supplemental figures and tables.

1. Load PCP-NMF scores (pcp_nmf_scores_offset.csv), MI data (not included), and weather data (nyc_dailyweathervar.csv). Combine and export as MI_pcp_nmf.csv.
2. Create figures and tables - all except Figure 1 use previously-generated datasets.
2a. Create Figure 1 (map of NYC AQS monitors). This figure requires a separate set of R packages, monitor location data from monitor_sites.csv, and .shp files located in cb_2018_us_county_500k.

### 3: Main effects
In this script we run the health model. It only uses MI_pcp_nmf.csv (not included in the data folder).

1. Load MI_pcp_nmf.csv
2. Run main effects model, modeling all sources linearly.
3. View model reesults (Table S1 and Figure 2).
4. Model source 2 non-linearly with all other sources linear, and do the same for source 5. Originally this was done for each source, but we only include sources 2 and 5 because these models contained results discussed in the manuscript.
5. Run quasipoisson model at lags 1 and 2, modeling all sources linearly
6. Sensitivity analysis: create dataset with outliers 3SD or higher removed, then run the main effects model using this dataset.
7. Sensitivity analysis: run single-source models
