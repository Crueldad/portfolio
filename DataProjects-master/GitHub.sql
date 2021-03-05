---Creating tables, delete, insert, and update commands

CREATE TABLE Ian_Employee_Table(
	BusinessEntityID INT NOT Null, 
	NationalIDNumber nvarchar(15) NOT Null, 
	LoginID nvarchar(265) NOT Null, 
	OrganizationNode hierarchyid, 
	JobTitle nvarchar(50) NOT Null, 
	BirthDate date NOT Null, 
	MaritalStatus nchar(1) NOT Null, 
	Gender nchar(1) NOT Null, 
	HireDate date NOT Null, 
	SalariedFlag bit NOT Null, 
	VacationHours smallint NOT Null, 
	SickLeaveHours smallint NOT Null, 
	CurrentFlag bit NOT Null, 
	rowguid uniqueidentifier NOT Null, 
	ModifiedDate datetime NOT Null, 
	CONSTRAINT PK_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID)
	)

	INSERT INTO Ian_Employee_Table
	SELECT BusinessEntityID, NationalIDNumber, LoginID, OrganizationNode, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag, Vacationhours, SickLeaveHours,
	CurrentFlag, rowguid, ModifiedDate
	From AdventureWorksDB.HumanResources.Employee;

	ALTER TABLE Ian_Employee_Table ADD CONSTRAINT LoginID_Constraint UNIQUE (LoginID);  
	ALTER TABLE Ian_Employee_Table ADD CONSTRAINT Gender_Constraint CHECK (Gender in ('M', 'F')); 


CREATE TABLE Ian_Employee_Pay_History(
	BusinessEntityID INT NOT Null, 
	RateChangeDate datetime NOT Null, 
	Rate money NOT Null, 
	PayFrequency tinyint Not Null,
	ModifiedDate datetime Not Null,
	CONSTRAINT FK_BusinessEntityID FOREIGN KEY (BusinessEntityID)
		REFERENCES Ian_Employee_Table (BusinessEntityID)
	)

	INSERT INTO Ian_Employee_Pay_History
	SELECT BusinessEntityID, RateChangeDate, Rate, PayFrequency, ModifiedDate
	From AdventureWorksDB.HumanResources.EmployeePayHistory;

	select *
	From Ian_Employee_Table

	Insert into Ian_Employee_Table (BusinessEntityID) 
	Values (1);

	Insert into Ian_Employee_Table (BusinessEntityID, NationalIDNumber, LoginID, OrganizationNode, JobTitle, BirthDate, MaritalStatus, 
	Gender, HireDate, SalariedFlag, VacationHours, SickLeaveHours, CurrentFlag, rowguid, ModifiedDate) 
	Values (292, 134219713, 'adventure-works\jaee0', NULL, 'Sales Representative', '1975-09-30',
	'S', 'L', '2012-05-30', 1, 34, 37, 1, '604213F9-DD0F-43B4-BDD2-C96E93D3F4BF', '2014-06-30 00:00:00.000');

	Delete from Ian_Employee_Pay_History
	Where BusinessEntityID = 1

	
	Update Ian_Employee_Table
	Set NationalIDNumber = null
	Where BusinessEntityID = '1'

	Insert into Ian_Employee_Table (BusinessEntityID, NationalIDNumber, LoginID) 
	Values ('292', '134219713', 'adventure-works\ken0');

delete from Ian_Employee_Table
where BusinessEntityID = 1;

CREATE TABLE Ian_Products(
	PROD_ID INT  NOT NULL PRIMARY KEY, 
	PROD_NAME  VARCHAR(50) NOT NULL,
	PROD_CATEGORY  VARCHAR(50) NOT NULL,
	PROD_CAT_DESC VARCHAR(2000) NOT NULL,
	PROD_STATUS VARCHAR(20) NOT NULL,
	PROD_LIST_PRICE DECIMAL(8,2) NOT NULL,
	PROD_MIN_PRICE DECIMAL(8,2) NOT NULL,
)

	CREATE CLUSTERED INDEX IanP_Indexx ON Ian_Products(PROD_ID)
	WITH (DROP_EXISTING = ON, FILLFACTOR  = 90); 
	CREATE INDEX Ian_Non_Clustered ON Ian_Products(PROD_CATEGORY)
	WITH (DROP_EXISTING = ON, FILLFACTOR = 90);   
	INSERT INTO Ian_Products
	SELECT PROD_ID, PROD_NAME, PROD_CATEGORY, PROD_CAT_DESC, PROD_STATUS, PROD_LIST_PRICE, PROD_MIN_PRICE
	From IST302.dbo.PRODUCTS; 
	
	SELECT AVG (DATALENGTH (PROD_NAME + PROD_CATEGORY + PROD_CAT_DESC + PROD_STATUS )) 
	AS Average_VAR_Size 
	FROM Ian_Products

SELECT MAX(DATALENGTH(PROD_NAME + PROD_CATEGORY + PROD_CAT_DESC + PROD_STATUS))
FROM Ian_Products

---Creating and altering triggers

