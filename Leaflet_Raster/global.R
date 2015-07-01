

#Set working directory
setwd("~/ShinyApps/Leaflet_Raster")

#Install latest version of raster data
#install.packages('raster', repos = 'http://r-forge.r-project.org/', type = 'source')
library(raster)
library(data.table)
library(sp)
#devtools::install_github("rstudio/leaflet")
library(leaflet)
library(shiny)
library(maptools)

#Make a raster
elev.raster <- getData('alt', country='usa', mask=TRUE)
usa.raster <- elev.raster[[1]]
usa_bounds <- getData('GADM', country='usa',level=1)
il_bounds <- subset(usa_bounds,NAME_1=="Illinois")
il_bounds <- spTransform(il_bounds,proj4string(usa.raster))

#Extract shape from raster
extract_shape <- function(ras.obj,sp.obj) {
  temp <- crop(usa.raster,il_bounds,snap="out")
  out <- mask(temp,il_bounds)
  return(out)
}

#Apply function
il_elev <- extract_shape(ras.obj=usa.raster,sp.obj=il_bounds)
il_elev <- spTransform(il_elev,CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))

pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(il_elev), na.color = "transparent")

il_leaf <- leaflet() %>% addTiles() %>%
  addRasterImage(il_elev, colors = pal, opacity = 0.8) %>%
  addLegend(pal = pal, values = values(il_elev),
    title = "Elev Values")

#shinyApp(ui, server)