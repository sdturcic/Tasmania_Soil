# Creating Final Project Database Using RSQLite
# Sarah Turcic
# 10/17/25

# Load Packages ####
library(DBI)
library(RSQLite)

# Connect to Database ####
soils_db <- dbConnect(drv=SQLite(),
                        "raw/nat_soils.db")

# Modify the DB ####

## Site Information Table ####

dbListTables(soils_db) #nothing yet

dbExecute(conn = soils_db,
          statement = "DROP TABLE sites;")


dbExecute(conn = soils_db, 
          statement = "CREATE TABLE sites (
                        pedon_ID varchar(5) PRIMARY KEY NOT NULL UNIQUE,
                        location varchar(30),
                        state varchar(2),
                        latitude varchar(20),
                        longitude varchar(20),
                        region varchar(20) CHECK(region IN('northeast', 
                                           'midwest', 'north central', 'west', 
                                            'north west', 'pacific coast', 'southwest', 
                                            'central', 'southeast', 'arctic')),
                        soil_order varchar(10),
                        dominant_vegetation_class varchar(30),
                        soil_moisture varchar(10) CHECK(soil_moisture IN('aquic', 'udic',
                                                  'ustic', 'xeric', 'aridic')),
                        soil_temperature_regime varchar(10) CHECK(soil_temperature_regime IN('mesic',
                                                  'frigid', 'cryic', 'thermic', 
                                                  'pergelic')),
                        elevation_m varchar(5),
                        aridity varchar(10),
                        common_vegetation text,
                        soil_family varchar(100),
                        soil_series_name varchar (20),
                        date_sampled varchar(10));")

## Sample Table ####

dbExecute(conn = soils_db,
          statement = "DROP TABLE samples;")

dbExecute(conn = soils_db,
          statement = "CREATE TABLE samples (
          seqID varchar(10) PRIMARY KEY NOT NULL UNIQUE,
          pedon_ID varchar(5),
          horizon char(1) CHECK(horizon IN('a', 'c')),
          horizon_top_inches varchar(2),
          horizon_bottom_inches varchar(5),
          horizon_middle_inches varchar (5),
          total_depth_sampled_inches varchar(5),
          mean_VWC varchar(20),
          mean_db varchar(20),
          mean_GWC varchar(20),
          mean_HWC varchar(20),
          pH numeric CHECK(pH BETWEEN 0 AND 14),
          delta13C_bulk varchar(20),
          dela15N_bulk varchar(20),
          SOC varchar(20),
          TN varchar(20),
          relative_coarse_fraction varchar(20),
          relative_fine_fraction varchar(20),
          fine_coarse_ratio varchar(20),
          C_sand_pom varchar(10),
          C_silt_clay varchar(10),
          N_sand_pom varchar(10),               
          N_silt_clay varchar(10), 
          delta15N_bulk varchar(10),
          delta15N_sand_pom varchar(10),         
          delta15N_silt_clay varchar(10),
          delta13C_sand_pom varchar(10),
          delta13C_silt_clay varchar(10),        
          Ca varchar(10),
          Mg varchar(10),
          Na varchar(10),                   
          K varchar(10),
          CEC varchar(10),
          FOREIGN KEY (pedon_ID) REFERENCES sites(pedon_ID)
          );")


# Populate the database ####

## Sites ####

#Load csv
nat_soils <- read.csv("raw/NatSoils_filtered.csv")

#create sites csv
sites_csv <- nat_soils[!duplicated(nat_soils$pedon_ID),c("pedon_ID","location", "state", "latitude",                 
                          "longitude", "region", "soil_order", "dominant_vegetation_class",
                           "soil_moisture_regime", "soil_temperature_regime", "elevation_m",               
                           "aridity","common_vegetation", "soil_family", "soil_series_name", "date_sampled")]

colnames(sites_csv)
dbListFields(conn = soils_db,
             name = "sites")

colnames(sites_csv)[9] <-"soil_moisture" #make sure all columns name match

duplicated(sites_csv$pedon_ID)

dbWriteTable(conn = soils_db, 
             name = "sites",
             value = sites_csv,
             append = TRUE)


## Samples ####

#create samples csv
samples_csv <- nat_soils[, !colnames(nat_soils) %in% c("location", "state", "latitude",                 
                                                             "longitude", "region", "soil_order", "dominant_vegetation_class",
                                                             "soil_moisture_regime", "soil_temperature_regime", "elevation_m",               
                                                             "aridity","common_vegetation", "soil_family", "soil_series_name", "date_sampled", "unique_ID")]

colnames(samples_csv)

dbWriteTable(conn = soils_db, 
             name = "samples",
             value = samples_csv,
             append = TRUE)

#check tables are in database
dbListTables(soils_db)


#