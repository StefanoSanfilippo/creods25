library(httr)
library(dplyr)
library(stringr)
library(readxl)


# Obtención de datos de Desempleados del portal: https://labora.gva.es/va/estadisticassispehtml

# Parados a 31/12/2024


urlParados24 <- 'https://labora.gva.es/documents/166000883/177120029/Demandantes+activos+parados+por+municipios+%28XLSX%29.xlsx/5711e6e4-4c3b-48ee-aa39-7f5dee3d804b'
GET(urlParados24, write_disk(tf <- tempfile(fileext = ".xlsx")))
df <- read_xlsx(tf,
                skip = 8, 
                col_names = FALSE) |> 
    select(2,5) |> 
    rename(Municipio= ...2,
           Demandantes= ...5) |> 
    filter(grepl("^03|^12|46", Municipio)) |> 
    mutate(ine= str_sub(Municipio, 1, 5),
           Municipio= str_sub(Municipio, 7,100)) |> 
    select(3,1,2)


writexl::write_xlsx(df, "BasesdeDatos/ODS8/datosParo2024.xlsx")

# Parados menores de 25 años

df1 <- read_xlsx(tf,
                 sheet = 4, # En esta hojas hay datos por categorías de edad
                 skip = 8,
                 col_names = FALSE) |>
    select(2,3) |> 
    rename(Municipio= ...2,
           Parados= ...3) |> 
    filter(grepl("^03|^12|46", Municipio)) |> 
    mutate(ine= str_sub(Municipio, 1, 5),
           Municipio= str_sub(Municipio, 7,100),
           Parados= as.integer(Parados)) |> 
    select(3,1,2)


writexl::write_xlsx(df1, "BasesdeDatos/ODS8/datosParoJuvenil2024.xlsx")


