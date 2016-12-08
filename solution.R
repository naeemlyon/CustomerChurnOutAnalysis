#===================================================================================================
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Author: Muhammad Naeem 
# Muhammad.Naeem@univ-lyon2.fr 
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#===================================================================================================

#===================================================================================================
#---------------------------------------------------------------------------------------------------
# Step. 1: Data Loading  
#---------------------------------------------------------------------------------------------------
#===================================================================================================
options(scipen = 10)
setwd("/home/mnaeem/r.codes/hello-fresh/")
cat("\014") # clears the console
library(readr)
set.seed(1)
full.data <- read_csv("boxes.csv")
full.data$box_id <- NULL
full.data <- data.frame(full.data)
full.data$product <- as.factor(as.character(full.data$product))
full.data$channel <- as.factor(as.character(full.data$channel))
#full.data <- full.data[sample(nrow(full.data), 500000),] # sampling for poor laptops
#write.csv(full.data, "sample.csv", row.names = TRUE, quote = FALSE) # save it for direct call in read_csv()

#===================================================================================================
#---------------------------------------------------------------------------------------------------
# Step. 2: GUI Based used selection  
#---------------------------------------------------------------------------------------------------
#===================================================================================================
# A GUI to get the user input across 
# multiple product selection ##
# range of delivery date (from, to )

# two function helpful in creating 53 weeks for a single year
# first weeks of year starts from day by which 1st january appears
# subsequent weeks always starts from sunday (can be changed in createSequences.R) 
source("createSequences.R")  
source("createSeqWeeks.R")
wk <- createSeqWeeks (2013, 2016)  # range of year in which our transactions exist  
#----------------------------------------------------------------------------------------------------------- 
library(tcltk2)
# names of all of the products
productList <- unique(full.data$product)
ht = 6 # height of GUI list  (number of items)
win1 <- tktoplevel() # GUI Window handler/objet
## ------------------------------------------------
# multiple selection enabled list for 'product list'
win1$env$lst1 <- tk2listbox(win1, height = ht, selectmode = "extended")
tkgrid(tk2label(win1, text = "Choose the Product type?", justify = "left")
)
tkgrid(win1$env$lst1, padx = 10, pady = c(5, 10)) # positioning parameter

tkinsert(win1$env$lst1, "end", "ALL") # insert item at the end of the list
for (prd in productList) # populate whole of the list
  tkinsert(win1$env$lst1, "end", prd)
# Default list.  Indexing starts at zero.
tkselection.set(win1$env$lst1, 0)

# ------------------------------------------------
# single item selection list box for startind date (delivery date)
win1$env$lst2 <- tk2listbox(win1, height = ht, selectmode = "single")
tkgrid(tk2label(win1, text = "Choose the 1st Date", justify = "left"))
tkgrid(win1$env$lst2, padx = 20, pady = c(10, 10)) # positioning parameters

# single item selection list box for last date (delivery date)
win1$env$lst3 <- tk2listbox(win1, height = ht, selectmode = "single")
tkgrid(tk2label(win1, text = "Choose the 2nd Date", justify = "left"))
tkgrid(win1$env$lst3, padx = 20, pady = c(10, 10)) # positioning parameters

# 1st entry in both lists is 'We want all dates, no filter'
tkinsert(win1$env$lst2, "end", "ALL" ) 
tkinsert(win1$env$lst3, "end", "ALL" )

# populating date lists by means of weekly dates
ln <- length(wk)
for (i in 1:ln) {
  tkinsert(win1$env$lst2, "end",as.character(wk[i]))
  tkinsert(win1$env$lst3, "end",as.character(wk[i]))
}
# Default list.  Indexing starts at zero.
tkselection.set(win1$env$lst2, 0) # 0 means ALL, no filtering 
tkselection.set(win1$env$lst3, 0) 

# 3 global variables for getting feedback in a dialog box based GUI
# after the user submission of the button, these three variables will hold the values for filtering 
prodChoice <- "ALL"  
date1Choice <- wk[1]
date2Choice <- wk[length(wk)]

