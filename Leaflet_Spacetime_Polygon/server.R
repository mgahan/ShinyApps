server <- function(input, output, session) {
  
  #Make colors reactive
  colorpal <- reactive({
    key.var <- paste0(input$metrics,input$time)
    act_val <- get(key.var,out.map@data)
    colorQuantile("YlOrRd",act_val)(act_val)
  })
  
  state_popup <- reactive({
    key.var <- paste0(input$metrics,input$time)
    act_val <- get(key.var,out.map@data)
    paste0("<strong>",
           as.character(out.map$id),
           "</strong>", 
           "</br>",
           key.var,": ",
           round(act_val,3))
  })
  
  #Make initial map
  output$mymap <- renderLeaflet({
    leaflet(out.map) 
    #%>% addPolygons(stroke=T,color="black",weight=3,fillOpacity=0.5,smoothFactor=0.5)
  })  
  
  #Change proxy map
  observe({
    leafletProxy("mymap",data=out.map) %>%
      addPolygons(stroke=T,color="black",weight=3,fillOpacity=0.5,smoothFactor=0.5,
          fillColor=colorpal(),popup=state_popup())
  })
}
  