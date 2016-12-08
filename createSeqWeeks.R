createSeqWeeks <- function(y1, y2) {

wk <- createSequences (y1)
for (y in (y1+1):2016){
  wk <- c(wk, createSequences (y))
}  
return (wk)
}  

