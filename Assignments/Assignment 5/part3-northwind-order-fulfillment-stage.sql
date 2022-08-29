use ist722_yzhan297_stage

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.stgmynorthOrderFulfillment') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.stgmynorthOrderFulfillment

--stage Customers
select [CustomerID],[CompanyName],[ContactName],[ContactTitle],[Country],[Region],[City],[PostalCode] 
into [dbo].[stgmynorthCustomers]
from [Northwind].[dbo].[Customers]

--stage Employees
select [EmployeeID],[FirstName],[LastName],[Title],[BirthDate],[HireDate],[Region],[ReportsTo],[Notes]
into [dbo].[stgmynorthEmployees]
from [Northwind].[dbo].[Employees]

--stage Products
select [ProductID],[ProductName],[QuantityPerUnit],[UnitPrice],[UnitsInStock],[UnitsOnOrder],[ReorderLevel],[Discontinued]
into [dbo].[stgmynorthProducts]
from [Northwind].[dbo].[Products] p
	join [Northwind].[dbo].Suppliers s
		on  p.[SupplierID] = s.[SupplierID]
	join [Northwind].[dbo].Categories c
		on  c.[CategoryID] = p.[CategoryID]

--stage Date
select * into [dbo].[stgmynorthDates]
from [ExternalSources2].[dbo].[date_dimension]
where year between 1996 and 1998

--stage factOrderFulfillment
select [ProductID],d.[OrderID],[OrderDate],[ShippedDate]
into [dbo].[stgmynorthOrderFulfillment]
from [Northwind].[dbo].[Order Details] d
	join [Northwind].[dbo].[Orders] o
		on o.[OrderID] = d.[OrderID]

--stage factsales
select [ProductID],d.[OrderID],[CustomerID],[EmployeeID],[OrderDate],[ShippedDate],[UnitPrice],[Quantity],[Discount]
into [dbo].[stgmynorthSales]
from [Northwind].[dbo].[Order Details] d
	join [Northwind].[dbo].[Orders] o
		on o.[OrderID] = d.[OrderID]