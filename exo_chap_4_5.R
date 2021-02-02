library(tidyverse)
library(tictoc)
# Import the two datasets

table_1 = read_csv(file = 'data/table_1.csv')
table_2 = read_csv(file = 'data/table_2.csv')
cities = read_csv(file = 'data/cities_loc.csv')

# Remove articles with no pmid and no DOI, and all articles before 1975
table_1 = table_1 %>%
  filter(pmid != 'null' & doi != 'null',
         !duplicated(pmid))
table_2 = table_2 %>%
  filter(pmid != 'null' & year_pub > 1975,
         !duplicated(pmid))


# Merge the two datasets, pmid is unique for each paper

final_table = left_join(table_1,table_2,by = 'pmid')
final_table = na.omit(final_table)

# Create a new variable with the number of authors for each paper

final_table = final_table %>% rowwise() %>% mutate(nb_aut = dim(str_match_all(authors,'<AUTHOR>')[[1]])[1]) 

# plot distribution for the log(number of authors +1)

plot(density(log(final_table$nb_aut+1)))

# How many papers contains 'deep learning' or 'machine learning' and 'neural network' (also with a 's' for neural networks) in their title ? Create a binary variable to save this information. What is the mean of authors for ML papers and non#ML papers ?


final_table = final_table %>%
  mutate(title = tolower(title),
         ML = ifelse(str_detect(title,'deep learning|machine learning|neural networks?'),1,0),
         has_data = ifelse(has_data == 'Y',1,0),
         oa = ifelse(oa == 'Y',1,0))

final_table = na.omit(final_table)


# Transform has_data and oa into binary variable also, what is the share of ML paper that are oa

final_table %>% group_by(ML) %>% 
  summarize(n = sum(oa)/n(),
            citation = mean(cited))

# Clean up pub_type, for simplicity just get the first type

final_table = final_table %>%
  mutate(pub_type = str_match_all(pubtype,'\\[\\"(.*?)"')[[1]][1],
         pub_type = str_replace_all(pub_type,'\\[|\\"',''))

# What is the pub type with the highest mean/sd of citation for each type of publication ? (use cited and the cleaned pub_type)


final_table %>% group_by(pub_type) %>% 
  summarize(mean = mean(cited),
            sd = sd(cited)) %>% arrange(desc(mean))

# Which are the most representative country by year ? You may want to separate rows for each authors to get all countries involved in the paper, in an authors have multiple affiliations, take the first one
# Store it in an other tibble, keep only pmid and authors, get the country for each author from the loc_cities.csv.
countries = tolower(unique(cities$country))

countries_tibble = final_table %>%
  select(pmid,authors) %>% 
  separate_rows(authors, sep = '<AUTHOR>') %>%  rowwise() %>% 
  filter(authors !="" & !str_detect(authors,'<AFFILIATION>None')) %>%
  mutate(authors = as.character(str_split(authors,'<AFFILIATION>')[[1]][2])) %>% 
  filter(!is.na(authors))



countries_tibble =  na.omit(countries_tibble) %>%
  filter(!is.na(authors) & authors != '<NA>') %>% 
  group_by(pmid) %>% 
  filter(!duplicated(authors))


tic()
countries_tibble  = countries_tibble %>%
  mutate(authors = str_replace_all(authors,' USA','United States'),
         authors = str_replace_all(authors,' UK','United Kingdom'),
         authors = str_replace_all(authors,' Korea','South Korea'),
         authors = tolower(authors)) 

countries_tibble = countries_tibble %>% filter(any(str_detect(authors,countries)))
countries_tibble = countries_tibble %>% rowwise() %>%
  mutate(country = countries[str_detect(authors,countries)][1]) %>% select(-authors)
toc()
#236878
  
countries_tibble = left_join(countries_tibble,final_table[,c('pmid','year_pub')],by = 'pmid')
countries_tibble = countries_tibble[!duplicated(countries_tibble),]
#101244

countries_pub = countries_tibble %>% group_by(country,year_pub) %>% summarize(n = length(unique(pmid))) %>% arrange(desc(n))

# Get the top 25 of countries involved in coronavirus research since 2001, plot the evolution on a bar chart with plot_ly

wide_countries = countries_pub %>% tidyr::spread(key = 'country',value = 'n',fill  = 0) %>% filter(year_pub>2000)

countries_to_plot = names(sort(apply(wide_countries %>% select(-c('year_pub','<NA>')), FUN = sum, MARGIN = 2),decreasing = T)[1:25])



# Graph
library(plotly)

