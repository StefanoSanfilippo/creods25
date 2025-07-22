#=============================================
# MUNICIPIOS DE LAS MANCOMUNIDADES VALENCIANAS
#=============================================

# Descarga de ficheros .xls en la web swl Ministerio de Política
# Territorial y Memoria Democrática: 
# https://ssweb.seap.minhap.es/REL/frontend/inicio/mancomunidades

# Alicant
# https://ssweb.seap.minhap.es/REL/frontend/export_data/file_export/export_excel/mancomunidades/10/13419

# Castelló
# https://ssweb.seap.minhap.es/REL/frontend/export_data/file_export/export_excel/mancomunidades/10/13420

# Valencia
# https://ssweb.seap.minhap.es/REL/frontend/export_data/file_export/export_excel/mancomunidades/10/13421



library(dplyr)
library(tidyverse)
library(stringr)
#library(httr)

# Lectura de ficheros

Manc_Al <- readxl::read_xls(
    "BasesdeDatos/ODS5/Mancomunidades/mancomunidades_export_20250324_170839.xls",
                                  skip = 8) %>% 
    select(4,5,8)
Manc_Cas <- readxl::read_xls(
    "BasesdeDatos/ODS5/Mancomunidades/mancomunidades_export_20250324_171109.xls",
    skip = 8) %>% 
    select(4,5,8)
Manc_Val <- readxl::read_xls(
    "BasesdeDatos/ODS5/Mancomunidades/mancomunidades_export_20250324_171645.xls",
    skip = 8) %>% 
    select(4,5,8)

mancomunidades_CV <- rbind(Manc_Al, Manc_Cas, Manc_Val)

mun_mancom_CV <- mancomunidades_CV %>% 
    mutate(Municipio=str_split(mancomunidades_CV$MUNICIPIOS_ASOCIADOS,"#")) %>% 
    tidyr::unnest() %>% 
    select(4,2) %>% 
    rename(Ayuntamiento.Mancomunidad= DENOMINACION)

a <- mun_mancom_CV %>% distinct(Ayuntamiento.Mancomunidad)   

writexl::write_xlsx(mun_mancom_CV, "BasesdeDatos/ODS5/Mancomunidades/mancomunidades25.xlsx")
