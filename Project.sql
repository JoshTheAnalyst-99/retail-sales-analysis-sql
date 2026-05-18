CREATE DATABASE Portfolio;

USE Portfolio;

-- 1. Find the salesperson who generated the highest total revenue across all time. Include their total sales count and total amount.
SELECT TOP 1
	[Sales Rep],
	COUNT(*) AS Total_Sales,
	SUM(Revenue) AS Total_Revenue
FROM [Sales table]
GROUP BY [Sales Rep]
ORDER BY Total_Revenue DESC;
-- Ethan generated the highest revenue with 215 sales totaling 1,815,241.

-- 2. Find the top 5 products by total quantity ordered.
SELECT TOP 5
	OT.product_id,
	P.[Name],
	SUM(Quantity) AS Total_Quantity,
	[Status]
FROM order_items OT
JOIN Orders O
ON
OT.Order_ID = O.Order_ID
JOIN Products P
ON 
P.product_id = OT.product_id
WHERE [Status] = 'Completed'
GROUP BY P.[Name], OT.product_id, status
ORDER BY Total_Quantity DESC;
-- From my analysis, i observed that sunglasses, backpacks, running shoes, jam and resistance band where the top 5 product high in demand.

-- 3. Find all customers whose total order count is 5 or more. Show customer ID and their order count.
SELECT 
	Customer_ID,
	COUNT(order_id) Order_Count
FROM Orders
GROUP BY Customer_ID
HAVING COUNT(order_id) >= 5
ORDER BY customer_id
-- This analysis shows that 9 customers ordered 5 products and above from the orders table

-- 4. Show total sales amount per month for the past 12 months, ordered chronologically.
SELECT
	FORMAT(Sale_Date, 'yyyy-MM') AS Dates,
	ROUND(SUM(Amount),2) AS Total_Amount
FROM sales
WHERE Sale_Date >= DATEADD(MONTH, -12, GETDATE())
GROUP BY FORMAT(Sale_Date, 'yyyy-MM') 
ORDER BY Dates
-- From my analysis, i observed that the total sales amount was at its highest in the month of March 2026 and its lowest in May 2026

-- 5. From the transactions table, find accounts where total debits exceed total credits — meaning they are in a net negative position
WITH Debit AS (
	SELECT 
	Account_ID,
	SUM(Amount) AS Debit_total 
FROM transactions
WHeRE[type] = 'Debit' 
GROUP BY account_id
), Credit AS (
	SELECT 
	Account_ID,
	SUM(Amount) AS Credit_total
FROM transactions 
WHERE[type] = 'Credit'
GROUP BY account_id
) 
SELECT 
	D.Account_ID,
	D.Debit_total,
	C.Credit_total
FROM Debit D
JOIN Credit C
ON
C.account_id = D.account_id
WHERE D.Debit_total > C.Credit_total
-- From the above, analysis 3 account had their debit higher than their credit

-- 6. Find all products that appear in the products table but have never been ordered in order_items.
SELECT 
    P.Product_ID,
    P.[Name]
FROM Products P
LEFT JOIN Order_items O ON P.Product_ID = O.Product_ID
WHERE O.Product_ID IS NULL;

-- 7. List all employees who earn more than their own department's average salary. Show name, department, salary, and the dept average.
SELECT
	[Name],
	Salary,
	Department_Average
FROM (
SELECT 
	[Name],
	department_id,
	Salary,
	AVG(Salary) OVER (PARTITION BY Department_ID) AS Department_Average
FROM Employees
) AS E
WHERE Salary > E.Department_Average 

-- 8. Calculate the total revenue per product category (price × quantity from order_items joined to products).
SELECT 
	p.Category,
	ROUND(SUM((p.price * o.quantity)),1) AS Revenue
FROM Products p
JOIN order_items o
ON
P.product_id = O.product_id
GROUP BY p.Category
ORDER BY Revenue DESC
-- From this analysis, Grocery had the highest revenue per category of 110,312.10, while clothing had the lowest of about 52,677.70