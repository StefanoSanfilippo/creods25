#===============================================================
# LECTURA DATOS MUNIPALES CENSO DE POBLACIÓN AÑO A AÑO 2021-2024 
#===============================================================

library(dplyr)
library(stringr)
library(tidyverse)
library(readr)
library(readxl)

# ===============================
# ORIGEN DATOS
# Censo Anual de Población
#--------------------------------
# URL página general
# https://www.ine.es/dynt3/inebase/index.htm?padre=10607&capsel=10607
# URL para la descarga
# https://www.ine.es/jaxiT3/files/t/es/xlsx/68542.xlsx?nocab=1

#================================


a <- readxl::read_xlsx("BasesdeDatos/Demografia/Padron_Anyo-Anyo/68542.xlsx",
                       range = "A8:A8194")

b <- readxl::read_xlsx("BasesdeDatos/Demografia/Padron_Anyo-Anyo/68542.xlsx",
                       range = "AEL8:AUC8194")

ab <- cbind(a,b)

ab <- ab %>% 
    filter(grepl("^03|^12|^46",...1), # filtrar registro provincias CV
           grepl('\\D*(\\d{5}).*', ...1)) # filtrar registros que contienen 5 dígitos

col_2024 <- seq(2,409,4) # La sequencia de columnas es 2024, 2023, 2022 2021 
col_2023 <- seq(3,410,4)


pob_2024 <- ab %>% select(1, all_of(col_2024))
pob_2023 <- ab %>% select(1, all_of(col_2023))

nombres <- c("Municipio","Total",paste(as.character(0:99),"años"), "100 y más años")
names(pob_2024) <- nombres
names(pob_2023) <- nombres

pob_2024 <- pob_2024 %>% 
    mutate(ine= str_sub(Municipio, 1, 5),
       Municipio= str_sub(Municipio, 7, 100)) |> 
    select(104, 1:103) %>% 
    mutate(across(3:104, as.integer))

writexl::write_xlsx(pob_2024, 
                    "BasesdeDatos/Demografia/Padron_Anyo-Anyo/Municipios24_AnyoAnyo.xlsx")

pob_2023 <- pob_2023 %>% 
    mutate(ine= str_sub(Municipio, 1, 5),
           Municipio= str_sub(Municipio, 7, 100)) |> 
    select(104, 1:103) %>% 
    mutate(across(3:104, as.integer))

writexl::write_xlsx(pob_2023, 
                    "BasesdeDatos/Demografia/Padron_Anyo-Anyo/Municipios23_AnyoAnyo.xlsx")
