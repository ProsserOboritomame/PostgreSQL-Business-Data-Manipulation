--creating the customers data table 
CREATE TABLE customers(
	customer_id INT PRIMARY KEY,
	customer_name VARCHAR(19),
	email VARCHAR(30),
	phone VARCHAR(20),
	dob DATE,
	gender VARCHAR(1),
	country VARCHAR(7),
	city VARCHAR(13)
);

--creating the product data table
CREATE TABLE products(
	product_id VARCHAR(3) PRIMARY KEY,
	product_name VARCHAR(30),
	description VARCHAR(100),
	product_category VARCHAR(12),
	unit_price NUMERIC(10,2),
	unit_cost NUMERIC(10,2)
);

--creating the order data table
CREATE TABLE orders(
	order_id INT PRIMARY KEY,
	customer_id INT REFERENCES customers (customer_id),
	order_date DATE,
	product_id VARCHAR(3) REFERENCES products (product_id),
	quantity INT,
	delivery_status VARCHAR(10)
);

--creating the payment data table
CREATE TABLE payments(
	payment_id VARCHAR(5) PRIMARY KEY,
	order_id INT REFERENCES orders (order_id),
	payment_date DATE
);

--creating the credit card data table
CREATE TABLE credit_cards(
	credit_card_id VARCHAR(4),
	customer_id INT REFERENCES customers (customer_id),
	card_number VARCHAR(20),
	card_expiry_date DATE,
	bank_name VARCHAR(24)
);

select *
FROM credit_cards


--28 Apr 2026
/* SELECT
Retrieve or get data from the table. Select * retrieve all the columns in your table.*/

--Show the information in the customers table
SELECT *
FROM customers;

--show only the names of the customers
SELECT
	customer_name
FROM customers;

--show the product names, description and their unit_price
SELECT
	product_name,
	description,
	unit_price
FROM products;

/* Note this Comparison Operators
EQUAL TO =
GREATER THAN >
GREATER THAN OR EQUAL TO >=
LESS THAN <
LESS THAN OR EQUAL TO <=
NOT EQUAL TO <> OR != */

/*WHERE
Where clause is used to filter a data based on condition.*/

--Show all the information of customers living in Calabar

SELECT *
FROM customers
WHERE city = 'Calabar';

--Show all the information of the male customers
SELECT *
FROM customers
WHERE gender = 'M';

SELECT *
FROM customers
WHERE gender = 'M'

--show products that are above $1500
SELECT *
FROM products
WHERE unit_price > 1500;

--show all the orders that were made on or after the 1st of Jan 2024
SELECT *
FROM orders
WHERE order_date >= '2024-01-01';

/* aggregate functions
COUNT
SUM
AVERAGE
MIN
MAX .*/
They come after select
for numeric data only  we have AVG() and SUM()
Both numeric and non-numeric, we have COUNT(), MAX() and MIN()

--1. What is the average price of product
SELECT 
	AVG(unit_price) AS average_price
FROM products;
--2 What is the highest product price?
SELECT
	MAX(unit_price) AS highest_price
FROM products;
--3 What is the lowest quantity ordered?
SELECT
	MIN(quantity) AS Lowest_quantity
FROM orders
--what is the lowest product price
SELECT
	MIN(unit_price) AS Lowest_product_price
FROM products
--What is the total quantity ordered?
SELECT
	SUM(quantity) AS total_quantity
FROM orders
--How many customers do we have?
SELECT
	COUNT(customer_id) AS total_customer
FROM customers
--how many customers use GTB
SELECT
	COUNT(credit_card_id) AS Total_no_GTbank
FROM credit_cards
WHERE bank_name = 'GT Bank'
GROUP BY bank_name;

calculate the total revenue
SELECT 
SUM(unit_price) AS total_price
FROM products (this answer may wrong ask Coach)


/* ORDER BY
Order By sort data in ASC(lowest to highes) and DESC(Highest to lowest) order. 
By default SQL sort by ASC so its important to specify the order. */

--show the product in alphabetical order from A-Z
SELECT *
FROM products
ORDER BY product_name ASC;
--Show the orders from the most recent to the oldest
SELECT *
FROM orders
ORDER BY order_date DESC;
/*Dola company wants to review all transactions made during the year 2023 and 
2024 and also see the most recent once.
Write a query to retrieve every records that meets this condition. */
SELECT *
FROM payments
WHERE payment_date >= '2023-01-01'
ORDER BY payment_date DESC;

/* The manager needs a list of high value items currently in the catalog, 
showing the cheapest first. Only include items that cost more than 500. */
SELECT 
	product_name,
	unit_price
