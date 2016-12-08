library(readr)
# dt.csv generated from 'solution.R'
dt <- read_csv("../dt.csv")

dt$subscription_id <- NULL # useless, only id
min.date <- dt$delivered_at_min
max.date <- dt$delivered_at_max

dt$delivered_at_min <- NULL # no sense in denormalized context
dt$delivered_at_max <- NULL
dt$channel <- NULL
dt$product <- NULL

# Logical Boolean  to Numeric Boolean
levels(dt$canceled) <- c(levels(dt$canceled), 0)
levels(dt$canceled) <- c(levels(dt$canceled), 1)
dt$canceled[dt$canceled == "Yes"] <- 1
dt$canceled[dt$canceled == "No"] <- 0
dt$canceled <- as.numeric(dt$canceled)

