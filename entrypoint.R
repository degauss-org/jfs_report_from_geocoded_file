#!/usr/local/bin/Rscript

setwd('/tmp')

suppressPackageStartupMessages(library(argparser))
p <- arg_parser('create JFS Neighborhood Report')
p <- add_argument(p,'intake_file_name',help='name of geocoded intake-level csv file')
p <- add_argument(p,'acv_file_name',help='name of geocoded child-level csv file')
args <- parse_args(p)

# args <- list()
# args$file_name <- "sample_addresses_geocoded.csv"

# INTAKE_ID
# SCREENING_DECISION = SCREENED OUT or SCREENED IN
# ALLEGATION_ADDRESS, formatted in a string without punctuation, it includes city, state, and zip code

suppressPackageStartupMessages(library(readr))
d_intake <- read_csv(args$intake_file_name,
              col_types = cols(INTAKE_ID = col_character(),
                               fips_tract_id = col_character()))

d_child <- read_csv(args$acv_file_name,
                      col_types = cols(ACV_ID = col_character(),
                                       fips_tract_id = col_character()))

rmarkdown::render(input = '/app/generate_report.Rmd',
                  params = list(d_intake = d_intake,
                                d_child = d_child),
                  envir = new.env(),
                  output_file = fs::path("/tmp", paste0(gsub('.csv', '', args$intake_file_name, fixed=TRUE), '_report.html')))


