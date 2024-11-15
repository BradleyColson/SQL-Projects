-- General Exploratory analysis 

select *
from telecomchurn;

-- Checking if any customer IDs are duplicates
-- None are duplicates
select 
	count(*) as count, customerID
from telecomchurn
group by customerID
having count > 1;

-- Overall churn rate
SELECT 
    COUNT(CASE WHEN churn = 'yes' THEN 1 END) / COUNT(*) AS overall_churn_rate
FROM 
    telecomchurn;

-- Is gender count skewed?
-- Gender is about evenly spread
select count(*) as count, gender
from telecomchurn
group by gender;

-- Count of churn per gender
-- Churn count is about the same
select Count(churn) as churnCount, Churn,  gender
from telecomchurn
group by Churn, gender;

-- Is churn different with or without a Partner?
-- Customers with no partner churn much more
select count(*) as count, Partner, Churn
from telecomchurn
where churn = 'Yes'
group by Partner;

select
	ROUND(COUNT(CASE WHEN Partner = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Partner = 'Yes' THEN 1 END), 2) AS Partner_CR,
    ROUND(COUNT(CASE WHEN Partner = 'No' AND churn = 'Yes' THEN 1 END) / COUNT(CASE WHEN Partner = 'No' THEN 1 END), 2) AS No_Partner_CR
from telecomchurn;

-- Is churn different with or without dependents?
-- Churn is much higher without dependents
select count(*) as count, Dependents, Churn
from telecomchurn
where churn = 'Yes'
group by Dependents;

select 
	ROUND(COUNT(CASE WHEN Dependents = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Dependents = 'Yes' THEN 1 END), 2) AS Dependents_CR,
    ROUND(COUNT(CASE WHEN Dependents = 'No' AND churn = 'Yes' THEN 1 END) / COUNT(CASE WHEN Dependents = 'No' THEN 1 END), 2) AS Dependents_CR
from telecomchurn;
-- Do senior citizens churn more?
-- 42% seniors churn rate
select 
	ROUND(COUNT(CASE WHEN seniorcitizen = 1 AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN seniorcitizen = 1 THEN 1 END), 2) AS senior_citizen_CR,
    ROUND(COUNT(CASE WHEN seniorcitizen = 0 AND churn = 'Yes' THEN 1 END) / COUNT(CASE WHEN seniorcitizen = 0 THEN 1 END), 2) AS Not_senior_citizen_CR
from telecomchurn;

-- The churn rate is double that among seniors by gender
SELECT 
    seniorcitizen,
    gender,
    COUNT(CASE WHEN churn = 'yes' THEN 1 END) / COUNT(*) AS churn_rate
FROM 
    telecomchurn
GROUP BY 
    seniorcitizen,
    gender
ORDER BY 
    churn_rate DESC;

-- How many customers have multiple lines and what's their churn rate?
-- More did not have multiple lines
select count(*) as count, MultipleLines, churn
from telecomchurn
group by MultipleLines,churn
order by churn desc;

-- Count of internet service
-- Customers with fiber service churn more
select count(*) as count, InternetService, churn
from telecomchurn
group by InternetService, churn
order by churn;


-- Count of phone serverice
-- Customers with phone service churn less
select count(*) as count, PhoneService, churn
from telecomchurn
group by PhoneService, churn
order by churn;



-- Any correlation to monthly charges and churn yes?
-- The difference is small
select round(avg(MonthlyCharges) , 2) as avg_monthly_charge, churn
from telecomchurn
group by churn;

-- Customers with longer tenure cancelled less
-- using subquery
-- Showing 27% churn rate with lower tenure
select 
	churn,
    round(avg(tenure),0) as tenure_in_months, 
    round((count(*)/ (select count(*) from telecomchurn))*100, 0) as percent
from telecomchurn
group by churn;

-- Churn rate per customer tenure
-- New customers churned the mosta
SELECT 
    CASE WHEN tenure < 6 THEN 'New customer under 6 months of service'
         WHEN tenure BETWEEN 6 AND 12 THEN 'Mid Term 6 months - 12 months'
         WHEN tenure BETWEEN 12 AND 24 THEN 'Long Term 12 months - 24 months'
         WHEN tenure BETWEEN 24 AND 36 THEN 'Long Term 24 months - 36 months'
         ELSE 'Long Term Over 36 months' END AS tenure_category,
         COUNT(CASE WHEN churn = 'yes' THEN 1 END) / COUNT(*) AS churn_rate