Alter TRIGGER Insert_Trigger 
ON ICrueldad_DB.dbo.Ian_Employee_Table
AFTER INSERT
AS 
if Not Exists(
Select * From Ian_Employee_Table
)
Begin
RAISERROR ('Insert Statement did not  insert anything in row(s)', 16, 10);  
Rollback Transaction;
End
Else 
Begin
   PRINT 'Rows inserted from Ian_Employee_Table1' 
END
GO  

Create TRIGGER Delete_Trigger 
ON ICrueldad_DB.dbo.Ian_Employee_Table
AFTER Delete
AS 
if Exists(
Select * From Ian_Employee_Table
)
Begin
RAISERROR ('Delete Statement did not delete anything in row(s)', 16, 1);  
Rollback Transaction;
End
Else 
Begin
   PRINT 'Rows Deleted from Ian_Employee_Table' 
END
GO  

Alter TRIGGER Update_Trigger 
ON ICrueldad_DB.dbo.Ian_Employee_Table
AFTER Update
AS 
if Not Exists(
Select * From Ian_Employee_Table
)
Begin
RAISERROR ('Update Statement did not update anything in row(s)', 16, 10);  
Rollback Transaction;
End
Else 
Begin
   PRINT 'Rows updated from Ian_Employee_Table' 
END
GO  


---Creating Views
Select *
Into Ian_Sales
From IST302.dbo.SALES

Create View Product_Summary_V With Schemabinding AS 
Select Prod_ID,
		Year(Time_ID) AS Sales_year,
		Month(Time_ID) AS Sales_Month,
		Sum(Isnull(Quantity_Sold, 0)) AS Total_Quantity_Sold,
		Sum(Isnull(Amount_Sold, 0)) AS Total_Amount_Sold,
		Cast(Sum(Isnull(amount_sold, 0))/Sum(Isnull(quantity_sold, 0)) AS decimal (10,2)) as Average_Sales_Price
		From dbo.Ian_Sales 
		Group BY Prod_Id, Year(Time_ID), Month(Time_ID) 

Create View Product_Summary_M With Schemabinding AS 
Select Prod_ID,
		Year(Time_ID) AS Sales_year,
		Month(Time_ID) AS Sales_Month,
		Sum(Isnull(Quantity_Sold, 0)) AS Total_Quantity_Sold,
		Sum(Isnull(Amount_Sold, 0)) AS Total_Amount_Sold,
		Count_Big(*) AS Count 
		From dbo.Ian_Sales 
		Group BY Prod_Id, Year(Time_ID), Month(Time_ID)

Create Unique Clustered Index UIX_Product_Summary_M on Product_Summary_M
(Prod_ID, Sales_Year, Sales_Month)


Create View dbo.Product_Summary_M_W_AVG With Schemabinding AS
Select Prod_ID, Sales_Year, Sales_Month, Total_Quantity_Sold, Total_Amount_Sold,
Cast((Total_Amount_Sold/Total_Quantity_Sold) As decimal (10,2)) as
Average_Sales_Price
From dbo.Product_Summary_M;

Set Statistics Time On;
Select Product_Summary_V.Prod_ID, PROD_DESC, Sales_Year, Sales_Month, Total_Amount_Sold,Total_Quantity_Sold, Average_Sales_Price
From Product_Summary_V join IST302.dbo.PRODUCTS PP ON
Product_Summary_V.Prod_ID = PP.PROD_ID
Where PP.PROD_SUBCATEGORY In ('Documentation', 'Accessories');
Set Statistics Time Off; 

Set Statistics Time On;
Select Product_Summary_M_W_AVG.Prod_ID, PROD_DESC, Sales_Year, Sales_Month, Total_Amount_Sold,Total_Quantity_Sold, Average_Sales_Price
From dbo.Product_Summary_M_W_AVG join IST302.dbo.PRODUCTS PP ON
Product_Summary_M_W_AVG.Prod_ID = PP.PROD_ID
Where PP.PROD_SUBCATEGORY In ('Documentation', 'Accessories');
Set Statistics Time Off; 

Set Statistics Time On;
select PV.Prod_ID, PV.Sales_year, PV.Total_Quantity_Sold, PV.Total_Amount_Sold, PV.Average_Sales_Price
From (select Prod_ID,
		Year(Time_ID) AS Sales_year,
		Month(Time_ID) AS Sales_Month,
		Sum(Isnull(Quantity_Sold, 0)) AS Total_Quantity_Sold,
		Sum(Isnull(Amount_Sold, 0)) AS Total_Amount_Sold,
		Cast(Sum(Isnull(amount_sold, 0))/Sum(Isnull(quantity_sold, 0)) AS decimal (10,2)) as Average_Sales_Price
		From dbo.Ian_Sales 
		Group BY Prod_Id, Year(Time_ID), Month(Time_ID)) As PV
		Join IST302.dbo.Products P
		On PV.Prod_Id = P.Prod_Id
		Where P.Prod_Subcategory In ('Accessories','Documentation');
		Set Statistics Time Off;

