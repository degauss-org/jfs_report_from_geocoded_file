library(tidyverse)

# pool of addresses to sample from
addresses <- read_csv('test/sample_addresses_geocoded.csv')

set.seed(1234)
# sample 5000 random intake ids
INTAKE_ID <- sample(100000:999999, 5000, replace = F)

# Kris's Nov 2020 reports showed about 60% of intakes screened in
SCREENING_DECISION <- rbinom(n = 5000, size = 1, prob = 0.6) # 0 = screened out, 1 = screened in
length(SCREENING_DECISION[SCREENING_DECISION == 1])

# sample random dates in 2020
DECISION_DATE <- sample(seq.Date(from = as.Date("2020-01-01"), to = as.Date("2020-12-31"), by = 'day'), 5000, replace = T)

# sample from Hamilton Co. addresses
ALLEGATION_ADDRESS <- sample(addresses$ALLEGATION_ADDRESS, 5000, replace = F)

# some allegation addresses are missing
rows_missing_alleg_add <- sample(1:5000, 1000, replace = F)
ALLEGATION_ADDRESS[rows_missing_alleg_add] <- ""

# combine intake-level columns
d <- tibble::tibble(INTAKE_ID, SCREENING_DECISION, DECISION_DATE, ALLEGATION_ADDRESS)

# simulate 1-3 kids per intake
n_acv <- rbinom(n = 5000, size = 2, prob = 0.2) + 1
INTAKE_ID <- rep(INTAKE_ID, n_acv)

PERSON_ID <- sample(100000:999999, length(INTAKE_ID), replace = F)

# rough estimates for race distribution
race <- c(rep('White', 0.47*length(INTAKE_ID)),
          rep('Black/African American', 0.42*length(INTAKE_ID)),
          rep('Asian', 0.02*length(INTAKE_ID)),
          rep('Multi-racial', 0.03*length(INTAKE_ID)),
          rep('Alaskan Native', 0.005*length(INTAKE_ID)),
          rep('American Indian', 0.005*length(INTAKE_ID)),
          rep('Native Hawaiian', 0.005*length(INTAKE_ID)),
          rep('Other Pacific Islander', 0.005*length(INTAKE_ID)),
          rep('Declined', 0.01*length(INTAKE_ID)),
          rep('Unable to Determine', 0.01*length(INTAKE_ID)),
          rep('Unknown', 0.025*length(INTAKE_ID)))
# sample race variable
RACE <- sample(race, length(INTAKE_ID), replace = F)

# combine child-level columns and join to intake-level columns
d_child <- tibble(INTAKE_ID, PERSON_ID, RACE)
d <- left_join(d_child, d, by = 'INTAKE_ID')
d <- select(d, INTAKE_ID, SCREENING_DECISION, DECISION_DATE, ALLEGATION_ADDRESS, PERSON_ID, RACE)

# if allegation address is missing, sample a new address for child address
d <- d %>%
  mutate(CHILD_ADDRESS = ifelse(ALLEGATION_ADDRESS == "",
                                sample(addresses$ALLEGATION_ADDRESS,
                                       length(d$ALLEGATION_ADDRESS[d$ALLEGATION_ADDRESS == ""]),
                                       replace = F),
                                ALLEGATION_ADDRESS))

# sample random dates from 2010 to 2019 for address start date
d <- d %>%
  mutate(ADDRESS_START = sample(seq.Date(as.Date('2010-01-01'), as.Date('2019-12-31'), by = 'day'),
                                nrow(d), replace = T))

# some ACVs are repeated in the data due to being reported by different reporters
acv_repeat <- sample(d$PERSON_ID, 500, replace = F)
d_acv_repeat <- d %>%
  filter(PERSON_ID %in% acv_repeat)

d <- bind_rows(d, d_acv_repeat) %>%
  arrange(INTAKE_ID, PERSON_ID)

# create "bank" of reporters (Kris's Nov 2020 data showed about 52% mandated)
d_reporters <- tibble(REPORTER_PERSON_ID = sample(1000:9999, 1000, replace = FALSE),
                      MANDATED_REPORTER = rbinom(n = 1000, size = 1, prob = 0.52)) %>%
  mutate(MANDATED_REPORTER = factor(MANDATED_REPORTER, levels = c(0, 1), labels = c('No', 'Yes')))

# sample from bank of reporters with replacement
reporters_id <- sample(d_reporters$REPORTER_PERSON_ID, nrow(d), replace = T)
reporters <- tibble(REPORTER_PERSON_ID = reporters_id)
reporters <- left_join(reporters, d_reporters, by = 'REPORTER_PERSON_ID')

# join to data
d <- bind_cols(d, reporters)

# check that none of the repeat acvs have the same reporter
d %>%
  filter(PERSON_ID %in% acv_repeat) %>%
  group_by(PERSON_ID, REPORTER_PERSON_ID) %>%
  tally() %>%
  filter(n != 1)

# clean up screening decision column
d <- d %>%
  mutate(SCREENING_DECISION = factor(SCREENING_DECISION, levels = c(0, 1), labels = c('SCREENED OUT', 'SCREENED IN')) )

d
write_csv(d, 'test/simulated_jfs_data.csv')