FROM 
    telecomchurn
GROUP BY 
    tenure_category
ORDER BY 
    churn_rate desc;




-- Does the churn rate change based on contract length
-- Month to month contracts show the high churn by far
-- Month to month contracts are the most popular
select
	contract,
    sum(case when churn = "Yes" then 1 else 0 end) as Total_Yes_Cancelled,
	sum(case when churn = "No" then 1 else 0 end) as Total_No_Cancelled,
    Count(*) as Total_contracts,
    round((SUM(case when churn = "Yes" then 1 else 0 end) / count(*)) * 100, 0) as Yes_Cancelled_pct,
    round((SUM(case when churn = "No" then 1 else 0 end) / count(*)) * 100,0) as No_Cancelled_pct
from telecomchurn
group by contract;


-- Does churn rate increase depending on payment method?
-- Churn rate for Election Check is nearly half%
select
	count(churn)  as  churn_total, 
    churn,
    PaymentMethod
from telecomchurn
group by paymentMethod, churn
order by churn;


-- churn count for add on services

SELECT
	churn,
    COUNT(CASE WHEN OnlineSecurity = 'Yes' THEN 1 END) AS OnlineSecurity,
    COUNT(CASE WHEN OnlineBackup = 'Yes' THEN 1 END) AS OnlineBackup,
    COUNT(CASE WHEN DeviceProtection = 'Yes' THEN 1 END) AS DeviceProtection,
	COUNT(CASE WHEN TechSupport = 'Yes' THEN 1 END) AS TechSupport,
    COUNT(CASE WHEN StreamingTV = 'Yes' THEN 1 END) AS StreamingTV,
    COUNT(CASE WHEN StreamingMovies = 'Yes' THEN 1 END) AS StreamingMovies
FROM telecomChurn
WHERE OnlineSecurity = 'Yes' OR OnlineBackup = 'Yes' OR DeviceProtection = "Yes"
GROUP BY churn;

-- Does average Total Cost show any relation to churn
-- Higher Total cost show less churn
select 
	round(avg(TotalCharges),0) as Average_Total_Cost,
    churn
from telecomchurn
group by Churn;

    

    
    -- Does ranging payments show any insights?
    -- Churn is higher among customers with hugher monthly charges
    SELECT 
    CASE WHEN monthlycharges < 50 THEN 'Low'
         WHEN monthlycharges BETWEEN 50 AND 100 THEN 'Medium'
         ELSE 'High' END AS monthly_charge_category,
    CASE WHEN totalcharges < 1000 THEN 'Low'
         WHEN totalcharges BETWEEN 1000 AND 2000 THEN 'Medium'
         ELSE 'High' END AS total_charge_category,
    COUNT(CASE WHEN churn = 'yes' THEN 1 END) / COUNT(*) AS churn_rate
FROM 
    telecomchurn
GROUP BY 
    monthly_charge_category,
    total_charge_category
ORDER BY 
    churn_rate DESC;
    

    
