library("rmarkdown")
setwd('FichasMunicipales')

slices = unique(df$Ficha)

for(v in slices){
    render("ficha_mod.Rmd",
           output_file=paste0(v, ".html"),
           params=list(new_subtitle=paste("Código INE: ", str_sub(v,1,5))))
}
