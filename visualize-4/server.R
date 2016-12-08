library(dplyr)

shinyServer(function(input, output, session) {
  # Provide explicit colors for regions, so they don't get recoded when the
  # different series happen to be ordered differently from year to year.
  # http://andrewgelman.com/2014/09/11/mysterious-shiny-things/
  defaultColors <- c("#33b6ac", "#dc3912", "#c36ccc", "#3aa1cc", "#3366cc", "#3366cc", "#c36ccc", "#3aa1cc", "#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477", "#3366cc", "#0099c6", "#dd4477")
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(dt$product )
  )
  
  yearData <- reactive({
    # Filter to the desired year, and put the columns
    # in the order that Google's Bubble Chart expects
    # them (name, x, y, color, size). Also sort by region
    # so that Google Charts orders and colors the regions
    # consistently.
    dt <- dt %>%
    filter(Year == input$year) %>%
    select(product, canceled, boxes, subscription.duration, Year, refund.amount) %>%
    arrange(product)
  })
  
  output$chart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(dt),
      options = list(
        title = sprintf(
          "Refund Amount vs. Subscription Duration, %s",
          input$year),
        series = series
      )
    )
  })
})