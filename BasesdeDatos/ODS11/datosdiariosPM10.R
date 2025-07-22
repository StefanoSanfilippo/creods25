library(dplyr)
library(stringr)

# DATOS DE 2022
download.file(url = "https://www.miteco.gob.es/content/dam/miteco/es/calidad-y-evaluacion-ambiental/sgalsi/atm%C3%B3sfera-y-calidad-del-aire/evaluaci%C3%B3n-2022/Datos%20diarios%202022.zip",
              destfile = file.path("datosdiarios2022.zip"))

datosPM10cva2022 <- read.table(unz("datosdiarios2022.zip", "Datos diarios 2022/PM10_DD_2022.csv"), 
                               sep = ";", 
                               header = TRUE) %>% 
    mutate(PROVINCIA= str_pad(as.character(PROVINCIA), width=2, side="left", pad="0"), # 0 padding
           MUNICIPIO= str_pad(as.character(MUNICIPIO), width=3, side="left", pad="0"), # 0 padding
           MES= str_pad(as.character(MES), width=2, side="left", pad="0"), # 0 padding
           ine= paste0(PROVINCIA,MUNICIPIO)) |> # codigo ine municipio
    select(39,1:38) |> 
    filter(PROVINCIA %in% c("03", "12", "46")) # filtrado de estaciones de la CVA

# DATOS DE 2023
download.file(url = "https://www.miteco.gob.es/content/dam/miteco/es/calidad-y-evaluacion-ambiental/sgalsi/atm%c3%b3sfera-y-calidad-del-aire/evaluaci%c3%b3n-2023/Datos%20diarios%202023.zip",
              destfile = file.path("datosdiarios2023.zip")) 

datosPM10cva2023 <- read.table(unz("datosdiarios2023.zip", "Datos diarios 2023/PM10_DD_2023.csv"), 
                               sep = ";", 
                               header = TRUE) %>% 
    mutate(PROVINCIA= str_pad(as.character(PROVINCIA), width=2, side="left", pad="0"), # 0 padding
           MUNICIPIO= str_pad(as.character(MUNICIPIO), width=3, side="left", pad="0"), # 0 padding
           MES= str_pad(as.character(MES), width=2, side="left", pad="0"), # 0 padding
           ine= paste0(PROVINCIA,MUNICIPIO)) |> # codigo ine municipio
    select(39,1:38) |> 
    filter(PROVINCIA %in% c("03", "12", "46")) # filtrado de estaciones de la CVA

# Para interpretación variables ver el archivo metainformación2022.xlsx

writexl::write_xlsx(datosPM10cva2023, "BasesdeDatos/ODS11/datosPM10cva2023.xlsx")



