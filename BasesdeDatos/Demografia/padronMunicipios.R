library(dplyr)
library(stringr)
library(httr)

# Obtener base de datos de padrón municipal por años y sexo del Banco de Datos Territorial GVA

url <- "https://bdt.gva.es/bdt/res_optimo_static.php?cons=C1V4873&idioma=cas&form=xlsx"

GET(url, write_disk(tf <- tempfile(fileext = ".xlsx")))

padron_19_24 <- readxl::read_xlsx(tf,
                                  skip = 7) |> 
    select(1,68,71,74,77,80,83) |> 
    filter(grepl("^03|^12|46", ...1)) |> 
    rename(Municipio= ...1) |> 
    mutate(ine= str_sub(Municipio, 1,5),
           Municipio= str_sub(Municipio, 9,100)) |> 
    select(8, 1:7) |> 
    mutate_at(.vars = c(3:8), as.integer) |> 
    mutate(Municipio= case_when(Municipio=="Gátova (desde 1996)"~ "Gátova",
                                .default = as.character(Municipio))) |> 
    filter(ine!= '12066')

writexl::write_xlsx(padron_19_24,"BasesdeDatos/Demografia/padronMunicipios.xlsx")
