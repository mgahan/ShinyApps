
#Bring in libraries
library(maptools)
library(rgdal)
library(raster)
library(rgeos)
library(sp)
library(geojsonio)

#Set working directory
setwd("~/ShinyApps/Leaflet_Spacetime_Polygon")

#USA map
url <- "https://raw.githubusercontent.com/shawnbot/d3-cartogram/master/data/us-states.topojson"
usa <- topojson_read(url)
#plot(usa)

#Spatial projection transform
proj4string(usa) <-CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")
usa <- spTransform(usa, CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))

# extract, then rotate, shrink & move alaska (and reset projection)
# need to use state IDs via # https://www.census.gov/geo/reference/ansi_statetables.html
alaska <- subset(usa, id=="Alaska")
alaska <- elide(alaska, rotate=-30)
alaska <- elide(alaska, scale=max(apply(bbox(alaska), 1, diff)) / 2.3)
alaska <- elide(alaska, shift=c(-2100000, -2500000))
proj4string(alaska) <- proj4string(usa)
 
# extract, then rotate & shift hawaii
hawaii <- subset(usa, id=="Hawaii")
hawaii <- elide(hawaii, rotate=-35)
hawaii <- elide(hawaii, shift=c(5400000, -1400000))
proj4string(hawaii) <- proj4string(usa)

# remove old states and put new ones back in; note the different order
# we're also removing puerto rico in this example but you can move it
# between texas and florida via similar methods to the ones we just used
usa2 <- usa[!usa$id %in% c("Alaska","Hawaii"),]
usa3 <- rbind(usa2, alaska, hawaii)

#Reproject
usa3 <- spTransform(usa3, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))

#Save output
saveRDS(usa3,"A.us_states_topojson.rds")


##################################################################################


#Add fake metric
# usa3@data$Fake <- rnorm(length(usa3))
# 
# library(leaflet)
# leaflet(usa3) %>%
#   addPolygons(
#     stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
#     color = ~colorQuantile("YlOrRd", usa3$Fake)(Fake)
#   )

