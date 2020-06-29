library(tigris)
library(dplyr)
library(ggplot2)

options(tigris_use_cache = TRUE,
        tigris_class = "sf")

tract_to_neighborhood <- tribble(
  ~city,~neighborhood,~fips_tract_id,
  1,"West End","39061000200",
  1,"Downtown","39061000700",
  1,"OTR-Pendleton","39061000900",
  1,"OTR-Pendleton","39061001000",
  1,"OTR-Pendleton","39061001100",
  1,"OTR-Pendleton","39061001600",
  1,"OTR-Pendleton","39061001700",
  1,"Mt. Auburn","39061001800",
  1,"Walnut Hills","39061001900",
  1,"E. Walnut Hills","39061002000",
  1,"Mt. Auburn","39061002200",
  1,"Mt. Auburn","39061002300",
  1,"CUF","39061002500",
  1,"CUF","39061002600",
  1,"CUF","39061002700",
  1,"Camp Washington","39061002800",
  1,"CUF","39061002900",
  1,"CUF","39061003000",
  1,"Corryville","39061003200",
  1,"Corryville","39061003300",
  1,"Walnut Hills","39061003600",
  1,"Walnut Hills","39061003700",
  1,"Evanston","39061003800",
  1,"Evanston","39061003900",
  1,"Evanston","39061004000",
  1,"Evanston","39061004100",
  1,"E. Walnut Hills","39061004200",
  0,"Anderson Twp.-Newtown","39061004500",
  1,"Mt. Washington","39061004602",
  1,"Mt. Washington","39061004603",
  1,"Mt. Washington","39061004604",
  1,"Mt. Washington","39061004605",
  1,"Mt. Lookout","39061004701",
  1,"East End-Linwood","39061004702",
  1,"Mt. Lookout","39061004800",
  1,"Hyde Park","39061004900",
  1,"Hyde Park","39061005000",
  1,"Hyde Park","39061005100",
  1,"Oakley","39061005200",
  1,"Oakley","39061005301",
  1,"Oakley","39061005302",
  1,"Oakley","39061005400",
  1,"Madisonville","39061005500",
  1,"Madisonville","39061005600",
  1,"Pleasant Ridge","39061005701",
  1,"Pleasant Ridge","39061005702",
  1,"Kennedy Hts.","39061005800",
  1,"Pleasant Ridge","39061005900",
  1,"Hartwell","39061006000",
  1,"Carthage","39061006100",
  1,"Bond Hill","39061006300",
  1,"Bond Hill","39061006400",
  1,"N. Avondale","39061006500",
  1,"Avondale","39061006600",
  1,"Avondale","39061006800",
  1,"Avondale","39061006900",
  1,"Clifton","39061007000",
  1,"Clifton","39061007100",
  1,"Clifton","39061007200",
  1,"Spring Grove Vlg.","39061007300",
  1,"Northside","39061007400",
  1,"Northside","39061007500",
  1,"S. Cumminsville-Millvale","39061007700",
  1,"Northside","39061007800",
  1,"Northside","39061007900",
  1,"Winton Hills","39061008000",
  1,"College Hill","39061008100",
  1,"College Hill","39061008201",
  1,"College Hill","39061008202",
  1,"Mt. Airy","39061008300",
  1,"College Hill","39061008400",
  1,"Mt. Airy","39061008501",
  1,"Roll Hill","39061008502",
  1,"N. Fairmount","39061008601",
  1,"Westwood","39061008800",
  1,"E. Price Hill","39061009200",
  1,"E. Price Hill","39061009300",
  1,"E. Price Hill","39061009400",
  1,"E. Price Hill","39061009500",
  1,"E. Price Hill","39061009600",
  1,"W. Price Hill","39061009700",
  1,"W. Price Hill","39061009800",
  1,"W. Price Hill","39061009901",
  1,"W. Price Hill","39061009902",
  1,"Westwood","39061010002",
  1,"Westwood","39061010003",
  1,"Westwood","39061010004",
  1,"W. Price Hill","39061010005",
  1,"Westwood","39061010100",
  1,"Westwood","39061010201",
  1,"Westwood","39061010202",
  1,"Riverside-Sedamsville","39061010300",
  1,"Riverside-Sedamsville","39061010400",
  1,"Sayler Park","39061010500",
  1,"Sayler Park","39061010600",
  1,"W. Price Hill","39061010700",
  1,"Madisonville","39061010800",
  1,"Westwood","39061010900",
  1,"Roselawn","39061011000",
  1,"College Hill","39061011100",
  0,"Miami Twp.","39061020401",
  0,"Miami Twp.","39061020403",
  0,"Miami Twp.","39061020404",
  0,"Colerain Twp.","39061020501",
  0,"Colerain Twp.","39061020502",
  0,"Colerain Twp.","39061020504",
  0,"Colerain Twp.","39061020505",
  0,"Green Twp.","39061020601",
  0,"Green Twp.","39061020602",
  0,"Colerain Twp.","39061020701",
  0,"Colerain Twp.","39061020705",
  0,"Colerain Twp.","39061020707",
  0,"Colerain Twp.","39061020741",
  0,"Colerain Twp.","39061020742",
  0,"Colerain Twp.","39061020761",
  0,"Colerain Twp.","39061020762",
  0,"Green Twp.","39061020802",
  0,"Green Twp.","39061020811",
  0,"Green Twp.","39061020812",
  0,"Cheviot","39061020901",
  0,"Cheviot","39061020902",
  0,"Green Twp.","39061021001",
  0,"Green Twp.","39061021002",
  0,"Green Twp.","39061021003",
  0,"Green Twp.","39061021101",
  0,"Green Twp.","39061021102",
  0,"Green Twp.","39061021201",
  0,"Green Twp.","39061021202",
  0,"Delhi Twp.","39061021302",
  0,"Delhi Twp.","39061021303",
  0,"Delhi Twp.","39061021304",
  0,"Delhi Twp.","39061021401",
  0,"Delhi Twp.","39061021421",
  0,"Delhi Twp.","39061021422",
  0,"Springdale","39061021501",
  0,"Forest Park","39061021504",
  0,"Forest Park","39061021505",
  0,"Forest Park","39061021506",
  0,"Springfield Twp.","39061021508",
  0,"Springfield Twp.","39061021509",
  0,"Forest Park","39061021571",
  0,"Forest Park","39061021572",
  0,"Springfield Twp.","39061021602",
  0,"Springfield Twp.","39061021603",
  0,"Colerain Twp.","39061021604",
  0,"Mt. Healthy","39061021701",
  0,"Mt. Healthy","39061021702",
  0,"N. College Hill","39061021801",
  0,"N. College Hill","39061021802",
  0,"Springfield Twp.","39061021900",
  0,"Greenhills","39061022000",
  0,"Springfield Twp.","39061022101",
  0,"Springfield Twp.","39061022102",
  0,"Springfield Twp.","39061022200",
  0,"Springdale","39061022301",
  0,"Sycamore Twp.","39061022302",
  0,"Glendale","39061022400",
  0,"Woodlawn","39061022500",
  0,"Wyoming","39061022601",
  0,"Wyoming","39061022602",
  0,"Lincoln Hts.","39061022700",
  0,"Sharonville","39061023001",
  0,"Sharonville","39061023002",
  0,"Evendale","39061023100",
  0,"Reading","39061023201",
  0,"Reading","39061023210",
  0,"Reading","39061023222",
  0,"Amberley","39061023300",
  0,"Golf Manor","39061023400",
  0,"Blue Ash","39061023501",
  0,"Blue Ash","39061023521",
  0,"Blue Ash","39061023522",
  0,"Sycamore Twp.","39061023600",
  0,"Deer Park","39061023701",
  0,"Deer Park","39061023702",
  0,"Silverton","39061023800",
  0,"Montgomery","39061023901",
  0,"Montgomery","39061023902",
  0,"Sycamore Twp.","39061024001",
  0,"Sycamore Twp.","39061024002",
  0,"Madeira","39061024100",
  0,"Madeira","39061024200",
  0,"Symmes Twp.","39061024301",
  0,"Loveland","39061024303",
  0,"Symmes Twp.","39061024321",
  0,"Symmes Twp.","39061024322",
  0,"Indian Hill","39061024400",
  0,"Fairfax","39061024700",
  0,"Mariemont","39061024800",
  0,"Anderson Twp.-Newtown","39061024901",
  0,"Anderson Twp.-Newtown","39061024902",
  0,"Anderson Twp.-Newtown","39061025001",
  0,"Anderson Twp.-Newtown","39061025002",
  0,"Anderson Twp.-Newtown","39061025101",
  0,"Anderson Twp.-Newtown","39061025102",
  0,"Anderson Twp.-Newtown","39061025103",
  0,"Anderson Twp.-Newtown","39061025104",
  0,"Norwood","39061025200",
  0,"Norwood","39061025300",
  0,"Norwood","39061025401",
  0,"Norwood","39061025402",
  0,"Norwood","39061025500",
  0,"Norwood","39061025600",
  0,"Elmwood","39061025700",
  0,"St. Bernard","39061025800",
  0,"Harrison","39061026001",
  0,"Crosby Twp.","39061026002",
  0,"Harrison","39061026101",
  0,"Whitewater Twp.","39061026102",
  0,"Whitewater Twp.","39061026200",
  1,"Lower Price Hill-Queensgate","39061026300",
  1,"West End","39061026400",
  1,"Downtown","39061026500",
  1,"East End-Linwood","39061026600",
  1,"Walnut Hills","39061026700",
  1,"Mt. Adams","39061026800",
  1,"West End","39061026900",
  1,"Avondale","39061027000",
  1,"Roselawn","39061027100",
  1,"S. Fairmount","39061027200",
  0,"Terrace Park","39061027300",
  0,"Lockland","39061027400"
)


