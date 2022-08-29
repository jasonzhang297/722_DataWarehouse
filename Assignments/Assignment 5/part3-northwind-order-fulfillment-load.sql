use ist722_yzhan297_dw
;

--load Employees
insert into [mynorth].[DimEmployee]
			([EmployeeID],[FirstName],[LastName],[FullName],[EmployeeTitle],[BirthDate],[HireDate],[EmployeeAddressRegion],
			[SupervisorFullName],[RowIsCurrent],[RowStartDate],[RowEndDate],[RowChangeReason],[InsertAuditKey],[UpdateAuditKey])
select EmployeeID,FirstName,LastName, FirstName + ' ' + LastName as FullName, [Title], [BirthDate], [HireDate], 
		case when [Region] is null then 'N/A' else [Region] end, [Reportsto],'Y','12/31/1899', '12/31/9999', 'NA', -1, -1
from [ist722_yzhan297_stage].[dbo].[stgmynorthEmployees]

--load Customers
insert into [mynorth].[DimCustomer]
			([CustomerID],[CustomerName],[ContactName],[ContactTitle],[CustomerCountry],[CustomerRegion],[CustomerCity],[CustomerPostalCode],
			[RowIsCurrent],[RowStartDate],[RowEndDate],[RowChangeReason],[InsertAuditKey],[UpdateAuditKey])
select [CustomerID],[CompanyName],[ContactName],[ContactTitle],[Country],case when [Region] is null then 'N/A' else [Region] end,
		[City],case when [PostalCode] is null then 'N/A' else [PostalCode] end,'Y','12/31/1899', '12/31/9999', 'NA', -1, -1
from [ist722_yzhan297_stage].[dbo].[stgmynorthCustomers]

--load Products
insert into [mynorth].[DimProduct]
			([ProductID],[ProductName],[QuantityPerUnit],[UnitPrice],[UnitsInStock],[UnitsOnOrder],[ReorderLevel],[Dicontinued],
			[RowIsCurrent],[RowStartDate],[RowEndDate],[RowChangeReason],[InsertAuditKey],[UpdateAuditKey])
select [ProductID],[ProductName],[QuantityPerUnit],[UnitPrice],[UnitsInStock],[UnitsOnOrder],[ReorderLevel],[Discontinued],'Y','12/31/1899', '12/31/9999', 'NA', -1, -1
from [ist722_yzhan297_stage].[dbo].[stgmynorthProducts]

--load Date
insert into [mynorth].[DimDate]
			([DateKey],[Date],[FullDateUSA],[DayOfWeek],[DayName],[DayOfMonth],[DayOfYear],[WeekOfYear],[MonthName],
			[MonthOfYear],[Quarter],[QuarterName],[Year],[IsWeekday])
select [DateKey],[Date],[FullDateUSA],[DayOfWeekUSA],[DayName],[DayOfMonth],[DayOfYear],[WeekOfYear],[MonthName],[Month],[Quarter],[QuarterName],[Year],[IsWeekday]
from [ist722_yzhan297_stage].[dbo].[stgmynorthDates]

--load factSales
delete from [ist722_yzhan297_dw].[mynorth].DimProduct where ProductKey = -1
delete from [ist722_yzhan297_dw].[mynorth].DimEmployee where EmployeeKey = -1

insert into [mynorth].[FactSales]
			([ProductKey],[CustomerKey],[EmployeeKey],[OrderDateKey],[ShippedDateKey],[OrderID],[Quantity],[UnitPrice],
			[DiscountedAmount],[SoldAmount],[FreightAmount],[InsertAuditKey],[UpdateAuditKey])
select p.ProductKey,c.CustomerKey,e.EmployeeKey,[ExternalSources2].[dbo].[getDateKey](s.OrderDate) as OrderDateKey,
case when [ExternalSources2].[dbo].[getDateKey](s.ShippedDate) is null then -1
else [ExternalSources2].[dbo].[getDateKey](s.ShippedDate) end as ShippedDateKey, s.OrderID, Quantity,s.UnitPrice,
			Quantity*s.UnitPrice*Discount as DiscountAmount,
			Quantity*s.UnitPrice*(1-Discount) as SoldAmount,
			Quantity*s.UnitPrice*(1-Discount)/Quantity as FreightAmount,-1,-1
from [ist722_yzhan297_stage].[dbo].[stgmynorthSales] s
		join [ist722_yzhan297_dw].[mynorth].DimCustomer c on s.CustomerID = c.CustomerID
		join [ist722_yzhan297_dw].[mynorth].DimEmployee e on s.EmployeeID = e.EmployeeID
		join [ist722_yzhan297_dw].[mynorth].DimProduct p on s.ProductID = p.ProductID

--load factOrderFulfillment
insert into [mynorth].[FactOrderFulfillment]([ProductKey],[OrderID],[OrderDateKey],[ShippedDateKey],[OrderToShippedLagInDays])
select p.ProductKey,fo.OrderID,[ExternalSources2].[dbo].[getDateKey](fo.OrderDate) as OrderDateKey, 
	case when [ExternalSources2].[dbo].[getDateKey](fo.ShippedDate) is null then -1
	else [ExternalSources2].[dbo].[getDateKey](fo.ShippedDate) end as ShippedDateKey,
	case when DATEDIFF(day, fo.OrderDate, fo.ShippedDate) is null then -1
	else DATEDIFF(day, fo.OrderDate, fo.ShippedDate) end as OrderToShippedLagInDays
from [ist722_yzhan297_stage].[dbo].[stgmynorthOrderFulfillment] fo
	join [ist722_yzhan297_dw].[mynorth].[DimProduct] p on fo.ProductID = p.ProductID