# event attached to the button, assign values to the global vairables to be used after click event
onOK <- function() {
  prodIndx = as.integer(tkcurselection(win1$env$lst1))   # 0 based index for product list
  date1Indx = as.numeric(tkcurselection(win1$env$lst2))  # 0 based index for starting date
  date2Indx = as.numeric(tkcurselection(win1$env$lst3))  # 0 based index for ending date
  
  # bizzare if but 0 is default to handles multiple selection, 
  if (prodIndx == 0) { 
    # produce warning for incapability of comaparing multiple indexes to single value, no problem
    assign("prodChoice", "ALL", envir = .GlobalEnv) 
  }else {
    #prodChoice <<- productList[as.numeric(tkcurselection(win1$env$lst)) + 1] # less prefered
    assign("prodChoice", productList[prodIndx], envir = .GlobalEnv) # multiple values assigned to the prodChoice
  }
  
  if (date1Indx > 0) {
    assign("date1Choice", wk[date1Indx], envir = .GlobalEnv)  
  }
  
  if (date2Indx > 0) {
    assign("date2Choice", wk[date2Indx], envir = .GlobalEnv)
  }
  
  tkdestroy(win1)
}
win1$env$butOK <-tk2button(win1, text = "OK", width = -6, command = onOK)
tkgrid(win1$env$butOK, padx = 10, pady = c(5, 15))
## ------------------------------------------------
print("At this Point, user is expected to make choices in GUI Window appeared outside The RStudio")
print("and press the OK button, if user continues running R code without pressing button")
print("Default (no filtering) values will be assumed.....")
print("Press button OK before running to the next line.")
#####################################################################################################


#===================================================================================================
#---------------------------------------------------------------------------------------------------
# Step. 3: Filtering based on selection through GUI Windos   
#---------------------------------------------------------------------------------------------------
#===================================================================================================
# Filter out on the basis of user choice
#--- if user selects ALL products, no filtering will be performed 
print(paste ("You selected: ",  prodChoice ,  date1Choice , date2Choice, sep="," ) )
prodAll <- FALSE 
for (p in prodChoice){
  # select and then unselect in listbox will produce NA in the prodChoice
  if ((!is.na(p)) & (p == "ALL")) 
  {
   prodAll <- TRUE
   break  
  }
}
# filtering based on product types
if (prodAll == FALSE) 
  full.data <- full.data[(full.data$product %in% prodChoice), ]

#--- Filter all delivery date in the range 
full.data <- subset(full.data, (as.Date(full.data$delivered_at, format = "%Y-%m-%d") >= as.Date(date1Choice)) )
full.data <- subset(full.data, (as.Date(full.data$delivered_at, format = "%Y-%m-%d") <= as.Date(date2Choice)) )
###################################################################################################

#===================================================================================================
# Step. 4: Transoformation, aggregation, joining and other data preprocessing 
#===================================================================================================
#-- Started week conversion into dates: used for calculation
#-- 2013-W01  --> 2013-01-01  first week of year may start from any day
#-- 2013-W01  --> 2013-01-03  second and onward always starts from sunday
#-- 2013-W01  --> 2013-01-10  7 days gap for successive weeks
nd  <-    as.factor(as.character( full.data$started_week))
offset <- 0
for (y in 2013:2016){

  for (i in 1:53){
    currentVal <- paste(y, 'W', sep="-")
    currentVal <- paste(currentVal, formatC(i, width=2, flag="0"), sep="")
    wk.counter <- i + offset
    
    levels(nd) <- c(levels(nd), as.character(wk[wk.counter])  )
    
    if (currentVal %in% nd) {
      nd[nd == currentVal] <- as.character(wk[wk.counter]) 
    }  
  }
  offset <- offset + 53
}
nd <- droplevels(nd)
full.data$started_week <- nd
remove(nd)


###########################################################################
#- No input filtering on dates applied for "cancels", "errors" & "pauses" 
###########################################################################
d1 <- read_csv("errors.csv")
d1 = data.frame(d1)
commonVariables = intersect(names(full.data), names(d1))
# full outer join (processed boxes and errors)
full.data = merge(full.data, d1, by = commonVariables, all.x = TRUE) 

d2 <- read_csv("cancels.csv")
d2 = data.frame(d2)
commonVariables = intersect(names(full.data), names(d2))
# full outer join (processed boxes and cancels)
full.data = merge(full.data, d2, by = commonVariables, all.x = TRUE) 

