function(input, output, session) {

  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    dt[, c(input$xcol, input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#AFBC13", "#ABCABC", "#334455",
              "#FC7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    par(mar = c(1, 2, 1, 2))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
}