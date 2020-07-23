
raccoon <- read.csv('/home/matt/Downloads/gps_data (2).csv')
library(lubridate)

raccoon <- read.csv('/home/matt/Downloads/gps_data_animals (1).csv')
raccoon <- raccoon[,c('animals_code','acquisition_time','longitude','latitude','fix')]
colnames(raccoon)[2] <- 'timestamp'
colnames(raccoon)[1] <- 'animal_id'

raccoon <- raccoon[,c('animal_id','timestamp','longitude','latitude','fix')]
write.csv(raccoon, '/home/matt/Downloads/raccoon_data.csv', row.names=F)

raccoon <- read.csv('/home/matt/Downloads/raccoon_data.csv')

raccoon$timestamp <- ymd_hms(raccoon$timestamp)
my_sftrack <- as_sftrack(raccoon, burst = 'animal_id', coords = c('longitude','latitude'),
                         time = 'timestamp', crs = wsg, zeroNA=TRUE)
plot(my_sftrack,graticule = TRUE,axes = TRUE)

my_sftrack <- my_sftrack[c('TTP-058','TTP-041'),]
my_sftrack <- my_sftrack[!st_is_empty( my_sftrack),]
plot(my_sftrack,graticule = TRUE,axes = TRUE)

utm_17 <- '+proj=utm +zone=17 +ellps=WGS84 +datum=WGS84 +units=m +no_defs'
my_sftrack <- st_transform(my_sftrack, crs = utm_17)
head(my_sftrack)
step_calc <- step_metrics(my_sftrack)
head(step_calc)
summary(step_calc)
new <- my_sftrack[step_calc$dist<200 & !is.na(step_calc$speed),]
plot(my_sftrack[step_calc$dist<200 & !is.na(step_calc$speed),],graticule = TRUE,axes = TRUE)



