library(lubridate)
library(stringr)
library(dplyr)
library(tidyr)
library(sqldf)
library(scales)

UCL_function <- function(ref,pop,devs,.x) pmin(ref+devs*sqrt(ref*(pop-ref)/.x),pop)
LCL_function <- function(ref,pop,devs,.x) pmax(ref-devs*sqrt(ref*(pop-ref)/.x),0)

p_chart_centerlines <- function(data,date_name,factor,shifts,base_start_date,base_end_date,numer,denom,time_period) {

  group_list<-str_c(factor,collapse = ", ")
  on_list1<-paste(paste0('d.',factor),'=',paste0('c.',factor),collapse=' and ')
  on_list2<-paste(paste0('d.',factor),'=',paste0('c2.',factor),collapse=' and ')
  output_factor_list<-paste0('d.',factor,collapse=', ')

  factor_list <- sqldf::sqldf(sprintf("select distinct %s from data",group_list)) %>%
    mutate(CENTERLINE_START=base_start_date,CENTERLINE_END=base_end_date,IN_CALC=TRUE) %>%
    dplyr::union(shifts)

  last_date <- max(pull(data %>% select({{date_name}})))

  #chunks<-sqldf::sqldf(sprintf("select f.*, coalesce(lead(CENTERLINE_START) over (partition by %2$s order by CENTERLINE_START),%1$d) as PLOT_END from factor_list f group by %2$s",last_date,group_list)) %>%
  chunks<-sqldf::sqldf(sprintf("select f.*, lead(CENTERLINE_START) over (partition by %1$s order by CENTERLINE_START) as PLOT_END from factor_list f",group_list)) %>%
    mutate(PLOT_END=as.Date(PLOT_END, "1970-01-01")-period(1,units=time_period),
           PLOT_END=replace_na(PLOT_END,last_date))

  center_query<-sprintf('select %6$s, c.CENTERLINE_START, c.CENTERLINE_END, c2.PLOT_END, sum(d.%4$s) as Numer, sum(d.%5$s) as Denom,(sum(d.%4$s)*1.0)/(sum(d.%5$s)*1.0) as CENTERLINE from data d left join chunks c on %1$s and d.%2$s >= c.CENTERLINE_START and d.%2$s <= c.CENTERLINE_END left join chunks c2 on %3$s and d.%2$s >= c2.CENTERLINE_START and d.%2$s <= c2.PLOT_END where c.IN_CALC=TRUE group by %6$s, c.CENTERLINE_START, c2.PLOT_END',on_list1,date_name,on_list2,numer,denom,output_factor_list)
  centers<-sqldf(center_query)

  data_query<-sprintf('select d.*, c2.CENTERLINE_START, c2.CENTERLINE_END, c2.PLOT_END, c2.CENTERLINE Centerline from data d left join centers c2 on %3$s and d.%2$s >= c2.CENTERLINE_START and d.%2$s <= c2.PLOT_END',on_list1,date_name,on_list2)
  sqldf::sqldf(data_query) %>%
    mutate(UCL=UCL_function(ref=Centerline,pop=1,devs=3,.x=.data[[denom]]),
           LCL=LCL_function(ref=Centerline,pop=1,devs=3,.x=.data[[denom]])) %>%
    filter(TRUE)
}

# Control chart meant to interact with above output
control_chart_plot<-function(data,x_axis,y_axis,lag_points=NULL) {
  data %>%
    ggplot(aes(x={{x_axis}}),group=PLOT_END) +
    geom_ribbon(aes(x={{x_axis}},ymax=UCL,ymin=LCL,fill='Common variation',group=PLOT_END),alpha=.4,inherit.aes=FALSE) +
    geom_line(aes(y=Centerline,color='Centerline',group=PLOT_END)) +
    geom_hline(yintercept = 0,color='darkgrey') +
    {if(is.null('{{lag_points}}')) geom_point(aes(y={{y_axis}},color='Observation'))} +
    {if(!is.null('{{lag_points}}')) list(geom_point(aes(y={{y_axis}},color='Observation',shape={{lag_points}}),fill='white'),
                                         scale_shape_manual(values=c('TRUE'=21,'FALSE'=19),name=NULL,guide=NULL))} +
    scale_color_manual(values=c('Observation'='darkblue','Centerline'='darkred'),name=NULL,
                       guide=guide_legend(override.aes = list(shape = c(NA,19),
                                                              linetype=c('solid','blank')))) +
    scale_fill_manual(values=c('Common variation'='darkgrey'),name=NULL) +
    theme_minimal() +
    theme(legend.position = 'top',
          legend.key = element_rect(colour = NA,fill=NA),
          legend.box.background = element_blank(),
          legend.justification = 'left',
          plot.title.position = 'plot',
          plot.caption=element_text(hjust=0),
          axis.title = element_blank()) +
    scale_y_continuous(labels=percent_format())
}
