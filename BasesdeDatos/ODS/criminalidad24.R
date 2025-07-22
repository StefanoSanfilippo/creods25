library(dplyr)
library(stringr)
#library(tidyr)
library(readxl)

# https://estadisticasdecriminalidad.ses.mir.es/publico/portalestadistico/datos.html?type=pcaxis&path=/DatosBalanceAnt/20244/&file=pcaxis

# Portal criminalidad: https://estadisticasdecriminalidad.ses.mir.es/publico/portalestadistico/balances.html

criminalidad24 <- read_xlsx("BasesdeDatos/ODS16/1409012.xlsx",
                          skip = 6)

criminalidad <- criminalidad24 |> 
    mutate(Municipio= ...1) %>% 
    filter(grepl("^03|^12|^46", Municipio)) %>% 
    mutate(ine= str_sub(Municipio,1,5),
           Municipio= str_sub(Municipio,7,100)) %>% 
    select(4,3,2) %>% 
    rename(Crim.Convencional.2024= `I. CRIMINALIDAD CONVENCIONAL`)
    
    
    
 writexl::write_xlsx(criminalidad, "BasesdeDatos/ODS16/criminalidad.xlsx")