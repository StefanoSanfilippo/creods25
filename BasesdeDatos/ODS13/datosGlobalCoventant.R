library(dplyr)
library(stringr)
library(tidyr)
library(httr)


# Bases de datos de proyectos y firmantes de la UE
# https://data.jrc.ec.europa.eu/dataset/b425918f-53a1-495c-8619-cd370c302eb0

url <- 'https://jeodpp.jrc.ec.europa.eu/ftp/public/JRC-OpenData/GCOM-MyCovenant/2023_Fourth_release/df1_Signatories_4th%20Release%20-%20March%202023.xlsx'

GET(url, write_disk(tf <- tempfile(fileext = ".xlsx")))

dfGC <- readxl::read_xlsx(tf, sheet = 3) |> 
    filter(coordinator_name %in% c("Province of Castellon", 
                                   "Diputació de València", 
                                   "Province of Alicante")) |> 
    select(1,2,3,5,7,8)

# Obtener base de datos de padrón municipal por años y sexo del Banco de Datos Territorial GVA

url2 <- "https://bdt.gva.es/bdt/res_optimo_static.php?cons=C1V4873&idioma=cas&form=xlsx"

GET(url2, write_disk(tf2 <- tempfile(fileext = ".xlsx")))

municipios <- readxl::read_xlsx(tf2,
                                skip = 7) |> 
    select(1,68,71,77,80) |> 
    filter(grepl("^03|^12|46", ...1)) |> 
    rename(Municipio= ...1) |> 
    mutate(ine= str_sub(Municipio, 1,5),
           Municipio= str_sub(Municipio, 9,100)) |> 
    select(6, 1:5) |> 
    mutate_at(.vars = c(3:6), as.integer) |> 
    filter(ine != "12066") |> 
    select(1,2)

mun_bar <- municipios |> 
    # filter(grepl("/", Municipio)) |> 
    mutate(mun1= str_sub(str_extract(Municipio, "(.*?)\\/"), end= -2),
           mun2= str_sub(str_extract(Municipio, "/.*"), start= 2)) |> 
    pivot_longer(cols = c(2,3,4)) |> 
    rename(Municipio= value) |> 
    mutate(Municipio= tolower(Municipio),
           Municipio= stringi::stri_trans_general(Municipio, "Latin-ASCII"),
           Municipio= sub("^l'(.*)", "\\1 l'", Municipio),
           Municipio= gsub("'", "", Municipio),
           Municipio= gsub("`", "", Municipio),
           Municipio= gsub("´","", Municipio),
           Municipio= gsub(",", "", Municipio),
           Municipio= gsub("\\(", "", Municipio),
           Municipio= gsub(")", "", Municipio),
           Municipio= trimws(Municipio, "both"))

dfGCclean <- dfGC |> 
    rename(Municipio= organisation_name) |> 
    mutate(Municipio= tolower(Municipio),
           Municipio= stringi::stri_trans_general(Municipio, "Latin-ASCII"),
           Municipio= sub("^l'(.*)", "\\1 l'", Municipio),
           Municipio= gsub("'", "", Municipio),
           Municipio= gsub("`", "", Municipio),
           Municipio= gsub("´","", Municipio),
           Municipio= gsub(",", "", Municipio),
           Municipio= gsub("\\(", "", Municipio),
           Municipio= gsub(")", "", Municipio),
           Municipio= sub("^la (.*)", "\\1 la", Municipio),
           Municipio= sub("^el (.*)", "\\1 el", Municipio),
           Municipio= sub("^les (.*)", "\\1 les", Municipio),
           Municipio= sub("^los (.*)", "\\1 los", Municipio),
           Municipio= sub("^els (.*)", "\\1 els", Municipio),
           Municipio= trimws(Municipio, "both")) |> 
    mutate(Municipio= case_match(Municipio,
                                 "castellon de la plana"~ "castello de la plana",
                                 "alcocer de planes"~ "alcosser",
                                 "alqueria de aznar"~ "alqueria dasnar l",
                                 "facheca"~ "fageca",
                                 "polop de la marina"~ "polop",
                                 "torrent vlc"~ "torrent",
                                 "vall de gallinera la"~ "vall de gallinerala",
                                 "real de gandia"~ "real de gandia el",
                                 "barraca daigues vives la"~ "alzira",
                                 "benisano"~ "benissano",
                                 "villanueva de castellon"~ "castello",
                                 "puig de santa maria"~ "puig de santa maria el",
                                 "genoves"~ "genoves el",
                                 "algimia de alfara"~ "algimia dalfara",
                                 "perello el"~ "sueca",
                                 "oliva valencia"~ "oliva",
                                 "novetle / novele"~ "novetle",
                                 .default = as.character(Municipio)
    ))

municipiosGCM <- dfGCclean[, c(1,2)] |> 
    left_join(mun_bar) |> 
    filter(!is.na(ine)) |> 
    distinct(ine, .keep_all = TRUE) |> 
    select(3,2)

writexl::write_xlsx(municipiosGCM, "BasesdeDatos/ODS13/datosGlobalCoventant.xlsx")