fig = plot_ly(wide_countries, x = ~year_pub, type = 'bar')
for(i in countries_to_plot[1:3]){
fig <- fig %>% add_trace(y = ~as.matrix(wide_countries[i]), name = as.character(i))}
fig <- fig %>% layout(yaxis = list(title = 'Count'), barmode = 'stack')

########

library(data.table)
library(stringr)
library(tictoc)
# Import the two datasets 
setwd('C:/Users/Beta/Documents/GitHub/M1_TDP')

table_1 = fread(file = 'data/table_1.csv')
table_2 = fread(file = 'data/table_2.csv')
cities = fread(file = 'data/cities_loc.csv')

setDT(table_1)
setDT(table_2)

# Remove articles with no pmid and no DOI, and all articles before 1975
table_1 = table_1[pmid != 'null' & doi != 'null' & !duplicated(pmid)]
table_2 = table_2[pmid != 'null' & year_pub > 1975 & !duplicated(pmid)]

# Merge the two datasets, pmid is unique for each paper

final_table = table_1[table_2, on = 'pmid']
setDT(final_table)

# Create a new variable with the number of authors for each paper

final_table[,nb_aut := dim(str_match_all(authors,'<AUTHOR>')[[1]])[1],by = 'pmid']

# plot distribution for the log(number of authors +1)

plot(density(log(final_table$nb_aut+1)))

# How many papers contains 'deep learning' or 'machine learning' and 'neural network' (also with a 's' for neural networks) in their title ? Create a binary variable to save this information. What is the mean of authors for ML papers and non#ML papers ?

final_table[,'title' := .(tolower(title)),by = 'pmid'
            ][,c('ML','has_data','oa') := .(ifelse(str_detect(title,'deep learning|machine learning|neural networks?'),1,0),
                                            ifelse(has_data == 'Y',1,0),
                                            ifelse(oa == 'Y',1,0)),by = 'pmid']

final_table = na.omit(final_table)


# Transform has_data and oa into binary variable also, what is the share of ML paper that are oa

final_table[,.(sum(as.numeric(oa))/.N,mean(cited)), by = ML]

# Clean up pub_type, for simplicity just get the first type

final_table[,pub_type := str_match_all(pubtype,'\\[""(.*?)""')[[1]][1],by = 'pmid']
final_table[,pub_type := str_replace_all(pub_type,'\\[|""',''), by = 'pmid']

# What is the pub type with the highest mean/sd of citation for each type of publication ? (use cited and the cleaned pub_type)


final_table[, .(mean(cited),sd(cited)),by='pub_type'][order(V1)]

# Which are the most representative country by year ? You may want to separate rows for each authors to get all countries involved in the paper, in an authors have multiple affiliations, take the first one
# Store it in an other tibble, keep only pmid and authors 
countries = tolower(unique(cities$country))

countries_tibble = final_table[,.(authors_ = unlist(tstrsplit(authors, "<AUTHOR>"))),by = 'pmid'
                               ][authors_ != ''& !str_detect(authors_,'<AFFILIATION>None')
                                 ][,.(authors = strsplit(authors_,'<AFFILIATION>')[[1]][2]), by = c('pmid','authors_')
                                   ][,!'authors_']

countries_tibble = countries_tibble[!is.na(authors)][!duplicated(authors),,by='pmid']


countries_tibble = countries_tibble[,.(authors=str_replace_all(authors,' USA','United States'),pmid=pmid)
                                    ][,.(authors=str_replace_all(authors,' UK','United Kingdom'),pmid=pmid)
                                      ][,.(authors=str_replace_all(authors,' Korea','South Korea'),pmid=pmid)
                                        ][,.(authors = tolower(authors),pmid=pmid)]

countries_tibble[,is_matched := .(ifelse(any(str_detect(authors,countries)),1,0)),by=c('pmid','authors')]
countries_tibble = countries_tibble[is_matched == 1]
countries_tibble[,country := .(countries[str_detect(authors,countries)][1]),by = c('pmid','authors')]



countries_tibble = countries_tibble[final_table[,c('pmid','year_pub')],on = 'pmid']
countries_tibble = countries_tibble[!duplicated(countries_tibble[,c('pmid','country','year_pub')]) & !is.na(is_matched),]
#101244

countries_pub = countries_tibble[,.(length(unique(pmid))),by=c('country','year_pub')]

# Get the top 25 of countries involved in coronavirus research since 2001, plot the evolution on a bar chart with plot_ly

wide_countries = countries_pub %>% tidyr::spread(key = 'country',value = 'n',fill  = 0) %>% filter(year_pub>2000)

countries_to_plot = names(sort(apply(wide_countries %>% select(-c('year_pub','<NA>')), FUN = sum, MARGIN = 2),decreasing = T)[1:25])