---Using left join, right join, inner join, creating case statement, and creating triggers
select AdventureWorksDB.Person.Person.BusinessEntityID, PersonType, FirstName, MiddleName, LastName, EmailPromotion, 
AdventureWorksDB.Sales.PersonCreditCard.CreditCardID
From AdventureWorksDB.Sales.PersonCreditCard 
Right Join AdventureWorksDB.Person.Person on AdventureWorksDB.Sales.PersonCreditCard.BusinessEntityID = AdventureWorksDB.Person.Person.BusinessEntityID
Where CreditCardID is Null and PersonType not in ('EM', 'VC', 'SP'); 

Select DH.DepartmentID, EE.JobTitle, EE.HireDate, PP.LastName, PP.FirstName 
From AdventureWorksDB.HumanResources.Employee EE
left Join AdventureWorksDB.Person.Person PP
ON EE.BusinessEntityID = PP.BusinessEntityID
Left Join (select * from AdventureWorksDB.HumanResources.EmployeeDepartmentHistory where EndDate is null) DH
On EE.BusinessEntityID = DH.BusinessEntityID
Left Join AdventureWorksDB.HumanResources.Department DD
ON DH.DepartmentID = DD.DepartmentID
Left Join AdventureWorksDB.HumanResources.EmployeePayHistory EPH
ON EPH.BusinessEntityID = EE.BusinessEntityID
where EPH.rate > (select AVG(Rate) from AdventureWorksDB.HumanResources.EmployeePayHistory );

With Question_4 (DepartmentID, JobTitle, HireDate, LastName, FirstName, rate) 
AS (
Select DH.DepartmentID, EE.JobTitle, EE.HireDate, PP.LastName, PP.FirstName, EPH.Rate
From AdventureWorksDB.HumanResources.Employee EE
left Join AdventureWorksDB.Person.Person PP
ON EE.BusinessEntityID = PP.BusinessEntityID
Left Join (select * from AdventureWorksDB.HumanResources.EmployeeDepartmentHistory where EndDate is null) DH
On EE.BusinessEntityID = DH.BusinessEntityID
Left Join AdventureWorksDB.HumanResources.Department DD
ON DH.DepartmentID = DD.DepartmentID
Left Join AdventureWorksDB.HumanResources.EmployeePayHistory EPH
ON EPH.BusinessEntityID = EE.BusinessEntityID
where EPH.rate > (select AVG(Rate) from AdventureWorksDB.HumanResources.EmployeePayHistory ))
select Max(Rate) AS Maxrate, DepartmentID, JobTitle, LastName, FirstName, HireDate from Question_4
Group By DepartmentID, JobTitle, LastName, HireDate, FirstName
Order by DepartmentID, JobTitle, HireDate, FirstName, LastName


SELECT PP.LastName, PP.FirstName, EE.JobTitle, EPH.Rate,
CASE
WHEN EPH.RATE <= 25 THEN 'Low'
WHEN EPH.RATE between 25 and 45 THEN 'Medium'
WHEN EPH.RATE >= 45 THEN 'High'
END Rate
FROM AdventureWorksDB.HumanResources.Employee EE
LEFT JOIN AdventureWorksDB.Person.Person PP 
ON EE.BusinessEntityID = PP.BusinessEntityID
LEFT Join AdventureWorksDB.HumanResources.EmployeePayHistory EPH 
ON EE.BusinessEntityID = EPH.BusinessEntityID
Where EE.JobTitle Like '%Manager%'
ORDER BY EPH.Rate, EE.JobTitle, PP.LastName;

Create Trigger After_Insert ON ICrueldad_DB.dbo.Ian_Employee_Table
For Insert
AS Declare
    @BusinessEntityID INT,
	@NationalIDNumber nvarchar(15), 
	@LoginID nvarchar(265), 
	@OrganizationNode hierarchyid, 
	@JobTitle nvarchar(50), 
	@BirthDate date, 
	@MaritalStatus nchar(1), 
	@Gender nchar(1), 
	@HireDate date, 
	@SalariedFlag bit, 
	@VacationHours smallint, 
	@SickLeaveHours smallint, 
	@CurrentFlag bit, 
	@rowguid uniqueidentifier, 
	@ModifiedDate datetime;

Select @BusinessEntityID = ins.BusinessEntityID From Inserted ins;
Select @NationalIDNumber = ins.NationalIDNumber From Inserted ins;
Select @LoginID = ins.LoginID From Inserted ins;
Select @OrganizationNode = ins.OrganizationNode From Inserted ins;
Select @JobTitle = ins.JobTitle From Inserted ins;
Select @BirthDate = ins.BirthDate From Inserted ins;
Select @MaritalStatus = ins.MaritalStatus From Inserted ins;
Select @Gender = ins.Gender From Inserted ins;
Select @HireDate = ins.HireDate From Inserted ins;
Select @SalariedFlag = ins.SalariedFlag From Inserted ins;
Select @VacationHours = ins.VacationHours From Inserted ins;
Select @SickLeaveHours = ins.SickLeaveHours From Inserted ins;
Select @CurrentFlag = ins.CurrentFlag From Inserted ins;
Select @rowguid = ins.rowguid From Inserted ins;
Select @ModifiedDate = ins.ModifiedDate From Inserted ins;

