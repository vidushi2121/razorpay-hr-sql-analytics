# 🔍 HR Analytics SQL Project – Razorpay-Inspired

## About the Project

This SQL-based HR analytics project replicates challenges Razorpay or any fast-scaling startup may face with employee attrition. Using structured queries and feature engineering, we uncover trends around compensation, promotions, overwork, tenure, and more.

## Purpose of the Project

\- Identify key drivers of attrition using SQL.  
\- Apply business-focused feature engineering.  
\- Translate raw HR data into actionable insights.  
\- Prepare insights for dashboarding & storytelling (Power BI in Part 2).

## About the Dataset

\- Based on the IBM HR Analytics dataset (public).  
\- Modified to reflect a Razorpay-like context.  
\- Contains 1,400+ employee records.  
\- Key columns: Attrition, JobRole, MonthlyIncome, OverTime, YearsSinceLastPromotion, etc.

## Project Structure

1\. Data Import & Cleaning  
→ Imported \`.csv\` into MySQL  
→ Renamed columns for Razorpay context  
2\. Feature Engineering  
→ Created new fields to help answer real-world questions (see below)  
3\. Exploratory Data Analysis (EDA)  
→ Grouped by segments (Demographics, Department, Tenure, etc.)  
4\. Business Insights  
→ Summarized as tables + later visualized in Power BI

## 🛠️ Feature Engineering (SQL)

We engineered the following features to deepen our analysis:

| New Column | Logic |
| --- | --- |
| Income_Bracket | Categorized monthly income (Low, Medium, High) |
| Tenure_Level | Based on TotalWorkingYears (Junior, Mid-Level, Senior) |
| Overworked_Flag | OverTime = Yes + High Training |
| Promotion_Status | \>3 years since promotion = "Stagnant" |
| Age_Group | Young (<30), Mid-Age (30–45), Experienced (45+) |

## Exploratory Data Analysis (EDA)

1. Demographics-Based Analysis  
    \- Gender vs. Attrition  
    \- Age Group vs. Attrition  
    \- Marital Status vs. Attrition  
    \- Education Field vs. Attrition
2. Departmental & Role Trends  
    \- Department vs. Attrition Rate  
    \- Job Role vs. Attrition Rate  
    \- Most affected departments
3. Work-Life Balance & Overtime  
    \- OverTime vs. Attrition  
    \- Overworked Flag vs. Attrition  
    \- WorkLifeBalance vs. Attrition
4. Compensation & Promotions  
    \-Income vs Attrition
    \- Promotion_Status vs. Attrition
5. Performance & Tenure  
    \-Employee Satisfaction vs. Attrition  
    \- Performance Rating vs. Attrition  
    \- Avg Tenure of employees who stayed vs. left


## 📊 Key Insights

| Insight | Description |
| --- | --- |
| 🚨 Overworked employees | Had ~2.5x higher attrition |
| 📉 Low Job Satisfaction | More likely to leave |
| 🧑‍💼 Sales Executives | Had highest churn |
| ⏳ No promotion in 3+ years | Strong attrition signal |
| 🧒 Younger employees | Left at significantly higher rates |

## 📂 Files in This Repo

\- razorpay_hr_data.csv – Cleaned HR dataset  
\- Razorpay_HR_Analysis.sql – SQL file  
\- RAZORPAY_HR_Analytics_SQL_Project_README.md – This file

## 🧠 What I Learned

\- Writing scalable SQL queries for real-world problems  
\- Using views to simplify complex feature logic  
\- Structuring analysis by business questions  
\- Preparing SQL outputs for dashboards and storytelling

## What's Next

💪 Part 2: Power BI Dashboard  
Includes:  
\- Interactive visuals  
\- KPIs  

## 🔗 Connect With Me

📧 Email: <vidushiiarora123@gmail.com>  
💼 LinkedIn: [vidushi-arora-](https://www.linkedin.com/in/vidushi-arora-)    


