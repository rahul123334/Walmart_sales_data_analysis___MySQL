CREATE DATABASE Walmart_sales_data;
USE Walmart_sales_data;

CREATE TABLE sales (
  invoice_id VARCHAR(100) PRIMARY KEY,
  branch VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL,
  customer_type VARCHAR(50) NOT NULL,
  gender VARCHAR(20) NOT NULL,
  product_line VARCHAR(100) NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  tax_pct FLOAT(6,4) NOT NULL,
  total DECIMAL(12,4) NOT NULL,
  date DATETIME NOT NULL,
  time TIME NOT NULL,
  payment VARCHAR(50) NOT NULL,
  cogs DECIMAL(10,2) NOT NULL,
  gross_margin_pct FLOAT(11,9),
  gross_income DECIMAL(12,4),
  rating FLOAT(2,1)
);

-- ---------------------------------FEATURE ENGINEERING--------------------------------

SELECT time FROM sales;
-- Add time_of_day column
SELECT time, 
	(CASE
	  WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	  WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	  ELSE "Evening"
    END) AS time_of_day
FROM sales; 
 
-- Insert time_of_day column to sales table
ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
	  WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	  WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	  ELSE "Evening"
    END);
SELECT * FROM sales;

-- Add day_name

Select date FROM sales;
Select date,
DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales
ADD COLUMN day_name VARCHAR(30);

Select * FROM sales;

UPDATE sales
SET day_name = DAYNAME(date);
 
-- Add month_name to sales table

SELECT date, MONTHNAME(date) FROM sales;

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(30);

UPDATE sales
SET month_name = MONTHNAME(date);

Select * FROM sales;

-- ----------------------------------------------------------------------------------

-- -------------------------Generic Qns---------------------------------
-- How many unique cities does the data have?
SELECT DISTINCT city FROM sales;

-- In which city is each branch?
SELECT DISTINCT city,branch 
FROM sales;

-- How many unique product lines does the data have?
SELECT DISTINCT product_line FROM sales;

-- What is the most common payment method?
SELECT payment, COUNT(payment) AS cnt 
FROM sales
GROUP BY payment
ORDER BY cnt DESC;

-- What is the most selling product line?
SELECT product_line, COUNT(product_line) AS pl
FROM sales
GROUP BY product_line
ORDER BY pl DESC;

-- What is the total revenue by month?
SELECT month_name AS month, SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT month_name AS month, SUM(cogs) AS largest_cogs
FROM sales
GROUP BY month
ORDER BY month DESC;

-- What is the city with the largest revenue?
SELECT branch,city ,SUM(total) as total_revenue
FROM  sales
GROUP BY city,branch
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT product_line, AVG(tax_pct) AS tax
FROM sales
GROUP BY product_line
ORDER BY tax DESC;

-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) 
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT gender, product_line,
COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC; 

-- What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- Number of sales made in each time of the day per day?
SELECT COUNT(quantity) AS no_ofsales ,day_name
FROM sales
GROUP BY day_name
ORDER BY no_ofsales DESC;

-- Which of the customer types brings the most revenue?
SELECT customer_type,SUM(total) 
FROM sales
GROUP BY customer_type
ORDER BY customer_type;

-- Which city has the largest tax percent/VAT (Value Added Tax)?
SELECT city, ROUND(AVG(tax_pct),2) AS avg_tax_pct
FROM sales
GROUP BY city
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type, SUM(tax_pcT) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY  total_tax DESC;

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment FROM sales;

-- What is the most common customer type?
SELECT customer_type, COUNT(customer_type) 
FROM sales 
GROUP BY customer_type;

-- Which customer type buys the most?
SELECT customer_type, COUNT(customer_type) AS buys
FROM sales 
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT gender, COUNT(gender) AS total_customer
FROM sales
GROUP BY gender
ORDER BY total_customer DESC;

-- What is the gender distribution per branch?
SELECT gender, branch, COUNT(gender) AS total_customer
FROM sales
GROUP BY gender,branch
ORDER BY branch;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, branch, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day,branch
ORDER BY branch ;

-- Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Find day of the week has the average ratings per branch?
SELECT day_name,branch,AVG(rating)
FROM sales
GROUP BY day_name,branch
ORDER BY branch;




