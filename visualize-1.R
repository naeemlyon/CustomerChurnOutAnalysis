library(googleVis)
library(readr)
library(data.table)
setwd("/home/mnaeem/r.codes/hello-fresh/")
source("plotByDate.R") # plot by date function
cat("\014")

##----------------------------------------------------------------------------------------
## data preparation 
##----------------------------------------------------------------------------------------

f <- read_csv("boxes.csv")
f$subscription_id <- NULL
f$box_id <- NULL
f$started_week <- NULL
f$channel  <- NULL

f <- data.table(f)
full.data <- f
#f <- f[f$product == prod.names[1]]
f$product <- NULL

##----------------------------------------------------------------------------------------
## delivery of number of boxes on daily bases (all products or by individual product)
##----------------------------------------------------------------------------------------
# daily date varaible 
# sample consiting of all types of product
smpl <- as.data.frame(table(f))
smpl$count_boxes <- NULL
smpl$delivered_at <- as.Date(as.character(smpl$delivered_at))
smpl$Freq <- as.double(smpl$Freq)   

byVar <- "delivered_at"
smpl <- data.table(smpl)

smpl <- smpl[, max(Freq), by = byVar]
smpl <- droplevels(smpl)
# str (smpl)
# plot rendered at Internet Explore / Firefox etc
plotData = plotByDate (smpl, names(smpl)[1] , names(smpl)[2], "Daily boxes delivered [All Products] ") 
# suspends execution otherwise Firefox can't handle burst of data and responds in bizarre
Sys.sleep(3)

####################################################################################

prod.names <- unique(full.data$product)
l <- length(prod.names)
for (i in 1:l) {

  f <- full.data 
  f <- f[f$product == prod.names[i]]
  f$product <- NULL
  ##----------------------------------------------------------------------------------------
  ## delivery of number of boxes on daily bases (all products or by individual product)
  ##----------------------------------------------------------------------------------------
  # daily date varaible 
  # sample consiting of all types of product
  smpl <- as.data.frame(table(f))
  smpl$count_boxes <- NULL
  smpl$delivered_at <- as.Date(as.character(smpl$delivered_at))
  smpl$Freq <- as.double(smpl$Freq)   
  
  byVar <- "delivered_at"
  smpl <- data.table(smpl)
  
  smpl <- smpl[, max(Freq), by = byVar]
  smpl <- droplevels(smpl)
  # str (smpl)
  # plot rendered at Internet Explore / Firefox etc
  plotData = plotByDate (smpl, names(smpl)[1] , names(smpl)[2], 
                         paste("Daily boxes delivered",  " [", prod.names[i] , "]") ) 
  # suspends execution otherwise Firefox can't handle burst of data and responds in bizarre
  Sys.sleep(3.2)
}

#############################################################################################################
#############################################################################################################





