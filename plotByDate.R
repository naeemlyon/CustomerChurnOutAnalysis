###################################################################
plotByDate <- function(dbase, dateVar, numVar, Title) {
  plotData <- gvisCalendar(dbase, 
                           datevar=dateVar, 
                           numvar=numVar,
                           options=list(
                             title=Title,
                             height=600,
                             width=850,
                             calendar="{yearLabel: { fontName: 'Times-Roman',
                               fontSize: 32, color: '#1A8763', bold: true},
                               cellSize: 15,
                               cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                               focusedCellColor: {stroke:'red'}}")
  )
  plot (plotData)
}
###################################################################