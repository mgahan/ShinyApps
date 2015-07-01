server <- function(input, output, session) {
  
  output$mymap <- renderLeaflet({
      il_leaf
  })
  
  observeEvent(input$mymap_click, {
      lon.pt <- input$mymap_click[[2]]
      lat.pt <- input$mymap_click[[1]] 
      ras.val <- extract(il_elev,cbind(lon.pt,lat.pt))
      content <- paste(
          "<b>Lon:</b> ",round(lon.pt,2),
          "<br/><b>Lat:</b> ",round(lat.pt,2),
          "<br/><b>Val:</b> ",ras.val)
      
      leafletProxy("mymap", session) %>% addPopups(lon.pt, lat.pt, content,
          options = popupOptions(closeOnClick = TRUE))
  }) 

#   observeEvent(input$mymap_mouseover, {
#       lon.pt <- input$mymap_mouseover[[2]]
#       lat.pt <- input$mymap_mouseover[[1]] 
#       ras.val <- extract(il1,cbind(lon.pt,lat.pt))
#       leafletProxy("mymap", session) %>% addPopups(lon.pt, lat.pt, as.character(ras.val))
#   })    
  
}