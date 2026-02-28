CREATE DATABASE Customers;
USE Customers;

CREATE TABLE Customers(
customer_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100) UNIQUE,
city VARCHAR(50),
signup_date DATE 
);


INSERT INTO Customers (first_name, last_name, email, city, signup_date) VALUES
('John', 'Doe', 'john@example.com', 'New York', '2024-01-10'),
('Alice', 'Smith', 'alice@example.com', 'Chicago', '2024-02-15'),
('Robert', 'Brown', 'robert@example.com', 'Los Angeles', '2024-03-20'),
('Emma', 'Wilson', 'emma@example.com', 'Houston', '2024-04-05');


CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

INSERT INTO Products (product_name, category, price, stock) VALUES
('Laptop', 'Electronics', 800.00, 50),
('Smartphone', 'Electronics', 600.00, 80),
('Headphones', 'Accessories', 100.00, 100),
('Office Chair', 'Furniture', 150.00, 40),
('Desk Lamp', 'Furniture', 40.00, 70);


CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2024-05-01', 'Completed'),
(2, '2024-05-03', 'Completed'),
(1, '2024-06-10', 'Completed'),
(3, '2024-06-15', 'Completed');

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Order_Items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 800.00),
(1, 3, 2, 100.00),
(2, 2, 1, 600.00),
(3, 4, 1, 150.00),
(4, 1, 1, 800.00),
(4, 5, 2, 40.00);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(50),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Payments (order_id, payment_date, payment_method, amount) VALUES
(1, '2024-05-01', 'Credit Card', 1000.00),
(2, '2024-05-03', 'PayPal', 600.00),
(3, '2024-06-10', 'Credit Card', 150.00),
(4, '2024-06-15', 'Debit Card', 880.00);


SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Payments;
-- Total Revenue
SELECT SUM(amount) AS total_revenue
FROM Payments;

-- Monthly Revenue Trend

SELECT 
DATE_FORMAT(payment_date, '%y-%m') AS month,
SUM(amount) AS monthly_revenue
FROM Payments
GROUP BY month
ORDER BY month;


-- Top 5 Best-Selling Products
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_sold
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;

-- Average Order Value
SELECT 
    AVG(order_total) AS avg_order_value
FROM (
    SELECT SUM(quantity * price) AS order_total
    FROM Order_Items
    GROUP BY order_id
) t;

-- Customer Retention (Repeat Buyers)
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

CREATE INDEX idx_customer ON Orders(customer_id);
CREATE INDEX idx_product ON Order_Items(product_id);

-- Trigger: Reduce Stock After Order
CREATE TRIGGER reduce_stock
AFTER INSERT ON Order_Items
FOR EACH ROW
UPDATE Products
SET stock = stock - NEW.quantity
WHERE product_id = NEW.product_id;

-- Create a Sales View


CREATE VIEW sales_summary AS
SELECT 
    o.order_id,
    c.first_name,
    SUM(oi.quantity * oi.price) AS total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;