dep_index <- 'https://github.com/cole-brokamp/dep_index/raw/master/ACS_deprivation_index_by_census_tracts.rds' %>%
  url() %>%
  gzcon() %>%
  readRDS() %>%
  as_tibble()

ham_co_tracts <- tigris::tracts(cb=TRUE,state="39",county="061",year=2018)

city_outline <- ham_co_tracts %>%
  left_join(tract_to_neighborhood, by = c('GEOID' = 'fips_tract_id')) %>%
  filter(city == 1) %>%
  st_union() %>%
  st_cast(to = 'MULTILINESTRING') %>%
  st_transform(3735)
mapview::mapview(city_outline)
aws.s3::s3saveRDS(city_outline, "s3://geomarker/geometries/cincinnati_city_outline.rds")

ham_co_pop <- tidycensus::get_acs(geography = 'tract',
                    variables = c(paste0('B01001_00', 1:6), paste0('B01001_0', 27:30)),
                    year = 2018,
                    state = 'Ohio',
                    county = 'Hamilton') %>%
  group_by(GEOID) %>%
  summarize(pop_under_18 = sum(estimate))

ham_co_hh <- tidycensus::get_acs(geography = 'tract',
                                  variables = 'B11005_002',
                                  year = 2018,
                                  state = 'Ohio',
                                  county = 'Hamilton') %>%
  select(GEOID, num_hh = estimate)