BEGIN  
RAISERROR ('Insert Statement did not insert anything in rows.', 16, 1);  
ROLLBACK TRANSACTION;  
RETURN   
END; 

PRINT 'Rows inserted from Ian_Employee_Table' 
Go

DROP TRIGGER  IF EXISTS  After_Insert 


Alter Trigger After_Delete ON ICrueldad_DB.dbo.Ian_Employee_Table
For Delete
AS Declare
    @BusinessEntityID INT,
	@NationalIDNumber nvarchar(15), 
	@LoginID nvarchar(265), 
	@OrganizationNode hierarchyid, 
	@JobTitle nvarchar(50), 
	@BirthDate date, 
	@MaritalStatus nchar(1), 
	@Gender nchar(1), 
	@HireDate date, 
	@SalariedFlag bit, 
	@VacationHours smallint, 
	@SickLeaveHours smallint, 
	@CurrentFlag bit, 
	@rowguid uniqueidentifier, 
	@ModifiedDate datetime;

Select @BusinessEntityID = del.BusinessEntityID From deleted del;
Select @NationalIDNumber = del.NationalIDNumber From deleted del;
Select @LoginID = del.LoginID From deleted del;
Select @OrganizationNode = del.OrganizationNode From deleted del;
Select @JobTitle = del.JobTitle From deleted del;
Select @BirthDate = del.BirthDate From deleted del;
Select @MaritalStatus = del.MaritalStatus From deleted del;
Select @Gender = del.Gender From deleted del;
Select @HireDate = del.HireDate From deleted del;
Select @SalariedFlag = del.SalariedFlag From deleted del;
Select @VacationHours = del.VacationHours From deleted del;
Select @SickLeaveHours = del.SickLeaveHours From deleted del;
Select @CurrentFlag = del.CurrentFlag From deleted del;
Select @rowguid = del.rowguid From deleted del;
Select @ModifiedDate = del.ModifiedDate From deleted del;

PRINT 'Rows Deleted from Ian_Employee_Table' 
Go

Alter Trigger After_Delete ON ICrueldad_DB.dbo.Ian_Employee_Table
For Delete
AS Declare
    @BusinessEntityID INT,
	@NationalIDNumber nvarchar(15), 
	@LoginID nvarchar(265), 
	@OrganizationNode hierarchyid, 
	@JobTitle nvarchar(50), 
	@BirthDate date, 
	@MaritalStatus nchar(1), 
	@Gender nchar(1), 
	@HireDate date, 
	@SalariedFlag bit, 
	@VacationHours smallint, 
	@SickLeaveHours smallint, 
	@CurrentFlag bit, 
	@rowguid uniqueidentifier, 
	@ModifiedDate datetime;

Select @BusinessEntityID = del.BusinessEntityID From deleted del;
Select @NationalIDNumber = del.NationalIDNumber From deleted del;
Select @LoginID = del.LoginID From deleted del;
Select @OrganizationNode = del.OrganizationNode From deleted del;
Select @JobTitle = del.JobTitle From deleted del;
Select @BirthDate = del.BirthDate From deleted del;
Select @MaritalStatus = del.MaritalStatus From deleted del;
Select @Gender = del.Gender From deleted del;
Select @HireDate = del.HireDate From deleted del;
Select @SalariedFlag = del.SalariedFlag From deleted del;
Select @VacationHours = del.VacationHours From deleted del;
Select @SickLeaveHours = del.SickLeaveHours From deleted del;
Select @CurrentFlag = del.CurrentFlag From deleted del;
Select @rowguid = del.rowguid From deleted del;
Select @ModifiedDate = del.ModifiedDate From deleted del; 

PRINT 'Rows deleted from Ian_Employee_Table' 
Go



Alter TRIGGER AfterUpdate ON ICrueldad_DB.dbo.Ian_Employee_Table 
FOR UPDATE
AS
Declare	@BusinessEntityID INT;
Declare	@NationalIDNumber nvarchar(15);
Declare	@LoginID nvarchar(265);
Declare	@OrganizationNode hierarchyid;
Declare	@JobTitle nvarchar(50); 
Declare	@BirthDate date; 
Declare	@MaritalStatus nchar(1);
Declare	@Gender nchar(1); 
Declare	@HireDate date; 
Declare	@SalariedFlag bit; 
Declare	@VacationHours smallint;
Declare	@SickLeaveHours smallint; 
Declare	@CurrentFlag bit;
Declare	@rowguid uniqueidentifier;
Declare	@ModifiedDate datetime;
declare @audit_action varchar(100);

