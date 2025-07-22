library(httr)
library(dplyr)
library(stringr)
library(tidyr)


url <- 'https://bdt.gva.es/bdt/res_optimo_static.php?cons=C0V6527&idioma=cas&form=xlsx'

GET(url, write_disk(tf <- tempfile(fileext = ".xlsx")))

supMunicipios <- readxl::read_xlsx(tf,
                                   skip = 7,
                                   col_names = TRUE) |> 
    filter(grepl("^03|^12|^46", ...1)) |> 
    rename(Municipio= ...1) |> 
    mutate(ine= str_sub(Municipio, 1,5),
           Municipio= str_sub(Municipio, 9,100)) |> 
    rename(supKm2= `2023`) |> 
    select(3,1,2) |> 
    filter(ine != "12066") |> 
    mutate(supKm2= as.numeric(supKm2))


writexl::write_xlsx(supMunicipios, "BasesdeDatos/ODS15/supMunicipios.xlsx")
