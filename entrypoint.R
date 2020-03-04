#!/usr/local/bin/Rscript

setwd('/tmp')

suppressPackageStartupMessages(library(argparser))
p <- arg_parser('create JFS Neighborhood Report')
p <- add_argument(p,'file_name',help='name of address csv file')
args <- parse_args(p)

# args <- list()
# args$file_name <- "sample_addresses_geocoded.csv"


suppressPackageStartupMessages(library(readr))
d <- read_csv(args$file_name,
              col_types = cols(intake_id = col_character(),
                               fips_tract_id = col_character()))

rmarkdown::render(input = '/app/generate_report.Rmd',
                  params = list(d = d),
                  output_file = paste0('/tmp/', gsub('.csv', '', args$file_name, fixed=TRUE), '_report.html'))
