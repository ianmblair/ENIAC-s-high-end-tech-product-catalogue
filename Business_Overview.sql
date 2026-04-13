-- 1 How many orders are there in the dataset? 
use magist;
SELECT * FROM orders;
SELECT COUNT(order_id) FROM orders;

			-- 99,441 order from 7th Sept 2016 to 28th October 2018

SELECT *
FROM orders
WHERE YEAR(order_purchase_timestamp) = 2016;

SELECT DISTINCT YEAR(order_purchase_timestamp) AS years
FROM orders
ORDER BY years;

-- 2 Are orders actually delivered? Look at the columns in the orders table: one of them is called order_status. 
		-- Find out how many orders are delivered and how many are cancelled, unavailable, or in any other status by grouping and aggregating this column.

SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

select count(*) as not_delivered 
from orders
where order_status <> 'delivered';

select * from orders;
-- 99,441 orders total 2963 not delivered. 3%

	
        
-- 3 Is Magist having user growth?  It would be a good idea to check for the number of orders grouped by year and month. 
		-- Tip: you can use the functions YEAR() and MONTH() to separate the year and the month of the order_purchase_timestamp.
        
select
	year(order_purchase_timestamp),
    month(order_purchase_timestamp),
    round(sum(price), 2) as revenue
from order_items oi
join orders o using(order_id)
group by year(order_purchase_timestamp), month(order_purchase_timestamp)
order by year(order_purchase_timestamp), month(order_purchase_timestamp);   

SELECT * from orders;

SELECT *
FROM orders
WHERE YEAR(order_purchase_timestamp) = 2016;

SELECT count(*),year(order_purchase_timestamp),month(order_purchase_timestamp)
FROM orders
group by year(order_purchase_timestamp),month(order_purchase_timestamp);


-- 329 
SELECT COUNT(*) 
FROM orders
WHERE YEAR(order_purchase_timestamp) = 2017;
-- 45099
SELECT COUNT(*) 
FROM orders
WHERE YEAR(order_purchase_timestamp) = 2018;
-- 54013

SELECT 
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_year, order_month
ORDER BY total_orders desc;


-- 4 How many products are there on the products table? (Make sure that there are no duplicate products.)
SELECT COUNT(DISTINCT product_id) AS total_unique_products
FROM products;
  -- 32951
  
-- Which are the categories with the most products? Since this is an external database and has been partially anonymized, we do not have the names of the products. 
			-- But we do know which categories products belong to. This is the closest we can get to knowing what sellers are offering in the Magist marketplace. 
           --  By counting the rows in the products table and grouping them by categories, we will know how many products are offered in each category. 
            -- This is not the same as how many products are actually sold by category. To acquire this insight we will have to combine multiple tables together: we’ll do this in the next lesson.
            
select product_category_name_english, count(*) as product_count
From products
join product_category_name_translation using(product_category_name)
group by product_category_name_english
order by product_count desc
limit 20
;


SELECT DISTINCT product_category_name_english
FROM product_category_name_translation;
-- need to add translations table
   
		
-- 6 How many of those products were present in actual transactions? The products table is a “reference” of all the available products. 
		-- Have all these products been involved in orders? Check out the order_items table to find out!

Select product_category_name, product_id, order_id, price, product_category_name_english
From order_items
join products using(product_id)
join product_category_name_translation using(product_category_name);


-- NOW AS A COUNT
SELECT 
    product_category_name_english,
    COUNT(*) AS total_products
FROM order_items
JOIN products USING (product_id)
JOIN product_category_name_translation USING (product_category_name)
GROUP BY product_category_name_english
ORDER BY product_category_name_english;
        
        
-- 7 What’s the price for the most expensive and cheapest products? 

Select product_category_name, product_id, order_id, price, product_category_name_english
From order_items
join products using(product_id)
join product_category_name_translation using(product_category_name);

-- 8 What are the highest and lowest payment values? Some orders contain multiple products. What’s the highest someone has paid for an order?

select * from order_items;
select AVG(price) as average_price
from order_items;

-- price of highest order is 1050.61.. Averge order price is 120.65

SELECT 
    product_id,
    product_category_name_english,
    COUNT(*) AS total_items_sold
FROM order_items
JOIN products USING (product_id)
JOIN product_category_name_translation USING (product_category_name)
GROUP BY product_id, product_category_name_english
ORDER BY total_items_sold DESC;

