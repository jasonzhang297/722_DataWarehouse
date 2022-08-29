/****** Object:  Database ist722_yzhan297_dw    Script Date: 2022/8/16 21:02:11 ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

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
CREATE SCHEMA fm
GO



/* Drop table fm.FactProductRevenue */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fm.FactProductRevenue') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fm.FactProductRevenue 
;

/* Drop table fm.FactVendorsProfitability */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fm.FactVendorsProfitability') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fm.FactVendorsProfitability 
;

/* Drop table fm.FactRepurchase */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fm.FactRepurchase') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fm.FactRepurchase 
;


/* Drop table fm.DimfmProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fm.DimfmProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fm.DimfmProduct 
;

/* Create table fm.DimfmProduct */
CREATE TABLE fm.DimfmProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [ProductName]  varchar(200)   NOT NULL
,  [ProductRetailPrice]  money   NOT NULL
,  [ProductWholesalePrice]  money   NULL
,  [ProductIsActive]  bit   NOT NULL
,  [ProductVendorID]  int   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '9999/12/31' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_fm.DimfmProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT fm.DimfmProduct ON
;
INSERT INTO fm.DimfmProduct (ProductKey, ProductID, ProductName, ProductRetailPrice, ProductWholesalePrice, ProductIsActive, ProductVendorID, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 0, 0, 0, -1, 'Y', '1899/12/31', '9999/12/31', 'N/A')
;
SET IDENTITY_INSERT fm.DimfmProduct OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fm].[Product]'))
DROP VIEW [fm].[Product]
GO
CREATE VIEW [fm].[Product] AS 
SELECT [ProductKey] AS [ProductKey]
, [ProductID] AS [ProductID]
, [ProductName] AS [ProductName]
, [ProductRetailPrice] AS [ProductRetailPrice]
, [ProductWholesalePrice] AS [ProductWholesalePrice]
, [ProductIsActive] AS [ProductIsActive]
, [ProductVendorID] AS [ProductVendorID]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fm.DimfmProduct
GO


/* Drop table fm.DimfmCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fm.DimfmCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fm.DimfmCustomer 
;

/* Create table fm.DimfmCustomer */
CREATE TABLE fm.DimfmCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int   NOT NULL
,  [CustomerFirstName]  varchar(50)   NOT NULL
,  [CustomerLastName]  varchar(50)   NOT NULL
,  [CustomerEmail]  varchar(100)   NOT NULL
,  [CustomerPhone]  varchar(30)   NOT NULL
,  [CustomerCity]  varchar(15)   NOT NULL
,  [CustomerZipCode]  varchar(20)   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '9999/12/31' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_fm.DimfmCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT fm.DimfmCustomer ON
;
INSERT INTO fm.DimfmCustomer (CustomerKey, CustomerID, CustomerFirstName, CustomerLastName, CustomerEmail, CustomerPhone, CustomerCity, CustomerZipCode, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'Unknown Contact', 'Unknown Contact', 'None', 'None', 'None', 'None', 'Y', '1899/12/31', '9999/12/31', 'N/A')
;
SET IDENTITY_INSERT fm.DimfmCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fm].[Customer]'))
DROP VIEW [fm].[Customer]
GO
CREATE VIEW [fm].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CustomerFirstName] AS [CustomerFirstName]
, [CustomerLastName] AS [CustomerLastName]
, [CustomerEmail] AS [CustomerEmail]
, [CustomerPhone] AS [CustomerPhone]
, [CustomerCity] AS [CustomerCity]
, [CustomerZipCode] AS [CustomerZipCode]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fm.DimfmCustomer
GO


/* Drop table fm.DimfmVendors */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fm.DimfmVendors') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fm.DimfmVendors 
;

