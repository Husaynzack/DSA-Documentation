create database KMS_db
select * from dbo.KMS_Sql_Case_Study

---Question 1---
---Product Category with the highest Sales---
SELECT TOP 10 Product_Category, Sales
FROM KMS_Sql_Case_Study
ORDER BY Sales DESC
;

---Question 2---
---Top 3 and Bottom 3 regions in terms of Sales---
SELECT Region, Sales
FROM
(
SELECT TOP 3 Region, Sales
FROM KMS_Sql_Case_Study
ORDER BY Sales DESC
) AS Top3

UNION ALL

SELECT Region, Sales
FROM
(
SELECT TOP 3 Region, Sales
FROM KMS_Sql_Case_Study
ORDER BY Sales ASC
) AS Bottom3;

---Question 3---
---Total Sales of appliances in Ontario---
SELECT SUM(Sales) as Total_Sales
from KMS_Sql_Case_Study
where Product_Sub_Category = 'Appliances' and Province = 'Ontario'
;

------Question 4-----
Select Top 10
(Customer_name), Sum
((Sales)) As Total Sales
From KMS Case Study
Group by (Customer_Name)
Order by Total Sales Asc;

---Question 5---
---The most expensive shipping method---
SELECT TOP 1 Ship_Mode, Shipping_Cost
FROM KMS_Sql_Case_Study
ORDER BY Shipping_Cost DESC
;

----Question 6
--the most valuable customers, and what products or services do they typically purchase?---
WITH Customer_Sales AS (
    SELECT 
        TRIM(UPPER([Customer_Name])) AS Customer_Name,
        SUM([Sales]) AS Total_Sales
    FROM KMS_Order
    GROUP BY TRIM(UPPER([Customer_Name]))
),

Top_Customers AS (
    SELECT TOP 10 Customer_Name, Total_Sales
    FROM Customer_Sales
    ORDER BY Total_Sales DESC
),

Customer_Category_Sales AS (
    SELECT 
        TRIM(UPPER(o.[Customer_Name])) AS Customer_Name, 
        o.[Product_Category],
        SUM(o.[Sales]) AS Category_Sales
    FROM KMS_Order AS o
    JOIN Top_Customers AS tc
        ON TRIM(UPPER(o.[Customer_Name])) = tc.Customer_Name
    GROUP BY TRIM(UPPER(o.[Customer_Name])), o.[Product_Category]
)

SELECT 
    ccs.Customer_Name,
    ccs.Product_Category,
    ccs.Category_Sales
FROM Customer_Category_Sales AS ccs
ORDER BY ccs.Category_Sales DESC;

---Question 7---
---Small Business Customer with the highest Sales---
select top 1 *
from [dbo].[KMS_Sql_Case_Study]
where customer_segment = 'small business'
order by sales desc

---question 8---
--most number of orders in 2009 – 2012--
select top 1 *
from [dbo].[KMS_Sql_Case_Study]
where customer_segment = 'corporate'
order by order_quantity desc

-----question 9---
--most profitable customer---
select top 1 *
from [dbo].[KMS_Sql_Case_Study]
where customer_segment = 'consumer'
order by profit desc

-----question 10---
----returned item to a particular segment---
select customer_name, customer_segment, product_category, product_sub_category
from [dbo].[KMS_Sql_Case_Study]
join [dbo].[order_status]
on [dbo].[KMS SQL case study].order_ID = [dbo].[order_status].order_ID

----Question 11---

SELECT 
    (Order_Priority),
    (Ship_Mode),
    COUNT(*) AS Number_Of_Orders,
    SUM(Shipping_Cost) AS Tota_lShipping_Cost,
    AVG(Shipping_Cost) AS Avg_Shipping_Cost
FROM 
    KMS_Sql_Case_Study 
GROUP BY 
    (Order_Priority), (ShipMode)
ORDER BY 
    CASE (Order & Priority )
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
        ELSE 5
    END,
    Ship_Mode;