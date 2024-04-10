-- Create Database
Create database if not exists salesdatawalmart;
-- Use Database
use salesdatawalmart;
-- Create table as per the csv file and then load the data
create table if not exists sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(30) not null,
Product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
vat float(6,4) not null,
total decimal(12,4)not null,
date datetime not null,
time time not null,
payment varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,9),
gross_income decimal(12,4),
rating float(2,1)
);
select * from sales;
-- There are no null values in our database bcz while creating the tables we set NOT NULL for each field.
-- Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.
select time,
(case 
when time between "00:00:00" and "12:00:00" then 'morning'
when time  between "12:01:00" and "16:00:00" then 'afternoon'
else 'evening'
end
) as time_of_date
from sales;
alter table sales add column time_of_date varchar(20);
update sales
set time_of_date = (case 
when time between "00:00:00" and "12:00:00" then 'morning'
when time  between "12:01:00" and "16:00:00" then 'afternoon'
else 'evening'
end
);
-- Add a new column named day_name that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.
select date,
dayname(date) as day_name
from sales;
alter table sales
add column day_name varchar(10);
update sales
set day_name = (dayname(date));
-- Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.
select date,
monthname(date) as month_name
from sales;
alter table sales
add column month_name varchar(15);
update sales
set month_name = monthname(date);
select * from sales;

-- Generic Question
-- How many unique cities does the data have?
select distinct city from sales;
-- In which city is each branch?
select distinct(branch),city from sales;

-- Product
-- How many unique product lines does the data have?
select count(distinct(product_line)) from sales;
-- What is the most common payment method?
select payment,count(*) as count
from sales
group by payment
order by count desc;
-- What is the most selling product line?
select product_line,count(*) as count 
from sales
group by product_line
order by count desc;
-- What is the total revenue by month?
select month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;
-- What month had the largest COGS?
select month_name as month,
sum(cogs) as cogs 
from sales
group by month_name
order by cogs desc
LIMIT 1;
-- What product line had the largest revenue?
select product_line,
sum(total) as largest_revenue 
from sales
group by product_line
order by largest_revenue desc
limit 1; 
-- limit 1 is given as we only need the largest_revenue if we need top 3 then limit 3 must be set 
-- if we need all then no need of specifying limit
-- What is the city with the largest revenue?
select city,branch,
sum(total) as largest_revenue
from sales
group by city,branch
order by largest_revenue desc;
-- What product line had the largest VAT?
select product_line,avg(vat) as avg_tax from  sales
group by product_line
order by avg_tax desc;
-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select avg(quantity) as avg_quantity from sales;
select product_line,
case when avg(quantity)>6 THEN "GOOD"
else "Bad"
end as remark from sales
group by product_line;
-- Which branch sold more products than average product sold?
select branch,sum(quantity) as total_products from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);
-- What is the most common product line by gender?
select gender,product_line,count(gender) as total_count from sales
group by gender,product_line
order by total_count desc;
-- What is the average rating of each product line?
select product_line,round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc;
select * from sales;

-- SALES
-- Number of sales made in each time of the day per weekday
select time_of_date,count(*) as total_sales
from sales 
where day_name = 'monday'
group by time_of_date
order by total_sales desc;
-- Which of the customer types brings the most revenue?
select customer_type,sum(total) as revenue from sales
group by customer_type
order by revenue desc
limit 1;
-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,sum(vat) as largest_vat from sales
group by city
order by largest_vat desc;
-- Which customer type pays the most in VAT?
select customer_type,sum(vat) as pays from sales
group by customer_type
order by pays desc;

-- CUSTOMER
-- How many unique customer types does the data have?
select distinct(customer_type) from sales;
-- How many unique payment methods does the data have?
select distinct(payment) from sales;
-- What is the most common customer type?
select distinct(customer_type),count(*) as count from sales
group by customer_type
order by count desc;
-- Which customer type buys the most?
select customer_type,count(*) as count from sales
group by customer_type
order by count desc;
-- What is the gender of most of the customers?
select gender,count(*) as count from sales
group by gender
order by count desc
limit 1;
-- What is the gender distribution per branch?
select branch,gender,count(gender) as count from sales
group by branch,gender
order by branch,count desc;
-- for particular gender
select gender,count(*) as count from sales
where branch = 'A' 
group by gender
order by count desc;
-- Which time of the day do customers give most ratings?
select time_of_date, avg(rating) as avg_rating from sales
group by time_of_date
order by avg_rating desc;
-- Which time of the day do customers give most ratings per branch?
select time_of_date,avg(rating) as avg_rating from sales
where branch = 'A'
group by time_of_date
order by avg_rating desc;
-- To fect all branches data at once
select time_of_date,avg(rating) as avg_rating,branch from sales
group by branch,time_of_date
order by branch,avg_rating desc;
-- Which day of the week has the best avg ratings?
select day_name,avg(rating) as avg_rating from sales
group by day_name
order by avg_rating desc;
-- Which day of the week has the best average ratings per branch?
select branch,day_name,avg(rating) as avg_rating from sales
group by branch,day_name
order by branch,avg_rating desc;
-- for particular branch
select day_name,avg(rating) as avg_rating from sales
where branch = 'A'
group by day_name
order by avg_rating desc;