-- Overall churn by demographics and services    
SELECT

    -- Churn rate by demographics
    ROUND(COUNT(CASE WHEN gender = 'male' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN gender = 'male' THEN 1 END), 2) AS male_CR,
    ROUND(COUNT(CASE WHEN gender = 'female' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN gender = 'female' THEN 1 END), 2) AS female_CR,
    ROUND(COUNT(CASE WHEN seniorcitizen = 1 AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN seniorcitizen = 1 THEN 1 END), 2) AS senior_citizen_CR,
    ROUND(COUNT(CASE WHEN seniorcitizen = 0 AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN seniorcitizen = 0 THEN 1 END), 2) AS Not_senior_citizen_CR,
	ROUND(COUNT(CASE WHEN Partner = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Partner = 'Yes' THEN 1 END), 2) AS Partner_CR,
	ROUND(COUNT(CASE WHEN Partner = 'No' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Partner = 'No' THEN 1 END), 2) AS No_Partner_CR,
    ROUND(COUNT(CASE WHEN Dependents = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Dependents = 'Yes' THEN 1 END), 2) AS Dependents_CR,
    ROUND(COUNT(CASE WHEN Dependents = 'No' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Dependents = 'No' THEN 1 END), 2) AS NoDependents_CR,
    
    -- Churn rate by product category
    ROUND(COUNT(CASE WHEN phoneservice = 'yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN phoneservice = 'yes' THEN 1 END), 2) AS phone_service_CR,
    ROUND(COUNT(CASE WHEN phoneservice = 'no' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN phoneservice = 'no' THEN 1 END), 2) AS No_phone_service_CR,
    ROUND(COUNT(CASE WHEN multiplelines = 'yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN multiplelines = 'yes' THEN 1 END), 2) AS multiple_lines_CR,
    ROUND(COUNT(CASE WHEN multiplelines = 'No' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN multiplelines = 'No' THEN 1 END), 2) AS No_multiple_lines_CR,
    ROUND(COUNT(CASE WHEN internetService = 'DSL' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN internetService = 'DSL' THEN 1 END), 2) AS dsl_CR,
    ROUND(COUNT(CASE WHEN internetService = 'Fiber Optic' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN internetService = 'Fiber Optic' THEN 1 END), 2) AS fiber_optic_CR,
    ROUND(COUNT(CASE WHEN OnlineSecurity = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN OnlineSecurity = 'Yes' THEN 1 END), 2) AS OnlineSecurity_CR,
	ROUND(COUNT(CASE WHEN OnlineBackup = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN OnlineBackup = 'Yes' THEN 1 END), 2) AS OnlineBackup_CR,
    ROUND(COUNT(CASE WHEN DeviceProtection = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN DeviceProtection = 'Yes'THEN 1 END), 2) AS DeviceProtection_CR,
    ROUND(COUNT(CASE WHEN TechSupport = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN TechSupport = 'Yes' THEN 1 END), 2) AS TechSupport_CR,
    ROUND(COUNT(CASE WHEN StreamingTV = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN StreamingTV = 'Yes' THEN 1 END), 2) AS StreamingTV_CR,
    ROUND(COUNT(CASE WHEN StreamingMovies = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN StreamingMovies = 'Yes' THEN 1 END), 2) AS StreamingMovies_CR,
    
    
       -- Churn rate by contract length
    ROUND(COUNT(CASE WHEN contract = 'Month-to-month' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN contract = 'Month-to-month' THEN 1 END), 2) AS month_to_month_CR,
    ROUND(COUNT(CASE WHEN contract = 'One Year' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN contract = 'One Year' THEN 1 END), 2) AS One_Year_CR,
    ROUND(COUNT(CASE WHEN contract = 'Two Year' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN contract = 'Two Year' THEN 1 END), 2) AS Two_Year_CR,

	-- Churn rate by payment method

	ROUND(COUNT(CASE WHEN PaymentMethod = 'Electronic Check' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Electronic Check' THEN 1 END), 2) AS ElectronicCheck_CR,
    ROUND(COUNT(CASE WHEN PaymentMethod = 'Mailed Check' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Mailed Check' THEN 1 END), 2) AS Mailed_CR,
    ROUND(COUNT(CASE WHEN PaymentMethod = 'Bank Transfer (automatic)' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Bank Transfer (automatic)' THEN 1 END), 2) AS Bank_Transfer_CR,
	ROUND(COUNT(CASE WHEN PaymentMethod = 'Credit Card (automatic)' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Credit Card (automatic)' THEN 1 END), 2) AS Credit_Card_CR,
    -- Churn rate by monthly and total charges

    ROUND(AVG(CASE WHEN churn = 'yes' THEN monthlycharges ELSE NULL END), 2) AS avg_monthly_charge_for_churned,
    ROUND(AVG(CASE WHEN churn = 'no' THEN monthlycharges ELSE NULL END), 2) AS avg_monthly_charge_for_not_churned,
    ROUND(AVG(CASE WHEN churn = 'yes' THEN totalcharges ELSE NULL END), 2) AS avg_total_charge_for_churned,
    ROUND(AVG(CASE WHEN churn = 'no' THEN totalcharges ELSE NULL END), 2) AS avg_total_charge_for_not_churned
FROM telecomchurn;

-- Which categories are highest for senior citizens
-- No partner, No children, Fiber optic. Month to month contract, and Electronic Check or Mailed Check have the highest churn for senios
SELECT
    SeniorCitizen,
    -- Churn rate by demographics
    ROUND(COUNT(CASE WHEN gender = 'male' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN gender = 'male' THEN 1 END), 2) AS male_CR,
    ROUND(COUNT(CASE WHEN gender = 'female' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN gender = 'female' THEN 1 END), 2) AS female_CR,
    ROUND(COUNT(CASE WHEN seniorcitizen = 1 AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN seniorcitizen = 1 THEN 1 END), 2) AS senior_citizen_CR,
    ROUND(COUNT(CASE WHEN seniorcitizen = 0 AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN seniorcitizen = 0 THEN 1 END), 2) AS Not_senior_citizen_CR,
	ROUND(COUNT(CASE WHEN Partner = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Partner = 'Yes' THEN 1 END), 2) AS Partner_CR,
	ROUND(COUNT(CASE WHEN Partner = 'No' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Partner = 'No' THEN 1 END), 2) AS No_Partner_CR,
    ROUND(COUNT(CASE WHEN Dependents = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Dependents = 'Yes' THEN 1 END), 2) AS Dependents_CR,
    ROUND(COUNT(CASE WHEN Dependents = 'No' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Dependents = 'No' THEN 1 END), 2) AS NoDependents_CR,
    -- Churn rate by product category
    ROUND(COUNT(CASE WHEN phoneservice = 'yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN phoneservice = 'yes' THEN 1 END), 2) AS phone_service_CR,
    ROUND(COUNT(CASE WHEN phoneservice = 'no' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN phoneservice = 'no' THEN 1 END), 2) AS No_phone_service_CR,
    ROUND(COUNT(CASE WHEN multiplelines = 'yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN multiplelines = 'yes' THEN 1 END), 2) AS multiple_lines_CR,
    ROUND(COUNT(CASE WHEN multiplelines = 'No' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN multiplelines = 'No' THEN 1 END), 2) AS No_multiple_lines_CR,
    ROUND(COUNT(CASE WHEN internetService = 'DSL' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN internetService = 'DSL' THEN 1 END), 2) AS dsl_CR,
    ROUND(COUNT(CASE WHEN internetService = 'Fiber Optic' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN internetService = 'Fiber Optic' THEN 1 END), 2) AS fiber_optic_CR,
    ROUND(COUNT(CASE WHEN OnlineSecurity = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN OnlineSecurity = 'Yes' THEN 1 END), 2) AS OnlineSecurity_CR,
	ROUND(COUNT(CASE WHEN OnlineBackup = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN OnlineBackup = 'Yes' THEN 1 END), 2) AS OnlineBackup_CR,
    ROUND(COUNT(CASE WHEN DeviceProtection = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN DeviceProtection = 'Yes'THEN 1 END), 2) AS DeviceProtection_CR,
    ROUND(COUNT(CASE WHEN TechSupport = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN TechSupport = 'Yes' THEN 1 END), 2) AS TechSupport_CR,
    ROUND(COUNT(CASE WHEN StreamingTV = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN StreamingTV = 'Yes' THEN 1 END), 2) AS StreamingTV_CR,
    ROUND(COUNT(CASE WHEN StreamingMovies = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN StreamingMovies = 'Yes' THEN 1 END), 2) AS StreamingMovies_CR,
    
    
       -- Churn rate by contract length
    ROUND(COUNT(CASE WHEN contract = 'Month-to-month' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN contract = 'Month-to-month' THEN 1 END), 2) AS month_to_month_CR,
    ROUND(COUNT(CASE WHEN contract = 'One Year' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN contract = 'One Year' THEN 1 END), 2) AS One_Year_CR,
    ROUND(COUNT(CASE WHEN contract = 'Two Year' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN contract = 'Two Year' THEN 1 END), 2) AS Two_Year_CR,

	-- Churn rate by payment method

	ROUND(COUNT(CASE WHEN PaymentMethod = 'Electronic Check' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Electronic Check' THEN 1 END), 2) AS ElectronicCheck_CR,
    ROUND(COUNT(CASE WHEN PaymentMethod = 'Mailed Check' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Mailed Check' THEN 1 END), 2) AS Mailed__CheckCR,
    ROUND(COUNT(CASE WHEN PaymentMethod = 'Bank Transfer (automatic)' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Bank Transfer (automatic)' THEN 1 END), 2) AS Bank_Transfer_CR,
	ROUND(COUNT(CASE WHEN PaymentMethod = 'Credit Card (automatic)' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Credit Card (automatic)' THEN 1 END), 2) AS Credit_Card_CR
   
FROM  telecomchurn
where SeniorCitizen = 1;

--  Looking at the churn rate for customers with no partner in particular
--  
SELECT
    Partner,
    -- Churn rate by demographics
    ROUND(COUNT(CASE WHEN gender = 'male' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN gender = 'male' THEN 1 END), 2) AS male_CR,
    ROUND(COUNT(CASE WHEN gender = 'female' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN gender = 'female' THEN 1 END), 2) AS female_CR,
    ROUND(COUNT(CASE WHEN seniorcitizen = 1 AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN seniorcitizen = 1 THEN 1 END), 2) AS senior_citizen_CR,
    ROUND(COUNT(CASE WHEN seniorcitizen = 0 AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN seniorcitizen = 0 THEN 1 END), 2) AS Not_senior_citizen_CR,
	ROUND(COUNT(CASE WHEN Partner = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Partner = 'Yes' THEN 1 END), 2) AS Partner_CR,
	ROUND(COUNT(CASE WHEN Partner = 'No' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Partner = 'No' THEN 1 END), 2) AS No_Partner_CR,
    ROUND(COUNT(CASE WHEN Dependents = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Dependents = 'Yes' THEN 1 END), 2) AS Dependents_CR,
    ROUND(COUNT(CASE WHEN Dependents = 'No' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN Dependents = 'No' THEN 1 END), 2) AS NoDependents_CR,
    -- Churn rate by product category
    ROUND(COUNT(CASE WHEN phoneservice = 'yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN phoneservice = 'yes' THEN 1 END), 2) AS phone_service_CR,
    ROUND(COUNT(CASE WHEN phoneservice = 'no' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN phoneservice = 'no' THEN 1 END), 2) AS No_phone_service_CR,
    ROUND(COUNT(CASE WHEN multiplelines = 'yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN multiplelines = 'yes' THEN 1 END), 2) AS multiple_lines_CR,
    ROUND(COUNT(CASE WHEN multiplelines = 'No' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN multiplelines = 'No' THEN 1 END), 2) AS No_multiple_lines_CR,
    ROUND(COUNT(CASE WHEN internetService = 'DSL' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN internetService = 'DSL' THEN 1 END), 2) AS dsl_CR,
    ROUND(COUNT(CASE WHEN internetService = 'Fiber Optic' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN internetService = 'Fiber Optic' THEN 1 END), 2) AS fiber_optic_CR,
    ROUND(COUNT(CASE WHEN OnlineSecurity = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN OnlineSecurity = 'Yes' THEN 1 END), 2) AS OnlineSecurity_CR,
	ROUND(COUNT(CASE WHEN OnlineBackup = 'Yes' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN OnlineBackup = 'Yes' THEN 1 END), 2) AS OnlineBackup_CR,
    ROUND(COUNT(CASE WHEN DeviceProtection = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN DeviceProtection = 'Yes'THEN 1 END), 2) AS DeviceProtection_CR,
    ROUND(COUNT(CASE WHEN TechSupport = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN TechSupport = 'Yes' THEN 1 END), 2) AS TechSupport_CR,
    ROUND(COUNT(CASE WHEN StreamingTV = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN StreamingTV = 'Yes' THEN 1 END), 2) AS StreamingTV_CR,
    ROUND(COUNT(CASE WHEN StreamingMovies = 'YEs' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN StreamingMovies = 'Yes' THEN 1 END), 2) AS StreamingMovies_CR,
    
    
       -- Churn rate by contract length
    ROUND(COUNT(CASE WHEN contract = 'Month-to-month' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN contract = 'Month-to-month' THEN 1 END), 2) AS month_to_month_CR,
    ROUND(COUNT(CASE WHEN contract = 'One Year' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN contract = 'One Year' THEN 1 END), 2) AS One_Year_CR,
    ROUND(COUNT(CASE WHEN contract = 'Two Year' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN contract = 'Two Year' THEN 1 END), 2) AS Two_Year_CR,

	-- Churn rate by payment method

	ROUND(COUNT(CASE WHEN PaymentMethod = 'Electronic Check' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Electronic Check' THEN 1 END), 2) AS ElectronicCheck_CR,
    ROUND(COUNT(CASE WHEN PaymentMethod = 'Mailed Check' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Mailed Check' THEN 1 END), 2) AS Mailed__CheckCR,
    ROUND(COUNT(CASE WHEN PaymentMethod = 'Bank Transfer (automatic)' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Bank Transfer (automatic)' THEN 1 END), 2) AS Bank_Transfer_CR,
	ROUND(COUNT(CASE WHEN PaymentMethod = 'Credit Card (automatic)' AND churn = 'yes' THEN 1 END) / COUNT(CASE WHEN PaymentMethod = 'Credit Card (automatic)' THEN 1 END), 2) AS Credit_Card_CR
   
FROM  telecomchurn
where Partner = 'No'