Select @BusinessEntityID = i.BusinessEntityID From Inserted i;
Select @NationalIDNumber = i.NationalIDNumber From Inserted i;
Select @LoginID = i.LoginID From Inserted i;
Select @OrganizationNode = i.OrganizationNode From Inserted i;
Select @JobTitle = i.JobTitle From Inserted i;
Select @BirthDate = i.BirthDate From Inserted i;
Select @MaritalStatus = i.MaritalStatus From Inserted i;
Select @Gender = i.Gender From Inserted i;
Select @HireDate = i.HireDate From Inserted i;
Select @SalariedFlag = i.SalariedFlag From Inserted i;
Select @VacationHours = i.VacationHours From Inserted i;
Select @SickLeaveHours = i.SickLeaveHours From Inserted i;
Select @CurrentFlag = i.CurrentFlag From Inserted i;
Select @rowguid = i.rowguid From Inserted i;
Select @ModifiedDate = i.ModifiedDate From Inserted i;	
	
	if update(NationalIDNumber)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(LoginID)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(OrganizationNode)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(JobTitle)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(BirthDate)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(MaritalStatus)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(Gender)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(HireDate)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(SalariedFlag)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(VacationHours)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(SickLeaveHours)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(CurrentFlag)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(rowguid)
		set @audit_action='Updated Row from Ian_Employee_Table.';
	if update(ModifiedDate)
		set @audit_action='Updated Row from Ian_Employee_Table.'; 

PRINT 'Updated Row from Ian_Employee_Table.'
GO

---Creating and dropping indexes and showing text plans
elect * 
Into Icrueldad_DB.dbo.Ian_Promotions From IST302.dbo.PROMOTIONS

Select * 
Into Icrueldad_DB.dbo.Ian_Customers From IST302.dbo.CUSTOMERS

Select * 
Into Icrueldad_DB.dbo.Ian_Channels From IST302.dbo.CHANNELS

Select * 
Into Icrueldad_DB.dbo.Ian_Times From IST302.dbo.TIMES

Select * 
Into Icrueldad_DB.dbo.Ian_Products_CE4 From IST302.dbo.PRODUCTS

Set Showplan_Text on
SELECT
	CUST_LAST_NAME + ', ' + CUST_FIRST_NAME AS CUST_NAME,
	FISCAL_MONTH_NAME, S.TIME_ID AS SALES_DATE, CHANNEL_DESC,
	PROMO_NAME, PROD_SUBCATEGORY, PROD_NAME, AMOUNT_SOLD
FROM Ian_Sales S 
INNER JOIN Ian_Customers C
	ON S.CUST_ID = C.CUST_ID
INNER JOIN Ian_Products_CE4 P
	ON S.PROD_ID = P.PROD_ID
INNER JOIN Ian_Promotions R
	ON S.PROMO_ID = R.PROMO_ID
INNER JOIN Ian_Channels H
	ON S.CHANNEL_ID = H.CHANNEL_ID
INNER JOIN Ian_TIMES T
	ON S.TIME_ID = T.TIME_ID
WHERE CUST_GENDER = 'M' AND CUST_MARITAL_STATUS = 'Married'
	AND FISCAL_MONTH_NAME IN ('February', 'March', 'April', 'May', 'June')
	AND PROD_SUBCATEGORY IN ('Monitors', 'Recordable CDs')
	AND CHANNEL_DESC = 'Tele Sales'
	AND S.TIME_ID BETWEEN '02-25-1998' AND '01-30-2000';
	Set Showplan_Text off

	Create Index IDX_Sales_Cust_ID on Ian_Sales (Cust_ID) 
	Create Index IDX_Sales_Prod_ID on Ian_Sales (Prod_ID) 
	Create Index IDX_Sales_Promo_ID on Ian_Sales (Promo_ID) 
	Create Index IDX_Sales_Channel_ID on Ian_Sales (Channel_ID) 
	Create Index IDX_Sales_Time_ID on Ian_Sales (Time_ID) 
	Create Index IDX_Cust_ID on Ian_Customers (Cust_ID) 

	Create NONCLUSTERED Index NIDX_Customers_Cust_Gender on Ian_Customers (Cust_Gender) 
	Create NONCLUSTERED Index NIDX_Customers_Cust_Martial_Status on Ian_Customers (CUST_MARITAL_STATUS) 
	Create NONCLUSTERED Index NIDX_Times_FISCAL_MONTH_NAME on Ian_Times (FISCAL_MONTH_NAME) 
	Create NONCLUSTERED Index NIDX_Products_CE4_PROD_SUBCATEGORY on Ian_Products_CE4 (PROD_SUBCATEGORY) 
	Create NONCLUSTERED Index NIDX_Channels_CHANNEL_DESC on Ian_Channels (CHANNEL_DESC) 
	Create NONCLUSTERED Index NIDX_Time_ID on Ian_Times (TIME_ID) 


CREATE INDEX Composite_Gender_Martial_Status
on Ian_Customers (Cust_Gender, Cust_Marital_Status);


Drop Index Composite_Gender_Martial_Status
On Ian_Customers;

Drop Index NIDX_Channels_CHANNEL_DESC
On Ian_Channels; 

Set Showplan_text on 
SELECT
	CUST_LAST_NAME + ', ' + CUST_FIRST_NAME AS CUST_NAME
FROM
	Ian_Sales S
INNER JOIN Ian_Customers C
	ON S.CUST_ID = C.CUST_ID
INNER JOIN Ian_Products_CE4 P
	ON S.PROD_ID = P.PROD_ID
INNER JOIN Ian_Promotions R
	ON S.PROMO_ID = R.PROMO_ID
INNER JOIN Ian_Channels H
	ON S.CHANNEL_ID = H.CHANNEL_ID
INNER JOIN Ian_Times T
	ON S.TIME_ID = T.TIME_ID
