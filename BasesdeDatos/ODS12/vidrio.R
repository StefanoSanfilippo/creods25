library(dplyr)
library(stringr)
library(readxl)

# Bajada de archivos de: https://www.ecovidrio.es/reciclaje/datos-reciclaje
# No se pueden leer los ficheros directamente

vidrioAl <- read_xlsx("BasesdeDatos/ODS12/Datos recogida envases vidrio Al.xlsx") |> 
    filter(Año== 2023)
vidrioCas <- read_xlsx("BasesdeDatos/ODS12/Datos recogida envases vidrio Cas.xlsx") |> 
    filter(Año== 2023)
vidrioVal <- read_xlsx("BasesdeDatos/ODS12/Datos recogida envases vidrio Val.xlsx") |> 
    filter(Año== 2023)

vidrio <- rbind(vidrioAl,vidrioCas,vidrioVal)
names(vidrio) <- make.names(names(vidrio))

writexl::write_xlsx(vidrio, "BasesdeDatos/ODS12/vidrio.xlsx")
