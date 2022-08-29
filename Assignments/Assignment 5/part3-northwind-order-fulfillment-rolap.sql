/****** Object:  Database ist722_yzhan297_dw    Script Date: 8/15/2022 1:11:17 AM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 1

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE ist722_yzhan297_dw
GO
CREATE DATABASE ist722_yzhan297_dw
GO
ALTER DATABASE ist722_yzhan297_dw
SET RECOVERY SIMPLE
GO
*/
USE ist722_yzhan297_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;





-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
CREATE SCHEMA mynorth
GO

/* Drop table mynorth.FactSales */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'mynorth.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE mynorth.FactSales 
;

/* Drop table mynorth.FactOrderFulfillment */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'mynorth.FactOrderFulfillment') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE mynorth.FactOrderFulfillment 
;

/* Drop table mynorth.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'mynorth.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE mynorth.DimCustomer 
;

/* Create table mynorth.DimCustomer */
CREATE TABLE mynorth.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  nvarchar(5)   NOT NULL
,  [CustomerName]  nvarchar(40)   NOT NULL
,  [ContactName]  nvarchar(30)   NULL
,  [ContactTitle]  nvarchar(30)   NOT NULL
,  [CustomerCountry]  nvarchar(15)   NOT NULL
,  [CustomerRegion]  nvarchar(15)  DEFAULT 'N/A' NOT NULL
,  [CustomerCity]  nvarchar(15)   NOT NULL
,  [CustomerPostalCode]  nvarchar(10)   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_mynorth.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT mynorth.DimCustomer ON
;
INSERT INTO mynorth.DimCustomer (CustomerKey, CustomerID, CustomerName, ContactName, ContactTitle, CustomerCountry, CustomerRegion, CustomerCity, CustomerPostalCode, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES (-1, '', '', '', '', '', 'NA', '', '', 'Y', '12/31/1899', '12/31/9999', 'NA', -1, -1)
;
SET IDENTITY_INSERT mynorth.DimCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[mynorth].[Customer]'))
DROP VIEW [mynorth].[Customer]
GO
CREATE VIEW [mynorth].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CustomerName] AS [CustomerName]
, [ContactName] AS [ContactName]
, [ContactTitle] AS [ContactTitle]
, [CustomerCountry] AS [CustomerCountry]
, [CustomerRegion] AS [CustomerRegion]
, [CustomerCity] AS [CustomerCity]
, [CustomerPostalCode] AS [CustomerPostalCode]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM mynorth.DimCustomer
GO



/* Drop table mynorth.DimEmployee */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'mynorth.DimEmployee') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE mynorth.DimEmployee 
;

