-- Databricks notebook source
CREATE DATABASE IF NOT EXISTS Retail;
USE DATABASE Retail;

CREATE TABLE IF NOT EXISTS Retail.products
(
  product_id INT PRIMARY KEY,
  product_name VARCHAR(255),
  category_id INT FOREIGN KEY REFERENCES Retail.categories(category_id),
  price DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS Retail.categories
(
  category_id INT PRIMARY KEY,
  category_name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Retail.customers
(
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(255),
  email VARCHAR(255),
  address VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Retail.orders
(
  order_id INT PRIMARY KEY,
  customer_id INT FOREIGN KEY REFERENCES Retail.customers(customer_id),
  product_id INT FOREIGN KEY REFERENCES Retail.products(product_id),
  quantity INT,
  order_date DATE
);

CREATE TABLE IF NOT EXISTS Retail.payments
(
  payment_id INT PRIMARY KEY,
  order_id INT FOREIGN KEY REFERENCES Retail.orders(order_id),
  payment_date DATE,
  amount DECIMAL(10,2)
);

-- Insert sample data into the tables

INSERT INTO Retail.products (product_id, product_name, category_id,
price) VALUES
(1, 'Laptop', 1, 1000),
(2, 'Smartphone', 2, 800),
(3, 'TV', 3, 1200),
(4, 'Camera', 4, 500);

INSERT INTO Retail.categories (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Mobile'),
(3, 'Appliances'),
(4, 'Cameras');

INSERT INTO Retail.customers (customer_id, customer_name, email,
address) VALUES
(1, 'John Doe', 'johndoe@example.com', '123 Main St'),
(2, 'Jane Smith', 'janesmith@example.com', '456 Elm St'),
(3, 'Bob Johnson', 'bobjohnson@example.com', '789 Oak St');

INSERT INTO Retail.orders (order_id, customer_id, product_id, quantity,
order_date) VALUES
(1, 1, 2, 2, '2023-05-01'),
(2, 2, 1, 1, '2023-05-02'),
(3, 3, 3, 3, '2023-05-03');

INSERT INTO Retail.payments (payment_id, order_id, payment_date,
amount) VALUES
(1, 1, '2023-05-02', 1600),
(2, 2, '2023-05-03', 1000),
(3, 3, '2023-05-04', 3600);

-- Retrieve the details of all products.

SELECT * FROM Retail.products;

-- Retrieve the names and categories of all products.

SELECT products.product_name, categories.category_name 
FROM Retail.products 
INNER JOIN Retail.categories 
ON products.category_id = categories.category_id;

-- Retrieve the total number of products in each category
SELECT categories.category_name, COUNT(products.product_id) AS total_products 
FROM Retail.products 
INNER JOIN Retail.categories
ON products.category_id = categories.category_id 
GROUP BY categories.category_name;

-- Retrieve the highest price among all products
SELECT MAX(price) FROM Retail.products;

-- Retrieve the products with a price higher than 1000
SELECT * FROM Retail.products WHERE price > 1000;

-- Retrieve the average price in each category.

SELECT categories.category_name, AVG(products.price) AS avg_price 
FROM Retail.products 
INNER JOIN Retail.categories
ON products.category_id = categories.category_id 
GROUP BY categories.category_name;

-- Retrieve the products in the Electronics category.

SELECT * FROM Retail.products WHERE category_id = (SELECT category_id FROM Retail.categories WHERE category_name = 'Electronics');

-- Retrieve the total price spent by each customer.

SELECT customers.customer_name, SUM(products.price * orders.quantity) AS total_spent 
FROM Retail.customers 
INNER JOIN Retail.orders 
ON customers.customer_id = orders.customer_id
INNER JOIN Retail.products 
ON orders.product_id = products.product_id
GROUP BY customers.customer_name
ORDER BY total_spent DESC;

-- Retrieve the customer who has spent the most.
SELECT customers.customer_name, SUM(products.price * orders.quantity) AS total_spent 
FROM Retail.customers 
INNER JOIN Retail.orders 
ON customers.customer_id = orders.customer_id
INNER JOIN Retail.products 
ON orders.product_id = products.product_id
GROUP BY customers.customer_name
ORDER BY total_spent DESC
LIMIT 1;

-- Retrieve the products with the highest price in each category.

SELECT products.product_name, products.price 
FROM Retail.products 
INNER JOIN (SELECT category_id, MAX(price) AS max_price FROM Retail.products GROUP BY category_id) AS max_prices 
ON products.category_id = max_prices.category_id AND products.price = max_prices.max_price;

-- Retrieve the total revenue generated from sales.

SELECT SUM(products.price * orders.quantity) AS total_revenue
FROM Retail.products
INNER JOIN Retail.orders
ON products.product_id = orders.product_id;

-- Retrieve the orders placed by a specific customer.
SELECT * FROM Retail.orders WHERE customer_id = (SELECT customer_id FROM Retail.customers WHERE customer_name = 'John Doe');

-- Retrieve the customers who have placed orders for a specific product.
SELECT * 
FROM Retail.customers 
INNER JOIN Retail.orders 
ON customers.customer_id = orders.customer_id 
INNER JOIN Retail.products 
ON orders.product_id = products.product_id 
WHERE products.product_name = 'Laptop';

-- Retrieve the average quantity of products sold.
SELECT AVG(quantity) FROM Retail.orders ;

-- Retrieve the total number of customers.
SELECT COUNT(DISTINCT customer_id) FROM Retail.customers;

--  Retrieve the most popular category with the highest number of products sold.
SELECT categories.category_name, COUNT(orders.order_id) AS total_orders
FROM Retail.categories
INNER JOIN Retail.products
ON categories.category_id = products.category_id
INNER JOIN Retail.orders
ON products.product_id = orders.product_id
GROUP BY categories.category_name
ORDER BY total_orders DESC;  

-- Retrieve the customer with the highest number of orders.

SELECT customers.customer_name, COUNT(orders.order_id) AS total_orders
FROM Retail.customers
INNER JOIN Retail.orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_name
ORDER BY total_orders DESC
LIMIT 1;

-- Retrieve the total amount paid for each order.

SELECT orders.order_id, SUM(payments.amount) AS total_amount_paid
FROM Retail.orders
INNER JOIN Retail.payments
ON orders.order_id = payments.order_id
GROUP BY orders.order_id
ORDER BY total_amount_paid DESC;

--Retrieve the orders that have not been paid yet.
SELECT * FROM Retail.orders WHERE order_id NOT IN (SELECT order_id FROM Retail.payments);

-- Retrieve the average payment amount.
SELECT AVG(amount) FROM Retail.payments;