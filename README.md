# jfs_report_from_geocoded_file <a href='https://degauss-org.github.io/DeGAUSS/'><img src='DeGAUSS_hex.png' align="right" height="138.5" /></a>

> DeGAUSS container that generates a neighborhood-level report for JFS from a geocoded csv file

[![Docker Build Status](https://img.shields.io/docker/automated/degauss/jfs_report_from_geocoded_file)](https://hub.docker.com/repository/docker/degauss/jfs_report_from_geocoded_file/tags)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/degauss-org/jfs_report_from_geocoded_file)](https://github.com/degauss-org/jfs_report_from_geocoded_file/releases)

## DeGAUSS example call

If `sample_addresses_geocoded.csv` is a file in the current working directory with coordinate columns named `lat` and `lon`, then

```sh
docker run --rm -v $PWD:/tmp degauss/jfs_report_from_geocoded_file:0.1 sample_addresses_geocoded.csv
```

will produce `sample_addresses_geocoded_mandated_reporter_report.html` and `sample_addresses_geocoded_race_report.html`.

## geomarker data

- census tract-level [deprivation index](https://geomarker.io/dep_index/) from 2015 ACS measures
- census tract-level population under age 18 from 2018 ACS
- `00_create_tract_to_neighborhood.R` (based on code from Stu) makes `tract_to_neighborhood.rds` which is used to convert tracts to neighborhoods
- `00_create_tract_to_neighborhood.R` also aggregates tract-level deprivation index (mean) and tract-level population under 18 (sum) to neighborhood and creates the neighborhood shapefile called `ham_neighborhoods_dep_index_shp.rds`

## DeGAUSS details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS README](https://degauss.org/).