/* Create table mynorth.DimEmployee */
CREATE TABLE mynorth.DimEmployee (
   [EmployeeKey]  int IDENTITY  NOT NULL
,  [EmployeeID]  int   NOT NULL
,  [FirstName]  nvarchar(50)   NOT NULL
,  [LastName]  nvarchar(50)   NOT NULL
,  [FullName]  nvarchar(100)   NOT NULL
,  [EmployeeTitle]  nvarchar(50)   NOT NULL
,  [BirthDate]  datetime   NOT NULL
,  [HireDate]  datetime  DEFAULT '9999-01-01' NOT NULL
,  [EmployeeAddressRegion]  nvarchar(15)   NOT NULL
,  [SupervisorFullName]  nvarchar(100)   NULL
,  [EmployeeNotes]  nvarchar   NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '9999-01-01' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_mynorth.DimEmployee] PRIMARY KEY CLUSTERED 
( [EmployeeKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT mynorth.DimEmployee ON
;
SET ANSI_WARNINGS OFF
INSERT INTO mynorth.DimEmployee (EmployeeKey, EmployeeID, FirstName, LastName, FullName, EmployeeTitle, BirthDate, HireDate, EmployeeAddressRegion, SupervisorFullName, EmployeeNotes, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES (-1, 1, '', '', '', '', '', '', 'N/A', '', 'N/A', 'Y', '9999-01-01', '9999-01-01', 'NA', -1, -1)
;
SET IDENTITY_INSERT mynorth.DimEmployee OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[mynorth].[Employee]'))
DROP VIEW [mynorth].[Employee]
GO
CREATE VIEW [mynorth].[Employee] AS 
SELECT [EmployeeKey] AS [EmployeeKey]
, [EmployeeID] AS [EmployeeID]
, [FirstName] AS [FirstName]
, [LastName] AS [LastName]
, [FullName] AS [FullName]
, [EmployeeTitle] AS [EmployeeTitle]
, [BirthDate] AS [BirthDate]
, [HireDate] AS [HireDate]
, [EmployeeAddressRegion] AS [EmployeeAddressRegion]
, [SupervisorFullName] AS [SupervisorFullName]
, [EmployeeNotes] AS [EmployeeNotes]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM mynorth.DimEmployee
GO




/* Drop table mynorth.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'mynorth.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE mynorth.DimProduct 
;

/* Create table mynorth.DimProduct */
CREATE TABLE mynorth.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [ProductName]  nvarchar(50)   NOT NULL
,  [QuantityPerUnit]  nvarchar(50)   NOT NULL
,  [UnitPrice]  money   NOT NULL
,  [UnitsInStock]  smallint   NOT NULL
,  [UnitsOnOrder]  smallint   NOT NULL
,  [ReorderLevel]  smallint  DEFAULT 12/31/9999 NOT NULL
,  [Dicontinued]  bit   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_mynorth.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT mynorth.DimProduct ON
;
INSERT INTO mynorth.DimProduct (ProductKey, ProductID, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Dicontinued, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES (-1, 1, '', '', 1, 1, 1, 1, 1, 'Y', '12/31/1899', '12/31/9999', 'NA', -1, -1)
;
SET IDENTITY_INSERT mynorth.DimProduct OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[mynorth].[Product]'))
DROP VIEW [mynorth].[Product]
GO
CREATE VIEW [mynorth].[Product] AS 
SELECT [ProductKey] AS [ProductKey]
, [ProductID] AS [ProductID]
, [ProductName] AS [ProductName]
, [QuantityPerUnit] AS [QuantityPerUnit]
, [UnitPrice] AS [UnitPrice]
, [UnitsInStock] AS [UnitsInStock]
, [UnitsOnOrder] AS [UnitsOnOrder]
, [ReorderLevel] AS [ReorderLevel]
, [Dicontinued] AS [Dicontinued]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM mynorth.DimProduct
GO


/* Drop table mynorth.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'mynorth.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE mynorth.DimDate 
;

/* Create table mynorth.DimDate */
CREATE TABLE mynorth.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  date   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  smallint   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  smallint   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_mynorth.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

INSERT INTO mynorth.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[mynorth].[Date]'))
DROP VIEW [mynorth].[Date]
GO
CREATE VIEW [mynorth].[Date] AS 
SELECT [DateKey] AS [DateKey]
, [Date] AS [Date]
, [FullDateUSA] AS [FullDateUSA]
, [DayOfWeek] AS [DayOfWeek]
, [DayName] AS [DayName]
, [DayOfMonth] AS [DayOfMonth]
, [DayOfYear] AS [DayOfYear]
, [WeekOfYear] AS [WeekOfYear]
, [MonthName] AS [MonthName]
, [MonthOfYear] AS [MonthOfYear]
, [Quarter] AS [Quarter]
, [QuarterName] AS [QuarterName]
, [Year] AS [Year]
, [IsWeekday] AS [IsWeekday]
FROM mynorth.DimDate
GO






/* Create table mynorth.FactSales */
CREATE TABLE mynorth.FactSales (
   [ProductKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [EmployeeKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShippedDateKey]  int   NOT NULL
,  [Quantity]  smallint   NOT NULL
,  [UnitPrice]  money   NOT NULL
,  [DiscountedAmount]  money   NOT NULL
,  [SoldAmount]  money   NOT NULL
,  [FreightAmount]  money   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_mynorth.FactSales] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID] )
) ON [PRIMARY]
;



-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[mynorth].[Sales]'))
DROP VIEW [mynorth].[Sales]
GO
CREATE VIEW [mynorth].[Sales] AS 
SELECT [ProductKey] AS [ProductKey]
, [OrderID] AS [OrderID]
, [CustomerKey] AS [CustomerKey]
, [EmployeeKey] AS [EmployeeKey]
, [OrderDateKey] AS [OrderDateKey]
, [ShippedDateKey] AS [ShippedDateKey]
, [Quantity] AS [Quantity]
, [UnitPrice] AS [UnitPrice]
, [DiscountedAmount] AS [DiscountedAmount]
, [SoldAmount] AS [SoldAmount]
, [FreightAmount] AS [FreightAmount]
, [InsertAuditKey] AS [Insert Audit Key]
, [UpdateAuditKey] AS [Update Audit Key]
FROM mynorth.FactSales
GO




/* Create table mynorth.FactOrderFulfillment */
CREATE TABLE mynorth.FactOrderFulfillment (
   [ProductKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShippedDateKey]  int   NOT NULL
,  [OrderToShippedLagInDays]  smallint   NOT NULL
, CONSTRAINT [PK_mynorth.FactOrderFulfillment] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID] )
) ON [PRIMARY]
;