commonVariables = intersect(names(d1), names(d2))
d3 = merge(d1, d2, by = commonVariables, all = FALSE)
remove(d1)
remove(d2)
d3$refund_amount <- NULL
d3$delivery_weekday <- NULL

#-----------------------------------------------------------------------
# introduce a new parameter 'error.gap.cancel' based on date difference between 
# error-fortune and subscription-cancel
# hypothesis: less the gap, more the chances of churning away
# typical human psychy, get away immediately when erroneously gets something in gratuous 
#------------------------------------------------------------------------ 

# processing of new parameter 'error.gap.cancel' is already carried out,
# joining it in full data 
d3$error.gap.cancel <- difftime(d3$canceled_at, d3$created_at, units = c("days"))
d3$created_at <- NULL
d3$canceled_at <- NULL
d3$error.gap.cancel <- as.numeric(d3$error.gap.cancel)
full.data = merge(full.data, d3, by = commonVariables, all.x = TRUE)
# no.error can be any large number showing no connection between error and cancel
# number should be significantly larger not to confuse with the error.gap.cancel in days 
no.error <- 99999999 
levels(full.data$error.gap.cancel) <- c(levels(full.data$error.gap.cancel), no.error)
full.data$error.gap.cancel[is.na(full.data$error.gap.cancel)] <- no.error
remove(d3)

#################################################################################
# canceled and created_at both were transformed into three variables
# two boolean variables and one numeric variaqble (err.gap.cance)
# err.gap.cance holds the information for both of the variables canceled and created_at
# canceled and created_at were transformed into boolean variable
#################################################################################
# 'canceled' is treated as class/target/label in classification
# some subscribers have canceled out i.e., churn away, (Yes)
# others have loyality till this date  (No)
full.data$canceled_at <- as.factor( as.character(full.data$canceled_at)) 
levels(full.data$canceled_at) <- c(levels(full.data$canceled_at), "Yes")
levels(full.data$canceled_at) <- c(levels(full.data$canceled_at), "No")
full.data$canceled_at[is.na(full.data$canceled_at)] <- 'No'
full.data$canceled_at[full.data$canceled_at == 'NA'] <- 'No'
full.data$canceled_at[full.data$canceled_at != 'No'] <- 'Yes'
full.data$canceled_at <- droplevels(full.data$canceled_at)

# subscribers never get refund should be marked as 0 in refund amount
levels(full.data$refund_amount) <- c(levels(full.data$refund_amount), 0)
full.data$refund_amount[is.na(full.data$refund_amount)] <- 0

# refund date was available in origional data
# it originally points out to only those subscribers who got refund date
# we converted this filed as Yes / No
# While doing so, we already  introduced err.gap.cancel parameter
# to utilize the available information in refund date and cancel date
# and changed both of the parameters into boolean
full.data$created_at <- as.factor(as.character(full.data$created_at))
levels(full.data$created_at) <- c(levels(full.data$created_at), "Yes")
levels(full.data$created_at) <- c(levels(full.data$created_at), "No")
#unique(full.data$created_at)
full.data$created_at[is.na(full.data$created_at)] <- 'No'
full.data$created_at[full.data$created_at == 'NA'] <- 'No'
full.data$created_at [full.data$created_at != 'No'] <- 'Yes'
full.data$created_at <- droplevels(full.data$created_at) 

###################################################################################################


#===================================================================================================
#---------------------------------------------------------------------------------------------------
# Step. 5: Concatenation, Joining, Assembly of final data   
#---------------------------------------------------------------------------------------------------
#===================================================================================================

# remove all of the redundant levels (produced during massive transformation)
full.data <- droplevels(full.data)
cat("\014") # clear the console 

# organize date by subscription 
byVar <- "subscription_id"

library(data.table)
# needs to reshape as aggregation functions required this format
full.data <- data.table(full.data)

# data is enough, so much redundant id with different information, 
# shrink this data into size of  
# length(unique(full.data$subscription_id))
# with focus is on subscription
d.min <- full.data[, min(delivered_at), by = byVar]
d.max <- full.data[, max(delivered_at), by = byVar]
d.cnt <- full.data[, length(delivered_at), by = byVar]
d.boxes <- full.data[, max(count_boxes), by = byVar]
d.product <- full.data[, unique(product), by = byVar]
d.channel <- full.data[, unique(channel), by = byVar]
d.started_week <- full.data[, unique(started_week), by = byVar]
d.refund.amount <- full.data[, unique(refund_amount), by = byVar]
d.error.gap.cancel <- full.data[, unique(error.gap.cancel), by = byVar]
d.canceled <- full.data[, unique(canceled_at), by = byVar]

