#==========================================================
#DATOS EDUCATIVOS DEL CENSO ANUAL DE POBLACIÓN 2021-2023
#==========================================================

#----------------------------------------------------------
# GENERACIÓN DATOS PARA INDICADOR ODS 4
# Completamiento segunda etapa <br> de Educación Secundaria
#----------------------------------------------------------

# Lectura de ficheros Excel sobre datos del Censo anual de población (Educación) 2021-2022, generado en:
# https://www.ine.es/dynt3/inebase/es/index.htm?padre=10608&capsel=10612

#=========================================================
# LIBRERIAS
library(readxl)
library(dplyr)
library(stringr)
library(tidyr)
#=========================================================

# DATOS

#--------------------------------------------------------------------
# MUNICIPIOS DE MENOS DE 500 HABITANTES
#Nivel de estudios completados: Población de 15 y más años por sexo y 
#nivel de estudios (agrupado) (Municipios entre 50 y 500 habitantes)
#https://www.ine.es/jaxiT3/Tabla.htm?t=66623&L=0
#--------------------------------------------------------------------

menos500 <- read_xlsx("BasesdeDatos/ODS4/66623.xlsx",
                      skip = 9,
                      col_names = FALSE)

lookup <- c(Municipio="...1", Valor="...2")
menos500 <- menos500 %>% 
    filter(grepl("^03|^12|^46",...1)) %>% 
    rename(all_of(lookup)) %>% 
    mutate(ine= str_sub(Municipio,1,5),
           Municipio= str_sub(Municipio, 7,100)) %>% 
    select(3,1,2)

#--------------------------------------------------------------------
# MUNICIPIOS DE MAS DE 500 HABITANTES
#Nivel de estudios completados: Población de 15 y más años por sexo, 
#nacionalidad (española/extranjera) y nivel de estudios (detalle) (Municipios 
#de 500 habitantes o más)
#https://www.ine.es/jaxiT3/Tabla.htm?t=66622&L=0
#--------------------------------------------------------------------

mas500 <- read_xlsx("BasesdeDatos/ODS4/66622 (1).xlsx",
                     skip = 10,
                     col_names = FALSE)
lookup <- c(Municipio="...1", Educ1="...2", Educ2="...3")
mas500 <- mas500 %>% 
    filter(grepl("^03|^12|^46",...1)) %>% 
    rename(all_of(lookup)) %>% 
    mutate(ine= str_sub(Municipio,1,5),
           Municipio= str_sub(Municipio, 7,100)) %>% 
    select(4,1,2,3) %>% 
    rowwise() %>% 
    mutate(Valor= sum(c_across(3:4))) %>% 
    select(1,2,5)

educacion_secundaria <- 
    bind_rows(mas500,menos500) %>% 
    arrange(ine)

writexl::write_xlsx(educacion_secundaria, "BasesdeDatos/ODS4/educacion_secundaria.xlsx")

