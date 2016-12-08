The purpose is to start a conversation about data science from the food sales company perspective. While we have many different projects going on with numerous stakeholders, for this assignment, we’d like you to focus on one of the most important topics: forecasting demand and customer churn. 

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

Good luck!