WHERE CUST_GENDER = 'M' AND CUST_MARITAL_STATUS = 'Married'
	AND PROD_SUBCATEGORY IN ('Monitors', 'Recordable CDs')
EXCEPT
SELECT
	CUST_LAST_NAME + ', ' + CUST_FIRST_NAME AS CUST_NAME
FROM
	Ian_Sales S
INNER JOIN Ian_Customers C
	ON S.CUST_ID = C.CUST_ID
INNER JOIN Ian_Products_CE4 P
	ON S.PROD_ID = P.PROD_ID
INNER JOIN Ian_PROMOTIONS R
	ON S.PROMO_ID = R.PROMO_ID
INNER JOIN Ian_Channels H
	ON S.CHANNEL_ID = H.CHANNEL_ID
INNER JOIN Ian_Times T
	ON S.TIME_ID = T.TIME_ID
WHERE FISCAL_MONTH_NAME IN ('February', 'March', 'April', 'May', 'June')
	AND CHANNEL_DESC = 'Direct Sales'
	AND S.TIME_ID BETWEEN '02-25-1998' AND '01-30-2000';
	Set Showplan_text off

	
Set Showplan_text on 
SELECT
	CUST_GENDER AS GENDER, PROD_SUBCATEGORY,
	FISCAL_MONTH_NAME, MONTH(S.TIME_ID) AS SALES_MONTH,
	CHANNEL_CLASS,SUM(AMOUNT_SOLD) AS TOTAL_AMOUNT_SOLD
FROM
	Ian_Sales S
INNER JOIN Ian_Customers C
	ON S.CUST_ID = C.CUST_ID
INNER JOIN Ian_Products_CE4 P
	ON S.PROD_ID = P.PROD_ID
INNER JOIN Ian_Promotions R
	ON S.PROMO_ID = R.PROMO_ID
INNER JOIN Ian_Channels H
ON S.CHANNEL_ID = H.CHANNEL_ID
INNER JOIN Ian_Times T
	ON S.TIME_ID = T.TIME_ID
WHERE CUST_GENDER = 'M' AND CUST_MARITAL_STATUS = 'Married'
	AND FISCAL_MONTH_NAME IN ('February', 'March', 'April', 'May', 'June')
	AND PROD_SUBCATEGORY IN ('Monitors', 'Recordable CDs')
	AND S.TIME_ID BETWEEN '02-25-1998' AND '01-30-2000'
GROUP BY
	CUST_GENDER, PROD_SUBCATEGORY, FISCAL_MONTH_NAME,
	MONTH(S.TIME_ID), CHANNEL_CLASS;
	Set Showplan_text off

	---Creating and dropping procedures
	Alter procedure spPrintEmployeeRate (
@DepartmentName Varchar(50),
@MinRate Money
)
As 
Begin 
Select PP.Title, PP.Firstname +PP.MiddleName+ PP.Lastname, EPH.Rate, D.Name, EDH.EndDate ---Dont need enddate and d.name
From AdventureWorksDB.Person.Person as PP
Join AdventureWorksDB.HumanResources.EmployeeDepartmentHistory as EDH
on PP.BusinessEntityID = EDH.BusinessEntityID
Join AdventureWorksDB.HumanResources.EmployeePayHistory as EPH
on PP.BusinessEntityID = EPH.BusinessEntityID
Join AdventureWorksDB.HumanResources.Department as D
on EDH.DepartmentID = D.DepartmentID
Where D.name = @DepartmentName 
and EDH.EndDate is Null 
and EPH.RateChangeDate = (select Max(EPH.RateChangeDate)
	from AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH where PP.BusinessEntityID = EPH.BusinessEntityID)
	and EPH.Rate > @MinRate 
Order by EPH.Rate DESC
END;

Exec spPrintEmployeeRate 'Quality Assurance', 10.00

Drop Procedure spGetWeeklyGroupTotalSalary;

Create Procedure spGetWeeklyGroupTotalSalary (
@GroupDepartmentName Varchar(50),
@DepartmentWeeklyTotalSalary as Money OUTPUT
)
As 
Begin 
Select @DepartmentWeeklyTotalSalary =Sum(EPH.Rate*40)
From AdventureWorksDB.HumanResources.EmployeePayHistory as E
Join AdventureWorksDB.HumanResources.EmployeePayHistory as EPH
on E.BusinessEntityID = EPH.BusinessEntityID
Join AdventureWorksDB.HumanResources.EmployeeDepartmentHistory as EDH
on EPH.BusinessEntityID = EDH.BusinessEntityID
Join AdventureWorksDB.HumanResources.Department as D
on EDH.DepartmentID = D.DepartmentID
Where D.GroupName = @GroupDepartmentName 
and EDH.EndDate is Null 
END
Go

Declare @DepartmentWeeklyTotalSalary as Money 

Exec spGetWeeklyGroupTotalSalary 'Quality Assurance', @DepartmentWeeklyTotalSalary OUTPUT;
Print 'DepartmentWeeklyTotalSalary' + cast (@DepartmentWeeklyTotalSalary as varchar (50))

