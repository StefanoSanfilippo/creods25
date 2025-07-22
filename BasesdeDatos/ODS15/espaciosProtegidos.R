library(httr)
library(dplyr)
library(stringr)
library(tidyr)

# En 2025, los datos siguen siendo los de 2021


url <- 'https://bdt.gva.es/bdt/res_optimo_static.php?cons=C1D4143&idioma=cas&form=xlsx'

GET(url, write_disk(tf <- tempfile(fileext = ".xlsx")))

espNat <- readxl::read_xlsx(tf,
                            skip = 7,
                            col_names = TRUE) |> 
    select(...1, `2021`) |> 
    filter(grepl("^03|^12|^46", ...1)) |> 
    rename(Municipio= ...1,
           ods15.espNat= `2021`) |> 
    mutate(ine= str_sub(Municipio, 1,5),
           Municipio= str_sub(Municipio, 9,100)) |> 
    select(3,1,2) |> 
    filter(ine != "12066") |> 
    mutate(ods15.espNat= as.numeric(ods15.espNat))


writexl::write_xlsx(espNat, "BasesdeDatos/ODS15/espaciosProtegidos.xlsx")


