use magist;

-- 1 In relation to the products:
-- What categories of tech products does Magist have?#

select product_category_name_english, count(*) as product_count
From products
join product_category_name_translation using(product_category_name)
WHERE product_category_name_english IN ('computers_accessories', 'electronics', 'console_games', 'audio', 'computers', 'pc_gamer')
group by product_category_name_english
order by product_count desc
;

select *
from product_category_name_translation;
select count(*) from products;
select * from products;

select count(*) from sellers;

-- 3095 sellers



select count(*) from product_category_name_translation;

-- 74 different products
-- How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?
-- t’s the average price of the products being sold?
-- expensive tech products popular? *

-- In relation to the sellers:
-- How many months of data are included in the magist database?
-- How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?

select count(*) from sellers;

-- 3095

-- What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?  454 tech sellers
select sum(oi.price) as total
from order_items oi
left join orders o using (order_id)
WHERE o.order_status NOT IN ('unavailable', 'canceled');
-- 13494400.74

select 
product_category_name_english, 
case
 when product_category_name_english 
 in ("computers_accessories", "books_technical","tablets_printing_image", "audio", "dvds_blu_ray", "consoles_games")
then "Tech"
when product_category_name_english in ("electronics", "computers", "telephony", "fixed_telephony", "pc_gamer")
then "High_End_Tech"
else "Non_Tech"
end as products_type
from product_category_name_translation
;
-- Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?

-- RL code 
SELECT 
    SUM(round(order_items.price)) as sales_volume,
    round((SUM(order_items.price))/COUNT(DISTINCT order_items.seller_id)) as avg_sales_volume,
    COUNT(DISTINCT order_items.seller_id) as sellers_this_month,
    COUNT(DISTINCT orders.customer_id) as customers_this_month,
    month(orders.order_purchase_timestamp) as mymonth,
    year(orders.order_purchase_timestamp) as myyear
    from orders
LEFT JOIN order_items on orders.order_id = order_items.order_id #pull order items for actual orders
LEFT JOIN products on order_items.product_id = products.product_id #pull products from orders through bridge
WHERE 
	products.product_category_name in ("telefonia", "eletronicos", "informatica_acessorios") and
	order_status = "delivered"
GROUP BY myyear, mymonth
ORDER BY myyear ASC, mymonth ASC;



-- In relation to the delivery time:
-- What’s the average time between the order being placed and the product being delivered?

SELECT 
CASE 
WHEN order_delivered_customer_date <= order_estimated_delivery_date 
	THEN 'On Time'
	ELSE 'Delayed'
    END AS delivery_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;

-- On time 88649 delayed 7827 = 96476 (actual total 99,441) 8.8% of orders are delayed and 2965 are missing?!??! 



-- How many orders are delivered on time vs orders delivered with a delay?
-- Is there any pattern for delayed orders, e.g. big products being delayed more often?

SELECT
    o.order_id,
    DATE(o.order_purchase_timestamp) AS order_date,
    MONTH(o.order_purchase_timestamp) AS order_month,
    YEAR(o.order_purchase_timestamp) AS order_year,
    c.customer_id,
    g.state,
    oi.order_item_id,
    oi.price,
    oi.freight_value
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN geo g 
    ON c.customer_zip_code_prefix = g.zip_code_prefix
JOIN order_items oi 
    ON o.order_id = oi.order_id;
    
    SELECT DISTINCT g.state
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN geo g ON c.customer_zip_code_prefix = g.zip_code_prefix;


SELECT DISTINCT state 
FROM geo;

SELECT g.state, COUNT(*) AS rows_in_final_table
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN geo g ON c.customer_zip_code_prefix = g.zip_code_prefix
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY g.state
ORDER BY rows_in_final_table DESC;