-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[mynorth].[OrderFulfillment]'))
DROP VIEW [mynorth].[OrderFulfillment]
GO
CREATE VIEW [mynorth].[OrderFulfillment] AS 
SELECT [ProductKey] AS [ProductKey]
, [OrderID] AS [OrderID]
, [OrderDateKey] AS [OrderDateKey]
, [ShippedDateKey] AS [ShippedDateKey]
, [OrderToShippedLagInDays] AS [OrderToShippedLagInDays]
FROM mynorth.FactOrderFulfillment
GO


--ALTER TABLE mynorth.DimCustomer ADD CONSTRAINT
--   FK_mynorth_DimCustomer_InsertAuditKey FOREIGN KEY
--   (
--   InsertAuditKey
--   ) REFERENCES mynorth.DimAudit
--   ( AuditKey )
--     ON UPDATE  NO ACTION
--     ON DELETE  NO ACTION
--;
 
--ALTER TABLE mynorth.DimCustomer ADD CONSTRAINT
--   FK_mynorth_DimCustomer_UpdateAuditKey FOREIGN KEY
--   (
--   UpdateAuditKey
--   ) REFERENCES mynorth.DimAudit
--   ( AuditKey )
--     ON UPDATE  NO ACTION
--     ON DELETE  NO ACTION
--;
 
--ALTER TABLE mynorth.DimEmployee ADD CONSTRAINT
--   FK_mynorth_DimEmployee_InsertAuditKey FOREIGN KEY
--   (
--   InsertAuditKey
--   ) REFERENCES mynorth.DimAudit
--   ( AuditKey )
--     ON UPDATE  NO ACTION
--     ON DELETE  NO ACTION
--;
 
--ALTER TABLE mynorth.DimEmployee ADD CONSTRAINT
--   FK_mynorth_DimEmployee_UpdateAuditKey FOREIGN KEY
--   (
--   UpdateAuditKey
--   ) REFERENCES mynorth.DimAudit
--   ( AuditKey )
--     ON UPDATE  NO ACTION
--     ON DELETE  NO ACTION
--;
 
--ALTER TABLE mynorth.DimProduct ADD CONSTRAINT
--   FK_mynorth_DimProduct_InsertAuditKey FOREIGN KEY
--   (
--   InsertAuditKey
--   ) REFERENCES mynorth.DimAudit
--   ( AuditKey )
--     ON UPDATE  NO ACTION
--     ON DELETE  NO ACTION
--;
 
--ALTER TABLE mynorth.DimProduct ADD CONSTRAINT
--   FK_mynorth_DimProduct_UpdateAuditKey FOREIGN KEY
--   (
--   UpdateAuditKey
--   ) REFERENCES mynorth.DimAudit
--   ( AuditKey )
--     ON UPDATE  NO ACTION
--     ON DELETE  NO ACTION
--;
 
ALTER TABLE mynorth.FactSales ADD CONSTRAINT
   FK_mynorth_FactSales_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES mynorth.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE mynorth.FactSales ADD CONSTRAINT
   FK_mynorth_FactSales_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES mynorth.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE mynorth.FactSales ADD CONSTRAINT
   FK_mynorth_FactSales_EmployeeKey FOREIGN KEY
   (
   EmployeeKey
   ) REFERENCES mynorth.DimEmployee
   ( EmployeeKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE mynorth.FactSales ADD CONSTRAINT
   FK_mynorth_FactSales_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES mynorth.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE mynorth.FactSales ADD CONSTRAINT
   FK_mynorth_FactSales_ShippedDateKey FOREIGN KEY
   (
   ShippedDateKey
   ) REFERENCES mynorth.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
--ALTER TABLE mynorth.FactSales ADD CONSTRAINT
--   FK_mynorth_FactSales_InsertAuditKey FOREIGN KEY
--   (
--   InsertAuditKey
--   ) REFERENCES mynorth.DimAudit
--   ( AuditKey )
--     ON UPDATE  NO ACTION
--     ON DELETE  NO ACTION
--;
 
--ALTER TABLE mynorth.FactSales ADD CONSTRAINT
--   FK_mynorth_FactSales_UpdateAuditKey FOREIGN KEY
--   (
--   UpdateAuditKey
--   ) REFERENCES mynorth.DimAudit
--   ( AuditKey )
--     ON UPDATE  NO ACTION
--     ON DELETE  NO ACTION
--;
 
ALTER TABLE mynorth.FactOrderFulfillment ADD CONSTRAINT
   FK_mynorth_FactOrderFulfillment_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES mynorth.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE mynorth.FactOrderFulfillment ADD CONSTRAINT
   FK_mynorth_FactOrderFulfillment_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES mynorth.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE mynorth.FactOrderFulfillment ADD CONSTRAINT
   FK_mynorth_FactOrderFulfillment_ShippedDateKey FOREIGN KEY
   (
   ShippedDateKey
   ) REFERENCES mynorth.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
