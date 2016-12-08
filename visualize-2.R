library(readr)
library(data.table)
library(plotly)
library(ggplot2)
setwd("/home/mnaeem/r.codes/hello-fresh/")
cat("\014")

##----------------------------------------------------------------------------------------
## data preparation 
##----------------------------------------------------------------------------------------
# 'Yes' means Subscription Canceled
# 'No' means Subscription retained
crit <- c("Yes", "No")
criteria <- crit[1] 

full.dt <- read_csv("dt.csv")
full.dt$subscription_id <- NULL
full.dt$delivered_at_max <- NULL
full.dt$delivered_at_min <- NULL
full.dt$channel <- NULL
full.dt <- data.frame(full.dt)
full.dt<-full.dt[(full.dt$canceled==criteria),]
full.dt$canceled  <- NULL

##----------------------------------------------------------------------------------------
## Take sample from whole data 
##----------------------------------------------------------------------------------------
sample.size = 3000
dt <- full.dt[sample(nrow(full.dt), sample.size), ]
dt$product <- as.ordered(as.factor(dt$product)) 
dt$subscription.duration <- round(dt$subscription.duration, digits = 1)
dt$error.gap.cancel <- round(dt$error.gap.cancel, digits = 1)

##----------------------------------------------------------------------------------------
## legends for plot 
##----------------------------------------------------------------------------------------

f <- list(family = "Courier New, monospace",  size = 18,  color = "#7f7f7f")
x <- list(title = paste(names(dt)[2], " days") ,  titlefont = f)
y <- list(title = names(dt)[5], titlefont = f)

##----------------------------------------------------------------------------------------
## draw out plot 
##----------------------------------------------------------------------------------------

plot_ly(dt, x = dt$subscription.duration, y = dt$refund.amount, 
        text = paste("Product: ", dt$product , "<br>", "refund.amount: ", dt$refund.amount, "<br>", "error.gap.cancel: ",  dt$error.gap.cancel, "<br>", "boxes:", dt$boxes ),  
        mode = "markers", color = dt$product, size = dt$boxes) %>%
  layout(xaxis = x, yaxis = y, title= paste("Subscription Canceled: ", criteria ) )

print("In the graph,  Click on Legends (Product Type) to exclude/include Product")


#############################################################################################################
#############################################################################################################





