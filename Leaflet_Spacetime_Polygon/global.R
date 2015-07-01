
#Bring in libraries
library(data.table)
library(leaflet)
library(shiny)
library(maptools)

#Set working directory
setwd("~/ShinyApps/Leaflet_Spacetime_Polygon")

#Bring in map
usa <- readRDS("A.us_states_topojson.rds")

#Bring in some fake data
data.val <- data.table(usa@data,keep.rownames=T)
data.val[, val1 := rnorm(nrow(data.val))]
data.val[, val2 := rnorm(nrow(data.val))]
data.val[, val3 := rnorm(nrow(data.val))]
data.val[, met1 := rnorm(nrow(data.val))]
data.val[, met2 := rnorm(nrow(data.val))]
data.val[, met3 := rnorm(nrow(data.val))]

#Bind data to map objects
temp.data <- as.data.frame(data.val)
row.names(temp.data) <- temp.data$rn
out.map <- spCbind(usa,temp.data)

key.var <- "val1"
act_val <- get(key.var,out.map@data)
pop_char <- paste0(
      "<strong>",
      as.character(out.map$id),
      "</strong>", 
      "</br>",
      key.var,": ",
      round(act_val,3))

leaflet(out.map) %>% 
  addPolygons(stroke=FALSE,fillOpacity=0.5,
      smoothFactor=0.5,color = ~colorQuantile("YlOrRd", act_val)(act_val),
      popup=pop_char)
                                 
