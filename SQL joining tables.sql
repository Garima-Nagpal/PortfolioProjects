--DATA CLEANING AND JOINING SEVERAL TABLES FOR THE PURPOSE OF DATA VISULAIZATION


--looking at the total price a customer paid 

SELECT
             ROUND(od.quantity*od.unitPrice * (1 - discount/100) + o.freight,0) as total_price, 
             od.productID, o.orderID, o.employeeID, o.shipperID, o.customerID
FROM dbo.orders o
				JOIN dbo.order_details od
				ON o.orderID = od.orderID
WHERE shippedDate is not null
ORDER BY total_price desc

                          (  ---side note --another way of calculating  new column in order_details table using CTE method without freight

							WITH priceCTE AS 
												(SELECT ROUND(quantity*unitPrice,0) as price, *
												FROM order_details)

								SELECT price * (1 - discount/100) AS total_price, *
								FROM  priceCTE
								ORDER BY total_price desc    ---)

--saved our last table as calculated_price and joined with other tables while also doing some data cleaning


SELECT cp.orderID ,cp.customerID,cp.employeeID, cp.shipperID, cp.total_price, 
       p.productID, p.productName, 
	   c.categoryID, c.categoryName, c.description
FROM dbo.products p
			JOIN dbo.calculated_price cp
			ON cp.productID = p.productID
			JOIN dbo.categories c
			ON p.categoryID = c.categoryID
WHERE p.discontinued = '0'

--saved and imported the above "table" to join with our last three tables to get the final table required for data visualization

SELECT t.orderID ,t.customerID, 
		cu.companyName, cu.city, cu.country, 
		t.total_price, t.productID, t.productName, 
		t.categoryID, t.categoryName, t.description , 
		t.employeeID, e.employeeName, e.title, 
		t.shipperID, s.companyName
FROM dbo.new_table t
				JOIN dbo.employees e
				ON t.employeeID = e.employeeID
				JOIN dbo.customers cu
				ON t.customerID = cu.customerID
				JOIN dbo.shippers s
				ON t.shipperID = s.shipperID
WHERE e.reportsTo is not null 






