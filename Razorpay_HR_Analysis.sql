-- Creating a main database for Razorpay HR analytics
CREATE DATABASE IF NOT EXISTS Razorpay;
USE Razorpay;

-- Create employees data table

CREATE TABLE employees (
    EmployeeNumber INT PRIMARY KEY,
    EmployeeCount INT,
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    Department VARCHAR(100),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(100),
    EmployeeSource VARCHAR(100),  
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(100),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    NumCompaniesWorked INT,
    OverTime VARCHAR(10),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);
 
 -- Load data into the employee  table

LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\razorpay.csv'
INTO TABLE employees
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(Age, Attrition, BusinessTravel, Department, DistanceFromHome, Education, EducationField, EmployeeCount, EmployeeNumber, EnvironmentSatisfaction, Gender, JobInvolvement, JobLevel, JobRole, JobSatisfaction, MaritalStatus, MonthlyIncome, NumCompaniesWorked, OverTime, PercentSalaryHike, PerformanceRating, RelationshipSatisfaction, StandardHours, StockOptionLevel, TotalWorkingYears, TrainingTimesLastYear, WorkLifeBalance, YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager);

-- Rename departments
SET SQL_SAFE_UPDATES = 0;

UPDATE employees
SET Department = CASE
    WHEN Department = 'Research & Development' THEN 'Engineering'
    WHEN Department = 'Sales' THEN 'Business Development'
    WHEN Department = 'Human Resources' THEN 'Customer Support'
    ELSE Department
END;

-- Rename job roles
UPDATE employees
SET JobRole = CASE
    WHEN JobRole = 'Sales Executive' THEN 'Sales Manager'
    WHEN JobRole = 'Research Scientist' THEN 'Product Designer'
    WHEN JobRole = 'Laboratory Technician' THEN 'Backend Engineer'
    WHEN JobRole = 'Healthcare Representative' THEN 'Razorpay Partner Manager'
    WHEN JobRole = 'Human Resources' THEN 'Employee Success Manager'
    WHEN JobRole = 'Manager' THEN 'Strategy Lead'
    ELSE JobRole
END;
---------FEATURE ENGINEERING-----------
-- What income group does each employee belong to?
CREATE OR REPLACE VIEW  employees_enriched AS
SELECT *,
  CASE 
    WHEN MonthlyIncome < 3000 THEN 'LOW'
    WHEN MonthlyIncome BETWEEN 3000 AND 8000 THEN 'MEDIUM'
    ELSE 'HIGH'
  END AS Income_Bracket,

-- How can we classify employees by their total work experience
 
  CASE 
      WHEN TotalWorkingYears < 5 THEN 'Junior'
      WHEN TotalWorkingYears BETWEEN 5 AND 10 THEN 'Mid-Level'
      ELSE 'Senior'
  END AS Tenure_Level,
  
-- Are some employees overworked? (frequent overwork and high training period)
 
 CASE 
  WHEN OVERTIME = 'YES' AND TrainingTimesLastYear > 3 THEN 'YES'
  ELSE 'NO'
 END AS Overworked_Flag,
 

-- Have employees recieved a promotion lately?/

 CASE 
  WHEN YearsSinceLastPromotion > 3 THEN 'Stagnant'
  ELSE 'RecentlyPromoted'
 END as Promotion_Status,
       
-- What age group does each employee fall into?
 CASE
  WHEN Age < 30 THEN 'Young'
  WHEN Age BETWEEN 30 AND 45 THEN 'Mid-Age'
  ELSE 'Experienced'
 END AS Age_Group
FROM employees;
       
------ EDA (Exploratory Data Analysis) ---------

-- COMPANY WIDE METRICS

-- 1. How many employees are currently working in this company?
SELECT COUNT(*) AS Total_Employees
FROM employees
WHERE Attrition = 'No';

