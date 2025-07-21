# Comarcas y municipios Comunitat Valenciana extrción de BBDD con codigos de municipio y de comarca
# El listado completo con los código de comarca no se encuentran en formato csv o xls..., hay que
# "rascarlos" direcamente de la Web de la gva (ver dirección abajo).


library(dplyr)
    
com <- rvest::html_table(rvest::read_html("https://pegv.gva.es/es/comarques"),fill = TRUE)


nomV <- c('Nivel','ine', 'Municipio')

com2 <- lapply(com, setNames, nm= nomV)

com3 <- lapply(com2, function(x) {
    mutate(x,
           Comarca= Municipio[1],
           codCom= ine[1])
    })
com4 <- lapply(com3, function(x) x[-1, ])


com5 <- bind_rows(com4, .id = "column_label") |> 
    mutate(ine= as.character(ine),
           codCom= as.character(codCom))

dfcom <- com5 |> 
    mutate(ine= as.character(ine),
               codCom= as.character(codCom)) |> 
    mutate(ine= str_pad(ine,width= 5, side = "left", pad = "0"))


writexl::write_xlsx(dfcom[, -c(1,2)], "BasesdeDatos/Demografia/comarcasVal.xlsx")