#### shrinking started, data generated from scratch across separate chunks 

# range of delivery date per subscription
full.data = merge(d.min, d.max, by = byVar, all = FALSE) 
full.data = merge(full.data, d.cnt, by = byVar, all = FALSE)

# how many boxes for a given subscription 
full.data = merge(full.data, d.boxes, by = byVar, all = FALSE)

cl <- c("subscription_id", "delivered_at_min", "delivered_at_max", "count", "boxes")
colnames(full.data) <- cl

# subscription start week already changed into date for calcuation purpose 
full.data = merge(full.data, d.started_week, by = byVar, all = FALSE)
cl <- c(cl, "started_week")
colnames(full.data) <- cl 

# introduce a new parameter 'subscription duration', an indication for long term customer value, loyality 
# difference in days between subscription starting week and latest delivery
full.data$subscription.duration <- difftime(full.data$delivered_at_max, full.data$started_week, units = c("days"))
full.data$subscription.duration <- as.numeric(full.data$subscription.duration)
full.data$started_week <- NULL


# introduce a new parameter 'consistency' based on regularity in delivery
# find the range between delivery period
# divides the range by 'counts of delivery'
full.data$range <- difftime(full.data$delivered_at_max, full.data$delivered_at_min, units = c("days"))
full.data$consistency <- as.numeric (full.data$range + 7) / full.data$count
full.data$range <- NULL
full.data$count <- NULL
full.data = merge(full.data, d.product, by = byVar, all = FALSE)
full.data = merge(full.data, d.channel, by = byVar, all = FALSE)
cl <-  c("subscription_id", "delivered_at_min", "delivered_at_max", "boxes", "subscription.duration", "consistency", "product", "channel")
colnames(full.data) <- cl 
full.data = merge(full.data, d.refund.amount, by = byVar, all = FALSE)
cl <- c(cl, "refund.amount")
colnames(full.data) <- cl 

# integrating the target variable 'canceled' in full data
full.data = merge(full.data, d.canceled, by = byVar, all = FALSE)
cl <- c(cl, "canceled")
colnames(full.data) <- cl

# processing of new parameter 'error.gap.cancel' is already carried out,
# joining it in full data 
full.data = merge(full.data, d.error.gap.cancel, by = byVar, all = FALSE)
cl <- c(cl, "error.gap.cancel")
colnames(full.data) <- cl

###############################################################
## no more required, free up memory
remove(d.min)
remove(d.max)
remove(d.cnt)
remove(d.boxes)
remove(d.product)
remove(d.channel)
remove(d.started_week)
remove(d.refund.amount)
remove(d.error.gap.cancel)
remove(d.canceled)

# save it for Visualization purpose
# copy this file in visualize-3 and visualize-2 folder
write.csv(full.data, "dt.csv", row.names = FALSE, quote = FALSE)
full.data$delivered_at_min <- NULL
full.data$delivered_at_max <- NULL
########################################################

## Pauses csv
# Attaching pauses to the main database
# we shall transform it into compatiable with full data
# by means of aggregation


pauses.dt <- read_csv("pauses.csv")
pauses.dt <- data.frame(pauses.dt)

## How many times pauses was issued for a subscription.... 
pauses.dt <- data.frame(table(pauses.dt$subscription_id))
colnames(pauses.dt) <- c("subscription_id", "pauses") 
pauses.dt <- data.table(pauses.dt)
pauses.dt$subscription_id <- as.integer(as.character(pauses.dt$subscription_id))
byVar <- "subscription_id"

# full outer join, subscription.id in puases are only subset of full.data 
full.data = merge(full.data, pauses.dt, by = byVar, all.x = TRUE)
remove(pauses.dt) # no more required, free memory

# many subscription id have never get pauses, we put 0 in those cases
levels(full.data$pauses) <- c(levels(full.data$pauses), 0)
full.data$pauses[is.na(full.data$pauses)] <- 0
cat("\014")

########################################################

