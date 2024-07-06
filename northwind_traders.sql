--OVERVIEW--
--1. What is the net sales?--(total revenue)
SELECT SUM((quantity*unitprice)-discount)AS netsales
FROM order_details

SELECT
    SUM(od.unitprice * od.quantity * (1 - od.discount)) AS net_sales
FROM
    order_details od
    JOIN orders o ON od.orderid = o.orderid
    JOIN customers c ON o.customerid = c.customerid

SELECT * FROM order_details
--2. How many orders have been processed?
SELECT COUNT(DISTINCT orderid) AS total_orders
FROM order_details

--3. How many products has been sold?
SELECT SUM(quantity)
FROM order_details

--4. What is the total amount of discounts?
SELECT SUM(discount) AS total_amount_discount
FROM order_details
--5. What is the sales trend over the months?
SELECT SUM(quantity*unitprice) AS sales, TO_CHAR(orderdate,'Month') AS month
FROM order_details AS od
JOIN orders AS o
ON od.orderid=o.orderid
GROUP BY month
ORDER BY sales DESC
	
--PRODUCTS--
SELECT * FROM products
--1. How many products are in the catalog?
SELECT COUNT(DISTINCT productname)
FROM products
	
--2. What are the top 5 selling products
SELECT productname AS product,SUM(quantity*od.unitprice) AS revenue
FROM products as p
JOIN order_details as od
ON p.productid=od.productid
GROUP BY product
ORDER BY revenue DESC
LIMIT 5
	
--3. Which category has the most purchases
SELECT categoryname, SUM(quantity*od.unitprice) AS revenue_by_category
FROM categories as c
JOIN products as p
ON c.categoryid=p.categoryid
JOIN order_details as od
ON od.productid=p.productid
GROUP BY categoryname
ORDER BY revenue_by_category DESC

--23. How many categories of products
SELECT categoryname
FROM categories 
	
--4. How many products have been discontinued
SELECT discontinued, SUM(productid)
FROM products
GROUP BY discontinued

--5. Which category has the most discounted products
SELECT SUM(discount), categoryname
FROM order_details AS od
JOIN products AS p
ON od.productid=p.productid
JOIN categories AS c
ON p.categoryid=c.categoryid
GROUP BY categoryname
ORDER BY SUM(discount) DESC

--CUSTOMERS--
SELECT *
FROM customers
--1. How many customers have been attended to
SELECT COUNT(DISTINCT customerid)
FROM customers
	
--2. In which country are these customers located
SELECT contactname, country
FROM customers

SELECT COUNT(DISTINCT Country) AS numberofcountries
FROM customers


	
--3. Who are the top 5 customers by net sale
SELECT contactname, SUM(quantity*unitprice-discount) AS netsales
FROM order_details AS od
JOIN orders AS o
ON od.orderid=o.orderid
JOIN customers AS c
ON c.customerid=o.customerid
GROUP BY contactname
ORDER BY netsales DESC
LIMIT 5

--4. Who are the top 5 customers by products bought & orders
SELECT SUM(productid) AS productid, contactname
FROM order_details AS od
JOIN orders AS o
ON o.orderid=od.orderid
JOIN customers AS c
ON c.customerid=o.customerid
GROUP BY contactname
ORDER BY productid DESC
	
--5. Which country has the most sales
SELECT country, SUM(quantity*unitprice) AS sales
FROM order_details AS od
JOIN orders AS o
ON od.orderid=o.orderid
JOIN customers AS c
ON o.customerid=c.customerid
GROUP BY country
ORDER BY sales DESC


--SHIPPING--
--1. Which shipping company is used the most
SELECT  SUM(orderid), companyname
FROM orders AS o
JOIN shippers AS s
ON o.shipperid=s.shipperid
GROUP BY companyname
ORDER BY SUM(orderid) DESC
	
--2. How many orders have been shipped & unshipped
SELECT
    COUNT(CASE WHEN ShippedDate IS NOT NULL THEN OrderID END) AS ShippedOrders,
    COUNT(CASE WHEN ShippedDate IS NULL THEN OrderID END) AS UnshippedOrders
FROM
    orders;
	
--3. How much freight was paid to the shippers
SELECT SUM(freight) AS total_freight, companyname
FROM orders AS o
JOIN shippers AS s
ON o.shipperid=s.shipperid
GROUP BY companyname
ORDER BY total_freight DESC
--4. What is the on time delivery date
SELECT
    OrderID,
    OrderDate,
    RequiredDate,
    ShippedDate,
    CASE
        WHEN ShippedDate <= RequiredDate THEN ShippedDate
        ELSE NULL  -- or any other value indicating late delivery
    END AS OnTimeDeliveryDate
FROM
    orders
ORDER BY
    OrderID;


