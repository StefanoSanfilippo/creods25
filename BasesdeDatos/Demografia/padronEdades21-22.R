library(dplyr)
library(stringr)
library(tidyr)
library(httr)

# Obtener base de datos del padrón municipal por años  del Banco de Datos Territorial GVA

url <- "https://bdt.gva.es/bdt/res_optimo_static.php?cons=C2V9104&idioma=cas&form=xlsx"

GET(url, write_disk(tf <- tempfile(fileext = ".xlsx")))

padronBruto <- readxl::read_xlsx(tf,
                                 skip = 9)
padronEdades_21_22 <- padronBruto |> select(1,1586:1717)
edades_21 <- padronEdades_21_22 |> select(1:23)
edades_22 <- padronEdades_21_22 |> select(1, 68:89)

names(edades_21)[2:23] <- edades_21[1, 2:23]

names(edades_22)[2:23] <- edades_22[1, 2:23]

edades21 <- edades_21 |> 
    slice(-1) |> 
    filter(grepl("^03|^12|46", ...1)) |> 
    rename(Municipio= ...1) |> 
    mutate(ine= str_sub(Municipio, 1,5),
           Municipio= str_sub(Municipio, 9,100)) |> 
    select(24, 1:23) |> 
    mutate_at(.vars = c(3:24), as.integer) |> 
    filter(ine != '12066') |> 
    pivot_longer(3:24, names_to = 'Edad', values_to = '2021')

edades22 <- edades_22 |> 
    slice(-1) |> 
    filter(grepl("^03|^12|46", ...1)) |> 
    rename(Municipio= ...1) |> 
    mutate(ine= str_sub(Municipio, 1,5),
           Municipio= str_sub(Municipio, 9,100)) |> 
    select(24, 1:23) |> 
    mutate_at(.vars = c(3:24), as.integer) |> 
    filter(ine != '12066') |> 
    pivot_longer(3:24, names_to = 'Edad', values_to = '2022')

edades21_22 <- edades21 |> inner_join(edades22, by= c('ine', 'Edad'))|> 
    select(1,2,3,4,6) |> 
    rename(Municipio= Municipio.x)


writexl::write_xlsx(edades21_22,"BasesdeDatos/Demografia/padronEdades21-22.xlsx")
