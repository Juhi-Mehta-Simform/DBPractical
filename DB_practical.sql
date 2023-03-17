CREATE DATABASE user_details;
USE user_details;

CREATE TABLE Users
(user_id INTEGER NOT NULL PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email_id VARCHAR(100),
contact_no BIGINT,
gender VARCHAR(10));

CREATE TABLE Products
(product_id INTEGER NOT NULL PRIMARY KEY,
product_name VARCHAR(50),
price INTEGER);

CREATE TABLE Orders
(order_id INTEGER NOT NULL PRIMARY KEY,
user_id INTEGER,
product_id INTEGER,  
order_status VARCHAR(50),
order_placed_date DATE,
expected_delivery_date DATE,
FOREIGN KEY(user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
FOREIGN KEY(product_id) REFERENCES Products(product_id) ON DELETE SET NULL);

CREATE TABLE Order_details
(order_id INTEGER NOT NULL ,
product_id INTEGER NOT NULL,
PRIMARY KEY(order_id, product_id));

INSERT INTO Users VALUES 
(1, 'Juhi', 'Mehta', 'juhim@gmail.com', 5678435624, 'Female');
INSERT INTO Users VALUES
(2, 'Janvi', 'Sureja', 'janvis@gmail.com', 3546782345, 'Female' );
INSERT INTO Users VALUES
(3, 'Dhruvi', 'Patel', 'dhruvip@gmail.com', 4523894676, 'Female');
INSERT INTO Users VALUES
(4, 'Meet', 'Radadia', 'meetr@gmail.com', 5438765126, 'Male');
INSERT INTO Users VALUES
(5, 'Tirth', 'Bhatt', 'tirthb@gmail.com', 6723945871, 'Male');
INSERT INTO Users VALUES
(6, 'Dev', 'Kapadia', 'devk@gmail.com', 2365975678, 'Male');
INSERT INTO Users VALUES
(7, 'Pakshal', 'Ghiya', 'pakshalg@gmail.com', 6598357612, 'Male');
INSERT INTO Users VALUES
(8, 'Khushali', 'Shah', 'khushalis@gmail.com', 6237834509, 'Female');
INSERT INTO Users VALUES
(9, 'Hinal', 'Panchal', 'Hinalp@gmail.com', 3487561245, 'Female');

INSERT INTO Products VALUES
(101, 'Apple Iphone 14', 69000);
INSERT INTO Products VALUES
(102, 'Lenovo Thinkpad', 73000);
INSERT INTO Products VALUES
(103, 'OnePlus Z Buds', 3499);
INSERT INTO Products VALUES
(104, 'Asus VivoBook', 89999);
INSERT INTO Products VALUES
(105, 'Phillips Hair Straightening Brush', 2500);
INSERT INTO Products VALUES
(106, 'Vella Hair Dryer', 1800);
INSERT INTO Products VALUES
(107, 'Loreal Paris Shampoo', 1149);
INSERT INTO Products VALUES
(108, 'Apple MacBook', 119000);
INSERT INTO Products VALUES
(109, 'Apple AirPods', 18000);
INSERT INTO Products VALUES
(110, 'Samsung Galaxy Watch 3', 21199);

INSERT INTO Orders VALUES
(1, 3, 107, 'Shipped', '2023-03-13', '2023-03-17');
INSERT INTO Orders VALUES
(2, 1, 108, 'Delivered', '2023-03-10', NULL);
INSERT INTO Orders VALUES
(3, 5, 102, 'Not Shipped', '2023-03-14', '2023-03-19');
INSERT INTO Orders VALUES
(4, 8, 105, 'Shipped', '2023-03-14', '2023-03-16');
INSERT INTO Orders VALUES
(5, 2, 107, 'Shipped', '2023-03-14', '2023-03-18');
INSERT INTO Orders VALUES
(6, 7, 110, 'Not Shipped', '2023-03-14', '2023-03-20');
INSERT INTO Orders VALUES
(7, 4, 101, 'Shipped', '2023-03-12', '2023-03-16');
INSERT INTO Orders VALUES
(8, 9, 106, 'Delivered', '2023-03-04', NULL);
INSERT INTO Orders VALUES
(9, 1, 104, 'Not Shipped', '2023-03-15', '2023-03-21');
INSERT INTO Orders VALUES
(10, 8, 109, 'Delivered', '2023-03-01', NULL);
INSERT INTO Orders VALUES
(11, 4, 110, 'Shipped', '2023-03-13', '2023-03-16');
INSERT INTO Orders VALUES
(12, 8, 106, 'Shipped', '2023-03-14', '2023-03-16');
INSERT INTO Orders VALUES
(13, 1, 105, 'Shipped', '2023-03-14', '2023-03-16');
INSERT INTO Orders VALUES
(14, 5, 103, 'Not Shipped', '2023-03-14', '2023-03-18');
INSERT INTO Orders VALUES
(15, 2, 107, 'Not Shipped', '2023-03-15', '2023-03-19');

SELECT concat(u.first_name, ' ', u.last_name) AS customer_name,
p.product_name, 
o.order_placed_date, o.order_status,
coalesce(datediff(o.expected_delivery_date, o.order_placed_date),0) AS expected_delivery_in_days
FROM Orders o INNER JOIN Products p ON p.product_id = o.product_id
INNER JOIN Users u ON u.user_id = o.user_id
ORDER BY expected_delivery_in_days DESC;

SELECT concat(u.first_name, ' ', u.last_name) AS customer_name,
p. product_name ,
o.order_status
FROM Orders o INNER JOIN Products p ON p.product_id = o.product_id
INNER JOIN Users u ON u.user_id = o.user_id
WHERE NOT o.order_status = 'delivered'
ORDER BY  o.order_status DESC;

SELECT concat(u.first_name, ' ', u.last_name) AS customer_name,
p.product_name,
o.order_placed_date
FROM Orders o INNER JOIN Products p ON p.product_id = o.product_id
INNER JOIN Users u ON u.user_id = o.user_id
ORDER BY o.order_placed_date DESC
LIMIT 5;

SELECT concat(u.first_name, ' ', u.last_name) AS customer_name,
COUNT(o.user_id) AS Total_orders
FROM Orders o INNER JOIN Users u ON u.user_id = o.user_id
GROUP BY o.user_id
ORDER BY Total_orders DESC 
LIMIT 5;

SELECT concat(u.first_name, ' ', u.last_name) AS customer_name,
IF(COUNT(o.user_id) = 0, 'Inactive User', 'Active User') AS User_status
FROM Orders o RIGHT JOIN Users u ON o.user_id = u.user_id
GROUP BY u.user_id
HAVING COUNT(o.user_id) = 0;

SELECT p.product_id, p.product_name,
COUNT(o.product_id) AS Total_purchase
FROM Orders o INNER JOIN Products p ON p.product_id = o.product_id
GROUP BY o.product_id
ORDER BY Total_purchase DESC, o.product_id ASC
LIMIT 5;

SELECT * 
FROM (SELECT p.product_id, p.product_name, p.price
FROM Orders o INNER JOIN Products p ON p.product_id = o.product_id
ORDER BY p.price DESC
LIMIT 1) AS Most_expensive_product
UNION
SELECT * 
FROM (SELECT p.product_id, p.product_name, p.price
FROM Orders o INNER JOIN Products p ON p.product_id = o.product_id
ORDER BY p.price ASC 
LIMIT 1) AS Cheapest_product;



