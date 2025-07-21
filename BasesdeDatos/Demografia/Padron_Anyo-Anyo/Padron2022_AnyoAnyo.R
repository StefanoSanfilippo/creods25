library(dplyr)
library(stringr)
library(tidyverse)
library(readr)


# Población por edad año a año
# https://www.ine.es/dynt3/inebase/index.htm?padre=6225&capsel=6225


Al <- read_xlsx("BasesdeDatos/Demografia/Padron_Anyo-Anyo/33591_Al_AnyoAnyo.xlsx", skip = 7)
names(Al)[3:103] <- Al[1, 3:103]
Al <- Al[-1,]
Al <- Al |> mutate(across(2:103, as.integer))

Cas <- read_xlsx("BasesdeDatos/Demografia/Padron_Anyo-Anyo/33757_Cas_AnyoAnyo.xlsx", skip = 7)
names(Cas)[3:103] <- Cas[1, 3:103]
Cas <- Cas[-1,]
Cas <- Cas |> mutate(across(2:103, as.integer))

Val <- read_xlsx("BasesdeDatos/Demografia/Padron_Anyo-Anyo/33949_Val_AnyoAnyo.xlsx", skip = 7)
names(Val)[3:103] <- Val[1, 3:103]
Val <- Val[-1,]
Val <- Val |> mutate(across(2:103, as.integer))

Municipios_AnyoAnyo <- rbind(Al, Cas, Val) |> 
    filter(grepl("^03|^12|46", ...1)) |> 
    rename(Municipio= ...1) |> 
    mutate(ine= str_sub(Municipio, 1, 5),
           Municipio= str_sub(Municipio, 7, 100)) |> 
    select(104, 1:103)

writexl::write_xlsx(Municipios_AnyoAnyo, "BasesdeDatos/Demografia/Padron_Anyo-Anyo/Municipios_AnyoAnyo.xlsx")
