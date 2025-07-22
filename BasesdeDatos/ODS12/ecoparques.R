# Libraries
library(rvest)
library(dplyr)
library(stringr)
library(RSelenium)
library(wdman)
library(netstat)

# Connect to Selenium
driver_object <- rsDriver(browser = "firefox",
                          chromever=NULL,
                          verbose = FALSE,
                          port = free_port())

remDr <- driver_object$client
# OBRIR
remDr$open()

# ECOPARQUES COMUNIDAD VALENCIANA

url <- 'https://residuos.gva.es/RES_BUSCAWEB/buscador_residuos_avanzado.aspx?idioma=C'
remDr$navigate(url)

# Dropdown ECOPARQUES

xpath_dropdown <- '/html/body/form/div[3]/div/div[1]/div/div/div/div[1]/div[1]/div/select/option[4]'
# xpath_dropdown <- '/html/body/form/div[3]/div/div[1]/div[2]/div[1]/div[1]/div[1]/div/select/option[4]'
opt_eco <- remDr$findElement(using = 'xpath', xpath_dropdown)
opt_eco$clickElement()

# Botón Busca

btBuscal <- '/html/body/form/div[3]/div/div[1]/div/div/div/div[5]/div/div/a'
btBuscal <- '//*[@id="btBuscar"]'
ecopqrs <- remDr$findElement(using = 'xpath', btBuscal)
ecopqrs$clickElement()

# A partir de aquí tenemos la taula
#df <- remDr$getPageSource()[[1]] %>% 
#    read_html() %>%
#    html_table()

#df <- df[[1]][-c(1,2,13),1:7] |> 
#    as.data.frame() |> 
#    rename_with(~ c('Centro','NIMA','Tipo','AAI','Domicilio.Centro', 'Municipio', 'Provincia'),
#                all_of(c('X1','X2','X3','X4','X5','X6','X7')))



# remDr$goBack()

# Ahora debemos reiterar la tabla a lo largo de las páginas

list_tab <- function(i) {
    xpath_page <- glue::glue('/html/body/form/div[3]/div/div[2]/div[2]/div/div/div/div/div/table/tbody/tr[1]/td/div/div/div[1]/div/select/option[{i}]')
    remDr$findElement(using = 'xpath', xpath_page)$clickElement()
    remDr$getPageSource()[[1]] %>% 
        read_html() %>%
        html_table()
    
}


#pagMax <- remDr$getPageSource()[[1]] %>% 
#    read_html() %>%
#    html_node('#ctl00_ContentPlaceHolder1_gvResultados_ctl01_ddlPaginas') |> 
#    html_text() |> as.integer()

tablas <- purrr::map(1:17, list_tab)

tabBruta <- bind_rows(tablas)

tabFinal <- tabBruta |> 
    rename_with(~ c('Centro','NIMA','Tipo','AAI','Domicilio.Centro', 'Municipio', 'Provincia'),
                all_of(c('X1','X2','X3','X4','X5','X6','X7'))) |> 
    filter(Centro != "Centro") %>% 
    filter(!grepl("Página",Centro))

writexl::write_xlsx(tabFinal,"BasesdeDatos/ODS12/ecoparques.xlsx")

# TANCAR
remDr$close()

driver_object$server$stop()




