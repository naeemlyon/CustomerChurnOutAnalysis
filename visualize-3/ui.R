pageWithSidebar(

  headerPanel('clustering on hellofresh data'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', names(dt),
                selected=names(dt)[[1]]),
    selectInput('ycol', 'Y Variable', names(dt),
                selected=names(dt)[[2]]),
    sliderInput('clusters', "Cluster count", min=2, max=9, value=3, 
                step = 1, round = FALSE, ticks = TRUE, animate = TRUE)
    
      ),
  mainPanel(
    plotOutput('plot1')
  )
)


