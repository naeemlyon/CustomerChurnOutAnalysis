createSequences <- function(yr) {
  
  st <- paste(yr, "1", sep="/")
  st <- paste(st, "1", sep="/")
  en <- paste(yr, "12", sep="/")
  en <- paste(en, "31", sep="/")
  # all 53 weeks
  wk <- seq(as.Date(st), as.Date(en), "weeks")
  first.day <- as.numeric(format(as.Date(wk[2]), "%w"))
  tmp <- wk[1] # started from 1st day of year
  # assume first day of week starts from sunday, system specific setting
  wk <- wk - first.day # adding +1 will shift the starting day of week from sunday to monday
  wk[1] <-tmp
  return(wk)
}