Create Procedure spGetCurrentSalaryRate (
@Employee_ID as INT,
@SalaryHourlyRate Money Output,
@Department_Name NVarchar(50) Output 
)
As 
Begin 
Select @SalaryHourlyRate = EPH.Rate, @Department_Name = D.Name
From AdventureworksDB.HumanResources.EmployeePayHistory AS EPH
Join AdventureworksDB.HumanResources.EmployeeDepartmentHistory AS EDH
On EPH.BusinessEntityID = EDH.BusinessEntityID
Join AdventureworksDB.HumanResources.Employee AS E
on E.BusinessEntityID = EDH.BusinessEntityID 
Join AdventureworksDB.HumanResources.Department AS D
on D.DepartmentID = EDH.DepartmentID
Where EDH.BusinessEntityID = @Employee_ID
and EDH.EndDate is Null 
and EPH.RateChangeDate = (select Max(EPH.RateChangeDate)
	from AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH where E.BusinessEntityID = EPH.BusinessEntityID)
END
Go

Declare @SalaryHourlyRate Money
Declare @Department_Name NVarchar(50) 
Exec spGetCurrentSalaryRate 20, @SalaryHourlyRate Output, @Department_Name Output

Select PP. FirstName + ' ' + PP.LastName as Name, EPH.Rate, D.Name as Department
From AdventureWorksDB.Person.Person as PP 
Join AdventureWorksDB.HumanResources.EmployeePayHistory as EPH
on PP.BusinessEntityID = EPH.BusinessEntityID
Join AdventureWorksDB.HumanResources.EmployeeDepartmentHistory AS EDH
ON EPH.BusinessEntityID = EDH.BusinessEntityID
Join AdventureWorksDB.HumanResources.Department AS D
on D.DepartmentID = EDH.DepartmentID
And EPH.Rate > @SalaryHourlyRate
AND D.Name = @Department_Name
And EPH.RateChangeDate = (Select Max(EPH.RateChangeDate)
From AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH where PP.BusinessEntityID = EPH.BusinessEntityID)


Create Procedure EmployeePayRange 
AS
Begin
Declare @Counter Int
Declare @MaxRate Money
Declare @MaxVal Decimal
Declare @MinVal Decimal
Declare @NumberEmployees Int

Set @MaxRate = (Select Max(rate)
	From
	AdventureWorksDB.HumanResources.EmployeePayHistory)
Set @Counter = 0

While @Counter*10 <= @MaxRate
Begin
Set @MaxVal = @Counter*10 +10
Set @MinVal = @Counter*10
Set @NumberEmployees = (Select Count(*)
	From (Select BusinessEntityID, Max(rate) as Rate
			From AdventureWorksDB.HumanResources.EmployeePayHistory
			Group By BusinessEntityID) as BEPH
			Where BEPH.Rate Between @MinVal and @MaxVal)
	Print Cast(@NumberEmployees as Varchar(3)) + 'employee has pay rate between $'
	+ Cast(@MinVal as Varchar(3)) + ' and $ ' 
	+ Cast(@MaxVal as Varchar(3)) 
	Set @Counter = @Counter + 1
	End
End 

Exec EmployeePayRange;
Go

Drop Procedure EmployeePayRange;

Create Procedure SpWeeklyPayReport 
(
@ReportType Varchar(Max)
)
AS
Begin
Declare @Department Varchar(Max)
Declare @GroupName Varchar(Max)

Set @Department = (Select Distinct Name From AdventureWorksDB.HumanResources.Department
where Name = @ReportType)
Set @GroupName = (Select Distinct GroupName From AdventureWorksDB.HumanResources.Department
Where GroupName = @ReportType)

If @Department Is not null GOTO B1
Else If @GroupName is not null goto B2
Else Goto  B3
End

B1: Select D.Name, Sum(EPHA.Rate*8*5) as 'WeeklyPay'
From (Select BusinessEntityID, Max(Rate) as Rate
From AdventureWorksDB.HumanResources.EmployeePayHistory Group By BusinessEntityID) as EPHA
Inner Join AdventureWorksDB.HumanResources.EmployeeDepartmentHistory as EDH
On EPHA.BusinessEntityID = EDH.BusinessEntityID
Inner Join AdventureWorksDB.HumanResources.Department as D
On EDH.DepartmentID = D.DepartmentID
Where D.Name = @ReportType
and EDH.EndDate is null
Group By D.DepartmentID, D.Name
Return

B2: Select D.GroupName, Sum(EPHA.Rate*8*5) as 'WeeklyPay'
From (Select BusinessEntityID, Max(Rate) as Rate
From AdventureWorksDB.HumanResources.EmployeePayHistory Group By BusinessEntityID) as EPHA
Inner Join AdventureWorksDB.HumanResources.EmployeeDepartmentHistory as EDH
On EPHA.BusinessEntityID = EDH.BusinessEntityID
Inner Join AdventureWorksDB.HumanResources.Department as D
On EDH.DepartmentID = D.DepartmentID
Where D.Name = @ReportType
and EDH.EndDate is null
Group By D.GroupName
Return

B3: Select 'You must choose Department name or Group name' as Error_Message 
return 