--5. How many products were delivered on time,late and not shipped
SELECT
    CASE
        WHEN ShippedDate IS NULL THEN 'Not Shipped'
        WHEN ShippedDate <= RequiredDate THEN 'On Time'
        ELSE 'Late'
    END AS DeliveryStatus,
    COUNT(*) AS ProductCount
FROM
    orders
GROUP BY
    DeliveryStatus
ORDER BY
    DeliveryStatus;


	
--EMPLOYEES--
SELECT *
FROM employees
--1. How many employees work in the offices
SELECT COUNT(DISTINCT employeeid) 
FROM employees

--2. Who is the most active employee in terms of sales made
SELECT SUM(quantity*unitprice) AS sales, o.employeeid, employeename
FROM order_details AS od
JOIN orders AS o
ON od.orderid=o.orderid
JOIN employees AS e
ON e.employeeid=o.employeeid
GROUP BY employeename,o.employeeid
ORDER BY sales DESC
LIMIT 1
	
--3. Which employee has handled the most orders
SELECT orderid, o.employeeid, employeename
FROM orders AS o
JOIN employees AS e
ON o.employeeid=e.employeeid
GROUP BY employeename,o.employeeid,orderid

--4. What are the offices order and sales performance
SELECT
   country AS OfficeLocation,
    COUNT(o.OrderID) AS OrderCount,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales,
    AVG(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS AvgOrderAmount
FROM
    orders AS o
JOIN
    order_details AS od ON o.orderid= od.orderid
JOIN
    employees AS e ON o.employeeid = e.employeeid
GROUP BY
   country
ORDER BY
    TotalSales DESC;

SELECT *
FROM employees






-- Query to calculate total net sales for Northwind Traders
SELECT
    SUM((od.unit_price * od.quantity) - (od.discount * od.quantity)) AS total_net_sales
FROM
    orders o
JOIN
    order_details od ON o.order_id = od.order_id
JOIN
    customers c ON o.customer_id = c.customer_id
WHERE
    c.company_name = 'Northwind Traders';

SELECT
    SUM(od.unitprice * od.quantity * (1 - od.discount)) AS net_sales
FROM
    order_details od
    JOIN orders o ON od.orderid = o.orderid
    JOIN customers c ON o.customerid = c.customerid
WHERE
    c.company_name = 'Northwind Traders';

--TOTAL QUANTITY ORDERED--
SELECT
    SUM(od.quantity) AS total_quantity_ordered
FROM
    order_details od
    JOIN orders o ON od.orderid = o.orderid
    JOIN customers c ON o.customerid = c.customerid
WHERE
    c.company_name = 'Northwind Traders';


WITH CategoryOrders AS (
    SELECT 
        c.CategoryName,
        COUNT(od.OrderID) AS NumberOfOrders
    FROM 
        Order_Details od
    JOIN 
        Products p ON od.ProductID = p.ProductID
    JOIN 
        Categories c ON p.CategoryID = c.CategoryID
    GROUP BY 
        c.CategoryName
)
SELECT 
    *,
    (NumberOfOrders * 100.0 / (SELECT SUM(NumberOfOrders) FROM CategoryOrders)) AS Percentage
FROM 
    CategoryOrders;

--PRODUCT PERFORMANCE BY REVENUE--
SELECT COUNT(DISTINCT productname) AS products, categoryname,quantity,  SUM(quantity*od.unitprice) AS revenue
FROM 
        Order_Details od
    JOIN 
        Products p ON od.ProductID = p.ProductID
    JOIN 
        Categories c ON p.CategoryID = c.CategoryID
GROUP BY categoryname,quantity
ORDER BY revenue DESC
LIMIT 10

SELECT
    p.ProductName,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS Revenue
FROM
    Order_Details od
JOIN
    Products p ON od.ProductID = p.ProductID
GROUP BY
    p.ProductID, p.ProductName
ORDER BY
    Revenue 

SELECT
    c.CompanyName,c.city,c.country,
    COUNT(o.OrderID) AS NumberOfOrders,
	SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS Revenue
FROM
    Orders o
JOIN
    Customers c ON o.CustomerID = c.CustomerID
JOIN
	order_details od ON od.orderid=o.orderid
GROUP BY
    c.CompanyName,city,country
ORDER BY
    NumberOfOrders 
LIMIT 10

SELECT
    Country,
    COUNT(CustomerID) AS NumberOfCustomers
FROM
    Customers
GROUP BY
    Country
ORDER BY
    NumberOfCustomers DESC;

SELECT
    AVG(EXTRACT(EPOCH FROM ShippedDate - OrderDate) / 86400) AS AverageDaysToShip
FROM
    Orders
WHERE
    ShippedDate IS NOT NULL;





