create database project1;
use project1;
-- Create the Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,    -- Primary key
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);
describe customers;
show tables;

-- Create the Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,     -- Primary key
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);

-- Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,       -- Primary key
    OrderDate DATE,
    Quantity INT,
    CustomerID INT,                -- Foreign key
    ProductID INT,                 -- Foreign key
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),  -- Foreign key constraint
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)      -- Foreign key constraint
);

-- Insert 10 rows into Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, Email)
VALUES 
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com'),
(4, 'Bob', 'Williams', 'bob.williams@example.com'),
(5, 'Eve', 'Davis', 'eve.davis@example.com'),
(6, 'Tom', 'Brown', 'tom.brown@example.com'),
(7, 'Sara', 'Miller', 'sara.miller@example.com'),
(8, 'Mike', 'Wilson', 'mike.wilson@example.com'),
(9, 'Emma', 'Taylor', 'emma.taylor@example.com'),
(10, 'David', 'Clark', 'david.clark@example.com');

-- Insert 10 rows into Products table
INSERT INTO Products (ProductID, ProductName, Price)
VALUES 
(1, 'Laptop', 100000.00),
(2, 'Smartphone', 80000.00),
(3, 'Tablet', 40000.00),
(4, 'Monitor', 20000.00),
(5, 'Keyboard', 500.00),
(6, 'Mouse', 250.00),
(7, 'Headphones', 1000.00),
(8, 'Printer', 15000.00),
(9, 'Camera', 50000.00),
(10, 'Speaker', 1200.00);

-- Insert 10 rows into Orders table
INSERT INTO Orders (OrderID, OrderDate, Quantity, CustomerID, ProductID)
VALUES 
(101, '2024-09-01', 1, 1, 1),  -- John Doe ordered 1 Laptop
(102, '2024-09-02', 2, 2, 2),  -- Jane Smith ordered 2 Smartphones
(103, '2024-09-03', 1, 3, 3),  -- Alice Johnson ordered 1 Tablet
(104, '2024-09-04', 3, 4, 5),  -- Bob Williams ordered 3 Keyboards
(105, '2024-09-05', 1, 5, 7),  -- Eve Davis ordered 1 Headphones
(106, '2024-09-06', 4, 6, 6),  -- Tom Brown ordered 4 Mice
(107, '2024-09-07', 2, 7, 4),  -- Sara Miller ordered 2 Monitors
(108, '2024-09-08', 5, 8, 9),  -- Mike Wilson ordered 5 Cameras
(109, '2024-09-09', 3, 9, 10), -- Emma Taylor ordered 3 Speakers
(110, '2024-09-10', 2, 10, 8); -- David Clark ordered 2 Printers

alter table customers change FirstName name VARCHAR(50);

-- Retrieve all customer names and their corresponding order dates.
SELECT name FROM Customers WHERE CustomerID IN (SELECT CustomerID FROM Orders);


-- List all products ordered along with their order quantity and order date.
SELECT ProductName  FROM Products WHERE ProductID IN (SELECT ProductID FROM Orders);


-- Find the total number of orders placed by each customer.
select CustomerID,sum(Quantity) from orders group by CustomerID;

-- Retrieve the names of customers who ordered the product 'Laptop'.
select name from customers where CustomerID in (select CustomerID from orders where ProductID=1);

-- Find the total amount spent by each customer (multiply quantity by product price).
SELECT FirstName, LastName, (SELECT SUM(Quantity * (SELECT Price FROM Products WHERE Products.ProductID = Orders.ProductID)) 
        FROM Orders WHERE Orders.CustomerID = Customers.CustomerID) AS TotalSpent FROM Customers WHERE CustomerID IN (SELECT CustomerID FROM Orders);

-- List all orders where the quantity ordered is greater than 1.
select * from Orders where Quantity>1;

-- Retrieve all customers who haven't placed any orders.
select * from Customers where CustomerID not in (select CustomerID from Orders);

-- Calculate the total revenue generated from all orders.
SELECT SUM(Quantity * 
           (SELECT Price 
            FROM Products 
            WHERE Products.ProductID = Orders.ProductID)) AS TotalRevenue FROM Orders;

-- Retrieve the customer who placed the highest number of orders.
select CustomerID ,count(OrderID) from orders group by CustomerID order by count(OrderID) desc limit 1; 

-- Find the average quantity of products ordered per order.
select avg(Quantity) from orders ;

-- List all orders placed on or after a specific date, such as '2024-09-03'.
select * from Orders where OrderDate>='2024-09-03';

-- Retrieve the products that have not been ordered by any customer.
select ProductName from Products where ProductID not in (select ProductID from orders);

-- Find the customer who spent the most money on orders.
SELECT Customers.name, SUM(Orders.Quantity * Products.Price) AS TotalSpent FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID JOIN Products ON Orders.ProductID = Products.ProductID
GROUP BY Customers.CustomerID ORDER BY TotalSpent DESC LIMIT 1;

-- List all orders with a total amount (quantity * price) greater than $1000.
SELECT Orders.OrderID, Orders.OrderDate, (Orders.Quantity * Products.Price) AS TotalAmount FROM Orders
JOIN Products ON Orders.ProductID = Products.ProductID HAVING TotalAmount > 1000;