-- 2.What is the overall attrition rate?
SELECT
ROUND(SUM(CASE 
        WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/
        COUNT(*)*100,2) as Attrition_rate_percentage
FROM employees;        
        
-- 4.  What is the average tenure of employees who left vs. stayed?
SELECT Attrition,ROUND(AVG(TotalWorkingYears),2) as Avg_tenure
FROM employees
GROUP BY Attrition;


-- DEPARTMENT AND ROLE INSIGHTS

-- 1.Which departments are losing the most employees?
SELECT Department,
      count(*) as total_employees,
      sum(case when Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_attritions,
      round(sum(case when Attrition = 'Yes' then 1 else 0 end)/count(*),2) as attrition_rate
 FROM employees
 group by Department
 ORDER BY attrition_rate desc;
 
-- 2.Which job roles have the highest attrition?
SELECT JobRole,
       count(*) as total_employees,
       sum(case when Attrition= 'Yes' THEN 1 else 0 end ) as total_attritions,
       round(sum(case when Attrition = 'Yes' then 1 else 0 end ) /count(*),2) as attrition_rate
FROM employees
group by JobRole
order by attrition_rate desc;       

-- 3.What’s the average monthly income by department?
SELECT Department,
       sum(MonthlyIncome) as total_income,
       avg(MonthlyIncome) as avg_monthly_income
FROM employees
GROUP BY Department
order by avg_monthly_income;
      

-- DEMOGRAPHIC INSIGHTS


-- 1. Are men or women leaving more frequently?
SELECT Gender,
        round(sum(case when Attrition= 'Yes' then 1 else 0 end)/count(*),2) as attrition_rate
FROM employees
group by Gender
order by attrition_rate desc;       

-- 2.Does marital status impact attrition?
SELECT MaritalStatus,
        round(sum(case when Attrition= 'Yes' then 1 else 0 end)/count(*),2) as attrition_rate
FROM employees
group by MaritalStatus
order by attrition_rate desc;   


-- 3.Are experienced (older) employees more stable?
select Age_Group, 
round(sum(case when Attrition = "Yes" THEN 1 else 0 end )/count(*),2) as attrition_rate
from employees_enriched
group by Age_Group
order by attrition_rate desc;
 

-- Work Culture & Lifestyle
-- 1. Does overtime correlate with higher attrition?
SELECT OverTime, 
 round(sum(case when Attrition = "Yes" then 1 else 0 end)/count(*),2) as attrition_rate
from employees
group by OverTime
order by   attrition_rate desc;


-- 2. How does work-life balance affect attrition?
select WorkLifeBalance, 
 round(sum(case when Attrition ='Yes' then 1 else 0 end)/ count(*),2) as attrition_rate 
from employees
group by WorkLifeBalance
order by attrition_rate desc; 

-- 3. Are overworked employees more likely to leave?
select overworked_flag,
round(sum(case when Attrition = 'Yes' then 1 else 0 end)/count(*),2) as attrition_rate
from employees_enriched
group by overworked_flag 
order by attrition_rate desc;

-- Compensation & Promotion
-- 1.Does income influence attrition?
select Income_Bracket ,
round(sum(case when Attrition='Yes' then 1 else 0 end)/count(*),2) as attrition_rate
from employees_enriched 
group by Income_Bracket
order by attrition_rate desc;

-- 2.Are employees leaving due to lack of promotion?
select Promotion_Status,
round(sum(case when Attrition ='Yes' then 1 else 0 end)/count(*),2) as attrition_rate
from employees_enriched
group by Promotion_Status
order by attrition_rate desc;

-- Performance & Satisfaction
-- 1. Does employee satisfaction affect attrition?
select JobSatisfaction,
round(sum(case when Attrition='Yes' then 1 else 0 end)/count(*),2) as attrition_rate
from employees
group by JobSatisfaction
order by attrition_rate desc;

-- 2.How do performance ratings relate to attrition?
select PerformanceRating,
round(sum(case when Attrition='Yes' then 1 else 0 end)/count(*),2) as attrition_rate
from employees
group by PerformanceRating
order by attrition_rate desc;

-- 3.Do low-satisfaction employees have shorter tenure?
SELECT 
  JobSatisfaction,
  Tenure_Level,
  COUNT(*) AS total_employees,
  ROUND(AVG(YearsAtCompany), 2) AS avg_tenure
FROM employees_enriched
GROUP BY JobSatisfaction, Tenure_Level
ORDER BY JobSatisfaction, Tenure_Level;





