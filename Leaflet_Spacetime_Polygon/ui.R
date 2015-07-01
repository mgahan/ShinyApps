
shinyUI(bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("mymap", width = "100%", height = "100%"),
  
  absolutePanel(bottom = 10, right = 10,
    selectInput("metrics", "Metric",choices=c("val","met"),selected="val"),
    
     sliderInput("time", "Time:",min=1,max=3,value=1,
        animate=animationOptions(interval=900, loop=F))
    
  )
)
)