# v18 <- tidycensus::load_variables(year = 2018, dataset = 'acs5')

ham_neighborhoods <- ham_co_tracts %>%
  left_join(tract_to_neighborhood, by=c('GEOID'='fips_tract_id')) %>%
  left_join(dep_index, by = c('GEOID' = 'census_tract_fips')) %>%
  left_join(ham_co_pop, by = 'GEOID') %>%
  left_join(ham_co_hh, by = 'GEOID') %>%
  dplyr::select(neighborhood,city,fraction_assisted_income:dep_index, pop_under_18, num_hh) %>%
  group_by(neighborhood) %>%
  summarise(city=max(city),
            fraction_assisted_income = mean(fraction_assisted_income, na.rm = T),
            fraction_high_school_edu = mean(fraction_high_school_edu, na.rm = T),
            median_income = mean(median_income, na.rm = T),
            fraction_no_health_ins = mean(fraction_no_health_ins, na.rm = T),
            fraction_poverty = mean(fraction_poverty, na.rm = T),
            fraction_vacant_housing = mean(fraction_vacant_housing, na.rm = T),
            dep_index = mean(dep_index, na.rm = T),
            pop_under_18 = sum(pop_under_18, na.rm = T),
            num_hh = sum(num_hh, na.rm = T), )
saveRDS(ham_neighborhoods, 'ham_neighborhoods_dep_index_shp.rds')

tract_to_neighborhood <- select(tract_to_neighborhood, -city)
saveRDS(tract_to_neighborhood, 'tract_to_neighborhood.rds')

unique(tract_to_neighborhood$neighborhood)



# clean_map <- theme(
#   axis.text = element_blank(),
#   axis.line = element_blank(),
#   axis.ticks = element_blank(),
#   panel.border = element_blank(),
#   panel.grid = element_line(colour = 'white'),
#   panel.background = element_rect(fill='white'),
#   axis.title = element_blank()
# )
#
# #Hamilton County Map
# Ham_Co_Neighborhood_map<-ggplot(ham_neighborhoods)+
#   geom_sf(fill="lightsteelblue",color="darkgray")+
#   #geom_sf_text(aes(label=AreaLabel),size=2,color="black")+
#   clean_map +
#   theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))
