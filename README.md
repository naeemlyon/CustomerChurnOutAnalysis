Senior Data Scientist
=====================
Assignment
----------

Dear Candidate,

welcome to our data science assignment!  Its purpose is to start a conversation about data science from the HelloFresh perspective. While we have many different projects going on with numerous stakeholders, for this assignment, we’d like you to focus on one of the most important topics: forecasting demand and customer churn. 

In the files attached, you will find the following data: 

**boxes.csv**
- subscription_id 
- box_id
- delivered_at (when the box was delivered) 
- started_week (when the subscription first began)
- count_boxes (number of total boxes received per subscription so far)
- product (the type of box received)
- channel (the marketing channel through which the customer was acquired)

**pauses.csv**
- subscription_id
- pause_start
- pause_end

**cancels.csv**
- subscription_id
- delivery_weekday (box delivery date) 
- canceled_at (cancellation effective date) 

**errors.csv**
- subscription_id
- refund_amount (amount refunded to customer because of error) 
- created_at (when the error happened) 


Task
=====
Explore the datasets and develop a model to predict either customer churn over time or weekly demand for each product type. 

Hints
====

1. Please use R or Python:  you are free to use any CRAN packages; as for Python, it's best to stick to packages included in latest release of Anaconda
2. If you produce visuals / graphs, entire related code needs to be included
3. Your predictors can be extracted only from given dataset. No external data are allowed
4. Please keep your solution concise and limited to relevant outputs only
5. You can attach comments to your solution either in the code or in a separate file
6. Exploratory data analysis and validation are part of the model
7. Please make all data paths relative so that we can easily rerun your code if needed


Submission instructions
==================

1. Clone this repository
2. Create a new `dev` branch
3. Place your code into a .R or .py file. Comments and visuals can be named freely 
4. Do a pull request from the `dev` branch to the `master` branch 
5. Over email, reply to invitation for the test, telling us that we can start reviewing your code


Good luck!

Your HelloFresh Recruiting Team
