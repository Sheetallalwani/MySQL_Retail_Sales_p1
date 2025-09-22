-- sql retail project
CREATE DATABASE sql_project_p1;

-- Creating table 
Drop Table If Exists retail_sales;
Create Table retail_sales
	(
		transactions_id	int primary key,
        sale_date	date,
        sale_time	time,
        customer_id	int,
        gender varchar(50),
        age	int,
        category varchar(50),
        quantiy	int,
        price_per_unit	float,
        cogs float,
        total_sale float
	);
select * from retail_sales limit 10;

SELECT
	COUNT(*)
FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE sale_date is null;

select * from retail_sales
where sale_time is null;

select * from retail_sales
where 
	transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;


-- Data Exploration

-- How many sales we have?? -1987
select count(*) as total_sales from retail_sales;

-- How many unique customer we have?? -155
select count(distinct customer_id) as unique_customer from retail_sales;

select distinct category from retail_sales; -- 3

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
 select * from retail_sales
 where sale_date = "2022-11-05";

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    sale_date between '2022-11-01' and '2022-11-30'
    AND
    quantiy >= 4;

    
   -- Alter column name from quantiy to quantity
   Alter Table retail_sales 
    change column quantiy quantity int;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) total_sale
from retail_sales
group by category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category. - 40.41
select round(avg(age),2) as average_age
from retail_sales
where category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000. --306
select * from retail_sales
where total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category. -M(975),F(1012)
select gender,count(transactions_id) total_trans_gender 
from retail_sales
group by gender;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year- 2022(7) , 2023(2)
select 	year,
		month,
		avg_sale
from
(select
	year(sale_date) as year,
    month(sale_date) as month ,
    avg(total_sale) as avg_sale ,
    rank() over(partition by year(sale_date)  order by avg(total_sale) desc ) as rankk
from retail_sales
group by 1,2 ) as rn
where rankk = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select 	customer_id,
		sum(total_sale) as total_sale
from retail_sales
group by 1
order by 2 desc
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select	category, 	
		count(distinct customer_id) as unique_customers
from retail_sales
group by category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
With hourly_sales as (
	select *,
		case
			when hour(sale_time) <= 12 then 'Morning'
            when hour(sale_time) between 12 and 17 then 'Afternoon' else 'Evening'
		end as shift
	from retail_sales
)
select 	shift,
		count(*) as num_of_orders
from hourly_sales
group by shift;

-- End Of Project

