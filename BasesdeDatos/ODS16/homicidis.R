library(dplyr)
library(stringr)
library(tidyr)
library(readxl)

# https://estadisticasdecriminalidad.ses.mir.es/publico/portalestadistico/datos.html?type=pcaxis&path=/DatosBalanceAnt/20244/&file=pcaxis

# Portal criminalidad: https://estadisticasdecriminalidad.ses.mir.es/publico/portalestadistico/balances.html

homicidis <- read_xlsx("BasesdeDatos/ODS16/09012.xlsx",
                          skip = 6) 
names(homicidis) <- c("Municipio", "Homicidios", "Intentos")   


homicidis <- homicidis %>% 
    filter(grepl("^03|^12|^46", Municipio)) %>% 
    mutate(ine= str_sub(Municipio,1,5),
           Municipio= str_sub(Municipio,7,100)) %>% 
    select(4,1:3)
    
    


writexl::write_xlsx(homicidis, "BasesdeDatos/ODS16/homicidis.xlsx")
