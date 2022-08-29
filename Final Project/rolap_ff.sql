/****** Object:  Database ist722_yzhan297_dw    Script Date: 2022/8/16 18:26:29 ******/
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
--CREATE SCHEMA ff
GO


/* Drop table ff.FactPlanProfitability */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ff.FactPlanProfitability') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE ff.FactPlanProfitability 
;
/* Drop table ff.FactSubcriptionByRegion */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ff.FactSubcriptionByRegion') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE ff.FactSubcriptionByRegion 
;
/* Drop table ff.FactPlanCoverage */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ff.FactPlanCoverage') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE ff.FactPlanCoverage 
;



/* Drop table ff.DimffAccount */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ff.DimffAccount') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE ff.DimffAccount 
;

/* Create table ff.DimffAccount */
CREATE TABLE ff.DimffAccount (
   [AccountKey]  int IDENTITY  NOT NULL
,  [AccountID]  int   NOT NULL
,  [AccountEmail]  varchar(200)   NOT NULL
,  [FirstName]  varchar(50)   NOT NULL
,  [LastName]  varchar(50)   NOT NULL
,  [AccountPlanID]  varchar(50)   NOT NULL
,  [ZipCode]  char(5)   NOT NULL
,  [City]  varchar(50)  DEFAULT 'N/A' NOT NULL
,  [State]  varchar(25)  DEFAULT 'N/A' NOT NULL
,  [AccountOpenedDate]  int   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '9999/12/31' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_ff.DimffAccount] PRIMARY KEY CLUSTERED 
( [AccountKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT ff.DimffAccount ON
;
INSERT INTO ff.DimffAccount (AccountKey, AccountID, AccountEmail, FirstName, LastName, AccountPlanID, ZipCode, City, State, AccountOpenedDate, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 'None', '-1', 'None', 'None', 'None', -1, 'Y', '1899/12/31', '9999/12/31', 'N/A')
;
SET IDENTITY_INSERT ff.DimffAccount OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[ff].[Account]'))
DROP VIEW [ff].[Account]
GO
CREATE VIEW [ff].[Account] AS 
SELECT [AccountKey] AS [AccountKey]
, [AccountID] AS [AccountID]
, [AccountEmail] AS [AccountEmail]
, [FirstName] AS [FirstName]
, [LastName] AS [LastName]
, [AccountPlanID] AS [AccountPlanID]
, [ZipCode] AS [ZipCode]
, [City] AS [City]
, [State] AS [State]
, [AccountOpenedDate] AS [AccountOpenedDate]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM ff.DimffAccount
GO

/* Drop table ff.DimffPlan */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ff.DimffPlan') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE ff.DimffPlan 
;

/* Create table ff.DimffPlan */
CREATE TABLE ff.DimffPlan (
   [PlanKey]  int IDENTITY  NOT NULL
,  [PlanID]  int   NOT NULL
,  [PlanName]  varchar(50)   NOT NULL
,  [PlanPrice]  decimal(25,2)   NOT NULL
,  [PlanCurrent]  nchar(1)  DEFAULT 'Y' NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '9999/12/31' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_ff.DimffPlan] PRIMARY KEY CLUSTERED 
( [PlanKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT ff.DimffPlan ON
;
INSERT INTO ff.DimffPlan (PlanKey, PlanID, PlanName, PlanPrice, PlanCurrent, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 0, 'Y', 'Y', '1899/12/31', '9999/12/31', 'N/A')
;
SET IDENTITY_INSERT ff.DimffPlan OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[ff].[Plan]'))
DROP VIEW [ff].[Plan]
GO
CREATE VIEW [ff].[Plan] AS 
SELECT [PlanKey] AS [PlanKey]
, [PlanID] AS [PlanID]
, [PlanName] AS [PlanName]
, [PlanPrice] AS [PlanPrice]
, [PlanCurrent] AS [PlanCurrent]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM ff.DimffPlan
GO


/* Drop table ff.DimffAccountBilling */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ff.DimffAccountBilling') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE ff.DimffAccountBilling 
;

/* Create table ff.DimffAccountBilling */
CREATE TABLE ff.DimffAccountBilling (
   [BillingKey]  int IDENTITY  NOT NULL
,  [BillingID]  int   NOT NULL
,  [AccountID]  int   NOT NULL
,  [BillingDate]  datetime   NOT NULL
,  [PlanID]  int   NOT NULL
,  [BilledAmount]  money   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '9999/12/31' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_ff.DimffAccountBilling] PRIMARY KEY CLUSTERED 
( [BillingKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT ff.DimffAccountBilling ON
;
INSERT INTO ff.DimffAccountBilling (BillingKey, BillingID, AccountID, BillingDate, PlanID, BilledAmount, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, -1, '1899/12/31', -1, 0, 'Y', '1899/12/31', '9999/12/31', 'N/A')
;
SET IDENTITY_INSERT ff.DimffAccountBilling OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[ff].[AccountBilling]'))
DROP VIEW [ff].[AccountBilling]
GO
CREATE VIEW [ff].[AccountBilling] AS 
SELECT [BillingKey] AS [BillingKey]
, [BillingID] AS [BillingID]
, [AccountID] AS [AccountID]
, [BillingDate] AS [BillingDate]
, [PlanID] AS [PlanID]
, [BilledAmount] AS [BilledAmount]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM ff.DimffAccountBilling
GO

/* Drop table ff.DimffZipCode */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ff.DimffZipCode') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE ff.DimffZipCode 
;

/* Create table ff.DimffZipCode */
CREATE TABLE ff.DimffZipCode (
   [ZipCodeKey]  int IDENTITY  NOT NULL
,  [ZipCode]  char(5)   NOT NULL
,  [City]  varchar(50)  DEFAULT 'N/A' NOT NULL
,  [State]  varchar(25)  DEFAULT 'N/A' NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '9999/12/31' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_ff.DimffZipCode] PRIMARY KEY CLUSTERED 
( [ZipCodeKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT ff.DimffZipCode ON
;
INSERT INTO ff.DimffZipCode (ZipCodeKey, ZipCode, City, State, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, 'None', 'None', 'None', 'Y', '1899/12/31', '9999/12/31', 'N/A')
;
SET IDENTITY_INSERT ff.DimffZipCode OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[ff].[ZipCode]'))
DROP VIEW [ff].[ZipCode]
GO
CREATE VIEW [ff].[ZipCode] AS 
SELECT [ZipCodeKey] AS [ZipCodeKey]
, [ZipCode] AS [ZipCode]
, [City] AS [City]
, [State] AS [State]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM ff.DimffZipCode
GO


/* Drop table ff.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ff.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE ff.DimDate 
;

/* Create table ff.DimDate */
CREATE TABLE ff.DimDate (
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
, CONSTRAINT [PK_ff.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

INSERT INTO ff.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[ff].[Date]'))
DROP VIEW [ff].[Date]
GO
CREATE VIEW [ff].[Date] AS 
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
FROM ff.DimDate
GO

/* Create table ff.FactPlanProfitability */
CREATE TABLE ff.FactPlanProfitability (
   [PlanKey]  int   NOT NULL
,  [BillingKey]  int   NOT NULL
,  [BillingDateKey]  int   NOT NULL
,  [BilledAmount]  money   NOT NULL
,  [PlanName]  varchar(50)   NOT NULL
,  [PlanPrice]  money   NOT NULL
, CONSTRAINT [PK_ff.FactPlanProfitability] PRIMARY KEY NONCLUSTERED 
( [BillingKey] )
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[ff].[PlanProfitability]'))
DROP VIEW [ff].[PlanProfitability]
GO
CREATE VIEW [ff].[PlanProfitability] AS 
SELECT [PlanKey] AS [PlanKey]
, [BillingKey] AS [BillingKey]
, [BillingDateKey] AS [BillingDateKey]
, [BilledAmount] AS [BilledAmount]
, [PlanName] AS [PlanName]
, [PlanPrice] AS [PlanPrice]
FROM ff.FactPlanProfitability
GO

/* Create table ff.FactSubcriptionByRegion */
CREATE TABLE ff.FactSubcriptionByRegion (
   [BillingKey]  int   NOT NULL
,  [AccountKey]  int   NOT NULL
,  [PlanKey]  int   NOT NULL
,  [City]  varchar(50)   NOT NULL
,  [State]  char(25)   NOT NULL
,  [ZipCode]  char(5)   NOT NULL
,  [BillingDate]  datetime   NOT NULL
,  [BilledAmount]  money   NOT NULL
,  [PlanName]  varchar(50)   NOT NULL
,  [PlanPrice]  money   NOT NULL
, CONSTRAINT [PK_ff.FactSubcriptionByRegion] PRIMARY KEY NONCLUSTERED 
( [BillingKey] )
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[ff].[SubcriptionByRegion]'))
DROP VIEW [ff].[SubcriptionByRegion]
GO
CREATE VIEW [ff].[SubcriptionByRegion] AS 
SELECT [BillingKey] AS [BillingKey]
, [AccountKey] AS [AccountKey]
, [PlanKey] AS [PlanKey]
, [City] AS [City]
, [State] AS [State]
, [ZipCode] AS [ZipCode]
, [BillingDate] AS [BillingDate]
, [BilledAmount] AS [BilledAmount]
, [PlanName] AS [PlanName]
, [PlanPrice] AS [PlanPrice]
FROM ff.FactSubcriptionByRegion
GO

/* Create table ff.FactPlanCoverage */
CREATE TABLE ff.FactPlanCoverage (
   [BillingKey]  int   NOT NULL
,  [AccountKey]  int   NOT NULL
,  [PlanKey]  int   NOT NULL
,  [BillingDate]  datetime   NOT NULL
,  [BilledAmount]  money   NOT NULL
,  [PlanName]  varchar(50)   NOT NULL
, CONSTRAINT [PK_ff.FactPlanCoverage] PRIMARY KEY NONCLUSTERED 
( [BillingKey] )
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[ff].[PlanCoverage]'))
DROP VIEW [ff].[PlanCoverage]
GO
CREATE VIEW [ff].[PlanCoverage] AS 
SELECT [BillingKey] AS [BillingKey]
, [AccountKey] AS [AccountKey]
, [PlanKey] AS [PlanKey]
, [BillingDate] AS [BillingDate]
, [BilledAmount] AS [BilledAmount]
, [PlanName] AS [PlanName]
FROM ff.FactPlanCoverage
GO

ALTER TABLE ff.DimffAccount ADD CONSTRAINT
   FK_ff_DimffAccount_AccountOpenedDate FOREIGN KEY
   (
   AccountOpenedDate
   ) REFERENCES ff.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE ff.FactPlanProfitability ADD CONSTRAINT
   FK_ff_FactPlanProfitability_PlanKey FOREIGN KEY
   (
   PlanKey
   ) REFERENCES ff.DimffPlan
   ( PlanKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE ff.FactPlanProfitability ADD CONSTRAINT
   FK_ff_FactPlanProfitability_BillingKey FOREIGN KEY
   (
   BillingKey
   ) REFERENCES ff.DimffAccountBilling
   ( BillingKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE ff.FactPlanProfitability ADD CONSTRAINT
   FK_ff_FactPlanProfitability_BillingDateKey FOREIGN KEY
   (
   BillingDateKey
   ) REFERENCES ff.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE ff.FactSubcriptionByRegion ADD CONSTRAINT
   FK_ff_FactSubcriptionByRegion_BillingKey FOREIGN KEY
   (
   BillingKey
   ) REFERENCES ff.DimffAccountBilling
   ( BillingKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE ff.FactSubcriptionByRegion ADD CONSTRAINT
   FK_ff_FactSubcriptionByRegion_AccountKey FOREIGN KEY
   (
   AccountKey
   ) REFERENCES ff.DimffAccount
   ( AccountKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE ff.FactSubcriptionByRegion ADD CONSTRAINT
   FK_ff_FactSubcriptionByRegion_PlanKey FOREIGN KEY
   (
   PlanKey
   ) REFERENCES ff.DimffPlan
   ( PlanKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE ff.FactPlanCoverage ADD CONSTRAINT
   FK_ff_FactPlanCoverage_BillingKey FOREIGN KEY
   (
   BillingKey
   ) REFERENCES ff.DimffAccountBilling
   ( BillingKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE ff.FactPlanCoverage ADD CONSTRAINT
   FK_ff_FactPlanCoverage_AccountKey FOREIGN KEY
   (
   AccountKey
   ) REFERENCES ff.DimffAccount
   ( AccountKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE ff.FactPlanCoverage ADD CONSTRAINT
   FK_ff_FactPlanCoverage_PlanKey FOREIGN KEY
   (
   PlanKey
   ) REFERENCES ff.DimffPlan
   ( PlanKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 