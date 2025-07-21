library(dplyr)
library(stringr)
library(httr)
library(readxl)


# Banco de datos territorial: https://bdt.gva.es/bdt


# Dataset de Densidad (hab/km2)
url <- "https://bdt.gva.es/bdt/res_optimo_static.php?cons=C0V6449&idioma=cas&form=xlsx"

GET(url, write_disk(tf <- tempfile(fileext = ".xlsx")))

densidad <- read_xlsx(tf,
                      skip = 8,
                      col_names = TRUE) |> 
    filter(grepl("^03|^12|^46", ...1)) |> # Fintrar los municipios
    rename(Municipio= ...1) |> 
    mutate(ine= str_sub(Municipio, 1,5),
           Municipio= str_sub(Municipio,9,100),
           Municipio= case_when(Municipio== "Gátova (desde 1996)"~ "Gátova",
                                .default = as.character(Municipio))) |> 
    filter(ine!= "12066")


writexl::write_xlsx(densidad, "BasesdeDatos/Demografia/densidad2024.xlsx")