FROM products
WHERE unit_price > '500'
ORDER BY unit_price ASc;

--Limit
--Limit restricts the number of records returned
--Retrieve the order table and show only two records
SELECT *
FROM orders
LIMIT 2

--show the name and price of the three most expensive phone
SELECT 
	product_category,
	product_name,
	unit_price
FROM products
WHERE product_category = 'Mobile Phone'
ORDER BY unit_price DESC
LIMIT 3;

/*GROUP BY
Combines rows with the same value, Aggregate(group), a column by another column,
Aggregated column should not be mentioned in the GROUP BY. */

--Which bank do customers use the most?
SELECT
	bank_name,
	COUNT(credit_card_id) AS Total_bank
FROM credit_cards
GROUP BY bank_name
ORDER BY Total_bank DESC;

--Find the top three customers that patronised us the most
SELECT 
	customer_id,
	COUNT(quantity) AS Most_patronise
FROM orders
GROUP BY customer_id
ORDER BY Most_patronise DESC
LIMIT 3;

--Assignment
--1 Find the least popular product by quantity
--2 How many female customers do we have in each city?
--3 Are laptops more expensive than phones
--4 What is the total quantity sold for each product?

SELECT
product_id,
SUM(quantity) AS least_quantity
FROM orders
GROUP BY product_id
ORDER BY least_quantity ASC;

--2 How many female customers do we have in each city?
SELECT
city,
COUNT(customer_id) AS female_customers
FROM customers
WHERE gender='F'
GROUP BY city;

--3 Are laptops more expensive than phones
SELECT
product_category,
AVG(unit_price) AS avg_price
FROM products
WHERE product_category<>'accessaries'
GROUP BY product_category;

--4 What is the total quantity sold for each product?
SELECT
product_id,
SUM(quantity) AS total_quantity
FROM orders
GROUP BY product_id
ORDER BY SUM(quantity) DESC;

/* HAVING
having is used to filter data after aggregation. Having can only be used after using the 'GROUP BY'.In having we are using the aggregate column.*/
--show the products that we've sold at least  100 pieces?
SELECT
product_id,
SUM(quantity) AS total_qty
FROM orders
GROUP BY product_id
HAVING SUM(quantity)>=100;
--which customers have patronize us less than 3 times?
SELECT
customer_id,
COUNT(order_id) AS total_patronage
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) <3;
/* Management wants to know which products have sold more than 100 pieces  in total,
but they only want to see the top 3.*/
SELECT
product_id,
SUM(quantity) AS total_qty
FROM orders
GROUP BY product_id
HAVING SUM(quantity)> 100
LIMIT 3; 

/* LOGICAL OPERATORS
AND all conditions must be True
OR atleast one condition must be True */
AND/OR
--IN/NOT IN TO INCLUDE AND EXCLUDE

--show the names of the female customers in PH
SELECT
customer_name,
gender,
city
FROM customers
WHERE gender='F' AND city='Port Harcourt';

--do we have any Access or GT Bank customers that their cards will expire on '2024-01-10'?
SELECT *
FROM credit_cards
WHERE (bank_name='Access Bank'OR bank_name='GT BANK')
AND card_expiry_date = '2024-01-10';

/* The marketing team wants to identify customers who either live in
Lagos or Abuja but must have provided an email address. write a querry for this question */
SELECT *
FROM customers
WHERE(city='Lagos' OR city ='Abuja')
AND email IS NOT NULL;
--Find product that belong to the Cosmetics or Accessaries category and cost more than 1000
SELECT *
FROM products
WHERE (product_category ='Costmetics' OR product_category ='Accessories')
AND unit_price >1000;

/* The finance department wants to find records made after 2024-01-01 or where the
payment id is 30, but only wants to see payments that are not older than 2023. */
SELECT *
FROM payments
WHERE (payment_date > '2024-01-01' OR payment_id = 'PY30')
AND payment_date >= '2023-01-01';

--RANGE OEPARATORS
--BETWEEN
--Between check if a value is within a range and it deals with lowe4 and upper boundary(100 and 500)
--Find the product with prices beyween 500 to 1500
SELECT *
FROM products
WHERE unit_price BETWEEN 500 AND 1500;

--Find the order that where delivered between Jan and Feb 2023
SELECT*
FROM orders
WHERE order_date BETWEEN '2023-01-01' AND '2023-02-28';

--How many orders were paid for in Q1 2024?
SELECT
	COUNT(order_id) AS total_paid
FROM payments
WHERE payment_date BETWEEN '2024-01-01' AND '2024-3-31';