/* Create table fm.DimfmVendors */
CREATE TABLE fm.DimfmVendors (
   [VendorKey]  int IDENTITY  NOT NULL
,  [VendorID]  int   NOT NULL
,  [VendorName]  varchar(50)   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '9999/12/31' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_fm.DimfmVendors] PRIMARY KEY CLUSTERED 
( [VendorKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT fm.DimfmVendors ON
;
INSERT INTO fm.DimfmVendors (VendorKey, VendorID, VendorName, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'N/A', 'Y', '1899/12/31', '9999/12/31', 'N/A')
;
SET IDENTITY_INSERT fm.DimfmVendors OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fm].[Vendors]'))
DROP VIEW [fm].[Vendors]
GO
CREATE VIEW [fm].[Vendors] AS 
SELECT [VendorKey] AS [VendorKey]
, [VendorID] AS [VendorID]
, [VendorName] AS [VendorName]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fm.DimfmVendors
GO

/* Drop table fm.DimfmOrders */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fm.DimfmOrders') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fm.DimfmOrders 
;

/* Create table fm.DimfmOrders */
CREATE TABLE fm.DimfmOrders (
   [OrderKey]  int IDENTITY  NOT NULL
,  [OrderID]  int   NOT NULL
,  [CustomerID]  int   NOT NULL
,  [OrderDate]  datetime   NOT NULL
,  [ShippedDate]  datetime   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '9999/12/31' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_fm.DimfmOrders] PRIMARY KEY CLUSTERED 
( [OrderKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT fm.DimfmOrders ON
;
INSERT INTO fm.DimfmOrders (OrderKey, OrderID, CustomerID, OrderDate, ShippedDate, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 0, '1899/12/31', '1899/12/31', 'Y', '1899/12/31', '9999/12/31', 'N/A')
;
SET IDENTITY_INSERT fm.DimfmOrders OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fm].[Orders]'))
DROP VIEW [fm].[Orders]
GO
CREATE VIEW [fm].[Orders] AS 
SELECT [OrderKey] AS [OrderKey]
, [OrderID] AS [OrderID]
, [CustomerID] AS [CustomerID]
, [OrderDate] AS [OrderDate]
, [ShippedDate] AS [ShippedDate]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fm.DimfmOrders
GO

/* Drop table fm.DimfmOrderDetails */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fm.DimfmOrderDetails') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fm.DimfmOrderDetails 
;

/* Create table fm.DimfmOrderDetails */
CREATE TABLE fm.DimfmOrderDetails (
   [OrderDetailsKey]  int IDENTITY  NOT NULL
,  [OrderID]  int   NOT NULL
,  [ProductID]  int   NOT NULL
,  [OrderQuantity]  int   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '9999/12/31' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_fm.DimfmOrderDetails] PRIMARY KEY CLUSTERED 
( [OrderDetailsKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT fm.DimfmOrderDetails ON
;
INSERT INTO fm.DimfmOrderDetails (OrderDetailsKey, OrderID, ProductID, OrderQuantity, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, -1, -1, 'Y', '1899/12/31', '9999/12/31', 'N/A')
;
SET IDENTITY_INSERT fm.DimfmOrderDetails OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fm].[OrderDetails]'))
DROP VIEW [fm].[OrderDetails]
GO
CREATE VIEW [fm].[OrderDetails] AS 
SELECT [OrderDetailsKey] AS [OrderKey]
, [OrderID] AS [OrderID]
, [ProductID] AS [ProductID]
, [OrderQuantity] AS [OrderQuantity]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fm.DimfmOrderDetails
GO

/* Drop table fm.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fm.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fm.DimDate 
;

/* Create table fm.DimDate */
CREATE TABLE fm.DimDate (
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
, CONSTRAINT [PK_fm.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

INSERT INTO fm.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fm].[Date]'))
DROP VIEW [fm].[Date]
GO
CREATE VIEW [fm].[Date] AS 
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
FROM fm.DimDate
GO

/* Create table fm.FactProductRevenue */
CREATE TABLE fm.FactProductRevenue (
   [ProductKey]  int   NOT NULL
,  [OrderKey]  int   NOT NULL
,  [ProductName]  nvarchar(200)   NOT NULL
,  [ProductRetailPrice]  money   NOT NULL
,  [ProductWholesalePrice]  money   NULL
,  [ProductIsActive]  nvarchar(1)   NOT NULL
,  [OrderQuantity]  int   NOT NULL
, CONSTRAINT [PK_fm.FactProductRevenue] PRIMARY KEY NONCLUSTERED 
( [OrderKey] )
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fm].[ProductRevenue]'))
DROP VIEW [fm].[ProductRevenue]
GO
CREATE VIEW [fm].[ProductRevenue] AS 
SELECT [ProductKey] AS [ProductKey]
, [OrderKey] AS [OrderKey]
, [ProductName] AS [ProductName]
, [ProductRetailPrice] AS [ProductRetailPrice]
, [ProductWholesalePrice] AS [ProductWholesalePrice]
, [ProductIsActive] AS [ProductIsActive]
, [OrderQuantity] AS [OrderQuantity]
FROM fm.FactProductRevenue
GO

/* Create table fm.FactVendorsProfitability */
CREATE TABLE fm.FactVendorsProfitability (
   [ProductKey]  int   NOT NULL
,  [OrderKey]  int   NOT NULL
,  [ProductVendorKey]  int   NOT NULL
,  [ProductName]  nvarchar(200)   NOT NULL
,  [ProductRetailPrice]  money   NOT NULL
,  [ProductIsActive]  bit   NOT NULL
,  [OrderQuantity]  int   NOT NULL
, CONSTRAINT [PK_fm.FactVendorsProfitability] PRIMARY KEY NONCLUSTERED 
( [OrderKey] )
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fm].[VendorsProfitability]'))
DROP VIEW [fm].[VendorsProfitability]
GO
CREATE VIEW [fm].[VendorsProfitability] AS 
SELECT [ProductKey] AS [ProductKey]
, [OrderKey] AS [OrderKey]
, [ProductVendorKey] AS [ProductVendorKey]
, [ProductName] AS [ProductName]
, [ProductRetailPrice] AS [ProductRetailPrice]
, [ProductIsActive] AS [ProductIsActive]
, [OrderQuantity] AS [OrderQuantity]
FROM fm.FactVendorsProfitability
GO

/* Create table fm.FactRepurchase */
CREATE TABLE fm.FactRepurchase (
   [CustomerKey]  int   NOT NULL
,  [OrderKey]  int   NOT NULL
,  [ProductKey]  int   NOT NULL
,  [ProductName]  nvarchar(200)   NOT NULL
,  [ProductRetailPrice]  money   NOT NULL
,  [ProductWholesalePrice]  money   NULL
,  [ProductIsActive]  bit   NOT NULL
,  [OrderQuantity]  int   NOT NULL
, CONSTRAINT [PK_fm.FactRepurchase] PRIMARY KEY NONCLUSTERED 
( [OrderKey] )
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fm].[Repurchase]'))
DROP VIEW [fm].[Repurchase]
GO
CREATE VIEW [fm].[Repurchase] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [OrderKey] AS [OrderKey]
, [ProductKey] AS [ProductKey]
, [ProductName] AS [ProductName]
, [ProductRetailPrice] AS [ProductRetailPrice]
, [ProductWholesalePrice] AS [ProductWholesalePrice]
, [ProductIsActive] AS [ProductIsActive]
, [OrderQuantity] AS [OrderQuantity]
FROM fm.FactRepurchase
GO

ALTER TABLE fm.FactProductRevenue ADD CONSTRAINT
   FK_fm_FactProductRevenue_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES fm.DimfmProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fm.FactProductRevenue ADD CONSTRAINT
   FK_fm_FactProductRevenue_OrderKey FOREIGN KEY
   (
   OrderKey
   ) REFERENCES fm.DimfmOrders
   ( OrderKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fm.FactVendorsProfitability ADD CONSTRAINT
   FK_fm_FactVendorsProfitability_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES fm.DimfmProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fm.FactVendorsProfitability ADD CONSTRAINT
   FK_fm_FactVendorsProfitability_OrderKey FOREIGN KEY
   (
   OrderKey
   ) REFERENCES fm.DimfmOrders
   ( OrderKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fm.FactVendorsProfitability ADD CONSTRAINT
   FK_fm_FactVendorsProfitability_ProductVendorKey FOREIGN KEY
   (
   ProductVendorKey
   ) REFERENCES fm.DimfmVendors
   ( VendorKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fm.FactRepurchase ADD CONSTRAINT
   FK_fm_FactRepurchase_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES fm.DimfmCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fm.FactRepurchase ADD CONSTRAINT
   FK_fm_FactRepurchase_OrderKey FOREIGN KEY
   (
   OrderKey
   ) REFERENCES fm.DimfmOrders
   ( OrderKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fm.FactRepurchase ADD CONSTRAINT
   FK_fm_FactRepurchase_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES fm.DimfmProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 