Exec SpWeeklyPayReport 'Research and Development'
Exec SpWeeklyPayReport 'Engineering' 
Exec SpWeeklyPayReport 'Research and Developmentt'


Select * Into My_Department from AdventureWorksDB.HumanResources.Department;
Select * Into My_EmployeePayHistory6_1 from AdventureWorksDB.HumanResources.EmployeePayHistory;
Select * Into My_EmployeePayHistory6_2 from AdventureWorksDB.HumanResources.EmployeePayHistory;

--Creating Cursor and using if and else statements
Declare @EmployeeID Int
Declare RateCursor Cursor for (select distinct BusinessEntityId from My_EmployeePayHistory6_1)
Open RateCursor
Fetch Next From RateCursor into @EmployeeID
Declare @GrouppName Varchar(Max)
While (@@FETCH_STATUS = 0)
Begin
set @GrouppName = (
Select DD.GroupName
From (
Select MPH.BusinessEntityID, MPH.Rate, MPH.RateChangeDate 
From My_EmployeePayHistory6_1 MPH
Right Join
(
Select BusinessEntityID, Max(RateChangeDate) as RateChangeDate
from My_EmployeePayHistory6_1 
Group By BusinessEntityID
)
as RCD
on MPH.BusinessEntityID = RCD.BusinessEntityID
and MPH.RateChangeDate = RCD.RateChangeDate) as RCH
Inner Join AdventureWorksDB.HumanResources.EmployeeDepartmentHistory as DH
ON RCH.BusinessEntityID = DH.BusinessEntityID
Inner Join My_Department as DD 
on DH.DepartmentID = DD.DepartmentID
Where EndDate is null
and RCH.BusinessEntityID = @EmployeeID
)

if (@GrouppName = 'Inventory Management' or @GrouppName = 'Quality Assurance')
Begin 
Update My_EmployeePayHistory6_1
set Rate = (Rate*1.1)
Where BusinessEntityID = @EmployeeID
And RateChangeDate = (Select I.RateChangeDate
from(select BusinessEntityID, Max(RateChangeDate) as RateChangeDate
From My_EmployeePayHistory6_1
Group By BusinessEntityID) as I 
Where I.BusinessEntityID = @EmployeeID)
End

Else If (@GrouppName = 'Manufacturing')
Begin 
Update My_EmployeePayHistory6_1
set Rate = (Rate*1.15)
Where BusinessEntityID = @EmployeeID
And RateChangeDate = (Select I.RateChangeDate
from(select BusinessEntityID, Max(RateChangeDate) as RateChangeDate
From My_EmployeePayHistory6_1
Group By BusinessEntityID) as I 
Where I.BusinessEntityID = @EmployeeID)
End

Else if (@GrouppName = 'Sales and Marketing' or @GrouppName = 'Research and Development' )
Begin 
Update My_EmployeePayHistory6_1
set Rate = (Rate*1.2)
Where BusinessEntityID = @EmployeeID
And RateChangeDate = (Select I.RateChangeDate
from(select BusinessEntityID, Max(RateChangeDate) as RateChangeDate
From My_EmployeePayHistory6_1
Group By BusinessEntityID) as I 
Where I.BusinessEntityID = @EmployeeID) 
End
Fetch Next From RateCursor Into @EmployeeID
End 

Create View MY AS
Select EPH.BusinessEntityID, D.GroupName, EPH.Rate
From My_EmployeePayHistory6_1 as EPH
Join AdventureWorksDB.HumanResources.EmployeeDepartmentHistory EDH
On EPH.BusinessEntityID = EDH.BusinessEntityID
Join AdventureWorksDB.HumanResources.Employee E
On E.BusinessEntityID = EDH.BusinessEntityID
Join My_Department D
ON EDH.DepartmentID = D.DepartmentID
Where EDH.EndDate is null
and EPH.RateChangeDate = (Select Max(EPH.RateChangeDate)
From My_EmployeePayHistory6_1 as EPH Where EPH.BusinessEntityID = E.BusinessEntityID)


Create View Adventure AS
Select EPH.BusinessEntityID, D.GroupName, EPH.Rate
From AdventureWorksDB.HumanResources.EmployeePayHistory as EPH
Join AdventureWorksDB.HumanResources.EmployeeDepartmentHistory EDH
On EPH.BusinessEntityID = EDH.BusinessEntityID
Join AdventureWorksDB.HumanResources.Employee E
On E.BusinessEntityID = EDH.BusinessEntityID
Join AdventureWorksDB.HumanResources.Department D
ON EDH.DepartmentID = D.DepartmentID
Where EDH.EndDate is null
and EPH.RateChangeDate = (Select Max(EPH.RateChangeDate)
From AdventureWorksDB.HumanResources.EmployeePayHistory EPH Where EPH.BusinessEntityID = E.BusinessEntityID)

Select My.GroupName, AVG(My.Rate) as MyRate, AVG(Adventure.Rate) as AdventureRate, AVG(My.Rate)/AVG(Adventure.Rate) as ResultComparison
From My Join Adventure
On My.BusinessEntityID = Adventure.BusinessEntityID
Group By My.GroupName
