#looking at soils data

setwd("C:/Sarah/University of Idaho/Courses/Fall 2025/Reproducible Data Science/Tasmania_Soil/raw")

library("dplyr")

dat <- read.csv("NatSoils_filtered.csv")

length(unique(dat$unique_ID)) #97
length(dat$unique_ID)

#dup <- dat[duplicated(dat$unique_ID),]

#twonine <- dat[dat$unique_ID == 29, ]

length(unique(dat$seqID)) #97
length(dat$seqID)

length(unique(dat$date_sampled)) #33
length(dat$seqID) #97


length(unique(dat$pedon_ID)) #55

filtered <- dat[dat$pedon_ID == '31',]

#filter out new tables
ped <- dat[unique(dat$pedon_ID),]
length(unique(ped$location))

write.csv(ped, "ped_id.csv")


#group by unique id
