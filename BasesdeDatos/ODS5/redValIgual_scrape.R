library(dplyr)
library(stringr)
library(tabulapdf)

# Dirección Red valenciana de igualdad
# "https://inclusio.gva.es/es/web/igualtat-i-institut-de-les-dones/xarxa-valenciana-d-igualtat")

# Dirección documento pdf a descargar
# "https://inclusio.gva.es/documents/383153989/0/Listado+Municipios_RED+VALENCIANA+DE+IGUALDAD+%281%29.pdf/e3af6f6f-9fb3-6f18-9d25-3914d6f101bf?t=1724415652484"

RVI1 <- readxl::read_xls(
    "BasesdeDatos/ODS5/Listado Municipios_RED VALENCIANA DE IGUALDAD (1) conv.xls",
    sheet = 1,
    skip = 3) %>% 
    select(1,6,13)
RVI2 <- readxl::read_xls(
    "BasesdeDatos/ODS5/Listado Municipios_RED VALENCIANA DE IGUALDAD (1) conv.xls",
    sheet = 2) %>% 
    select(1,3,5)
RVI3 <- readxl::read_xls(
    "BasesdeDatos/ODS5/Listado Municipios_RED VALENCIANA DE IGUALDAD (1) conv.xls",
    sheet = 3) %>% 
    select(1,3,5)

RVI <- rbind(RVI1,RVI2,RVI3) %>% 
    filter(!is.na(`Ayuntamiento/Mancomunidad`)) %>% 
    rename(Ayuntamiento.Mancomunidad=`Ayuntamiento/Mancomunidad`) %>% 
    mutate(Ayuntamiento.Mancomunidad= case_match(Ayuntamiento.Mancomunidad,
        "L'Alcoià y el Comtat-\nMancomunidad" ~
            "Mancomunitat \"L'Alcoià i El Comtat\"",
        "Alt Maestrat-Mancomunidad"~
            "Mancomunitat \"Alt Maestrat\"",
        "Alt Palància-Mancomunidad" ~
            "Mancomunidad Intermunicipal del Alto Palancia",
        "Baix Maestrat-Mancomunidad" ~
            "Mancomunidad \"Baix Maestrat\"",
        "Bajo Segura-Mancomunitat" ~
            "Mancomunidad de Municipios \"Bajo Segura\"",
        "Carraixet-Mancomunidad" ~
            "Mancomunitat del Carraixet",
        "Costera Canal-Mancomunidad" ~
            "Mancomunidad \"La Costera-Canal\"",
        "Els Ports - Mancomunidad" ~
            "Mancomunidad Comarcal Els Ports",
        "Espadán Mijares-\nMancomunidad" ~
            "Mancomunidad Espadán-Mijares",
        "Horta Nord-Mancomunidad" ~
            "Mancomunitat L'Horta Nord",
        "Horta Sud-Mancomunidad" ~
            "Mancomunidad Intermunicipal de L'Horta Sud",
        "Hoya-Chiva-Mancomunidad" ~
            "Mancomunidad Intermunicipal Hoya de Buñol-Chiva",
        "Interior Tierra del Vino-\nMancomunidad" ~
            "Mancomunidad del Interior Tierra del Vino",
        "Mancomunitat Camp de Túria" ~
            "Mancomunidad Camp de Túria",
        "Mancomunidad de Municipios\nLa Safor" ~
            "Mancomunitat de Municipis de la Safor",
        "La Serrania-Mancomunidad" ~
            "Mancomunidad \"La Serranía\"",
        "La Vall d'Albaida -\nMancomunidad" ~
            "Mancomunitat de Municipis de la Vall d'Albaida",
        "La Vega - Mancomunidad" ~
            "Mancomunidad La Vega",
        "Marina Alta-Mancomunidad" ~
            "Mancomunitat comarcal Marina Alta",
        "Marina Baixa-Mancomunidad" ~
            "Mancomunidad de Servicios Sociales y de Carácter Cultural de Callosa d'En Sarrià, Polop, Tàrbena, Bolulla, Benimantell, Confrides, el Castell de Guadalest, Benifato y Beniardá",
        "Plana Alta - Mancomunidad" ~
            "Mancomunitat \"Plana Alta\"",
        "Ribera Alta-Mancomunidad" ~
            "Mancomunitat comarcal de la Ribera Alta",
        "Ribera Baixa-Mancomunidad" ~
            "Mancomunitat de la Ribera Baixa",
        "Xarpolar-Mancomunidad" ~
            "Mancomunitat \"El Xarpolar\"",
        .default = as.character(Ayuntamiento.Mancomunidad)
    ))


writexl::write_xlsx(RVI, "BasesdeDatos/ODS5/RVI.xlsx")