#===================================================================================================
#---------------------------------------------------------------------------------------------------
# Step. 6: Model Building (Random Forest)   
#---------------------------------------------------------------------------------------------------
#===================================================================================================

full.data <- droplevels(full.data)
# splitting data into train and test fold
# 2 means fifty percent for train and test each
# 5 means 4 parts for train and 1 part for test
ratio = 5 
train = full.data[which(full.data$subscription_id %% ratio > 0),]
test = full.data[which(full.data$subscription_id %% ratio == 0),]
#remove(full.data)
#write.csv(full.data, "full.data.csv", row.names = TRUE, quote = FALSE)
cat("\014")


###
### Evaluate RF predictions by splitting the train db in 80%/20%
### Randomforest
library(randomForest)
str(train)
# model fitting
fit <- randomForest(canceled ~ 
        subscription_id + boxes + subscription.duration + consistency + product + channel + refund.amount + pauses + error.gap.cancel,
        data=train, 
        importance=TRUE,  
        proximity=FALSE, 
        ntree=30)

pred = predict(fit, test,  "prob") # probability for each outcome
pred1 = predict(fit, test) # likelihood (yes / no)
#pred
fit$err.rate
print(fit) # show confusion matrix for training error
varImpPlot(fit)

# confusion matrix for test error
pred1conf.matrix <- table (test$canceled , pred1)
print(pred1conf.matrix)
print(pred)
acc1 <-  (pred1conf.matrix[1] + pred1conf.matrix[4]) / nrow(test)
print(acc1)

num = 1
library(ROCR)
predictions=as.vector(fit$votes[,num])
pred=prediction(predictions,train$canceled)
perf_AUC=performance(pred,"auc") #Calculate the AUC value
AUC=perf_AUC@y.values[[num]]
perf_ROC=performance(pred,"tpr","fpr") #plot the actual ROC curve
plot(perf_ROC, main="ROC")
text(0.5,0.5,paste("AUC = ",format(AUC, digits=5, scientific=FALSE)))

#################################################################################

#===================================================================================================
#---------------------------------------------------------------------------------------------------
# Step. 7: Model Building (Conditiona Inference Forest (special class of Random Forest) )
#---------------------------------------------------------------------------------------------------
#===================================================================================================
# overfitted model, the cost is more computationally expensive
#install.packages('party')
#library(party)
#set.seed(415)
# Extremely computationally expensive
#fit2 <- cforest(canceled ~ 
#                 subscription_id + boxes + subscription.duration + consistency + product + channel + refund.amount + pauses + error.gap.cancel,
#                 data = train, 
#                 controls=cforest_unbiased(ntree=20, mtry=3))

#pred2 <- predict(fit2, test, OOB=TRUE, type = "response")  

# confusion matrix for test error
#pred2conf.matrix <- table (test$canceled , pred2)
#print(pred2conf.matrix)
#################################################################################



#===================================================================================================
#---------------------------------------------------------------------------------------------------
# Step. 8: ## Model Building Product Wise (Random Forest)
#---------------------------------------------------------------------------------------------------
#===================================================================================================

cat("\014")
# product name list
prod.names <- unique(full.data$product)
l <- length(prod.names)
nTree = 30
for (i in 1:l) {
  # sampling of full data with only selected product name
  smpl <- full.data[full.data$product == prod.names[i] ]
  
  # 2 means fifty percent for train and test each
  # 5 means 4 parts for train and 1 part for test
  ratio = 2 
  train = smpl[which(smpl$subscription_id %% ratio > 0),]
  test = smpl[which(smpl$subscription_id %% ratio == 0),]
  
  # some product types have too little data to build model is not 
  if (length (unique(train$canceled)) > 1) {
    
  fit <- randomForest(canceled ~ 
                      subscription_id + boxes + subscription.duration + consistency + channel + refund.amount + pauses + error.gap.cancel,
                      data=train,
                      importance=TRUE,  
                      ntree=nTree)
  
  pred = predict(fit, test)
  print (paste( "::::::::", prod.names[i], "::::::::::", sep=" "))
  acc = 
  print (paste( " OOB estimate of  error rate: ", as.character((fit$err.rate)[nTree] * 100), "%"))  
  print(fit$confusion)
  print (paste( "====================================================="))
  }
}
#####################    END     ###############################################################################
################################################################################################################