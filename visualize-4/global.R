library(readr)
# dt.csv generated from 'solution.R'
full.dt <- read_csv("../dt.csv")
sample.size = 1000
dt <- full.dt[sample(nrow(full.dt), sample.size), ]

remove(full.dt) # optional, only for poor memory system
dt$Year <- as.numeric(format(dt$delivered_at_min, "%Y")) 
dt$delivered_at_max <- NULL
dt$delivered_at_min <- NULL
dt$subscription_id <- NULL
dt$canceled <- as.factor(as.character(dt$canceled))
dt$product <- as.factor( as.character(dt$product) )
dt$channel <- NULL
dt$error.gap.cancel <- NULL
dt$consistency <- NULL
# reorder them all
dt <- dt[,c(3,1,2,5,4,6)]

