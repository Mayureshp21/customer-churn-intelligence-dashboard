-- ============================================
-- 1. CREATE DATABASE & SELECT IT
-- ============================================

-- Create a new database for the churn project
CREATE DATABASE ChurnProject;

-- Switch to the created database
USE ChurnProject;


-- ============================================
-- 2. PREVIEW DATA
-- ============================================

-- View first 10 records to understand structure of data
SELECT TOP 10 * FROM customers;


-- ============================================
-- 3. DATA QUALITY CHECK (NULL VALUES)
-- ============================================

-- Count total number of records in dataset
SELECT COUNT(*) AS total_rows FROM customers;
-- Check how many records have missing TotalCharges
SELECT COUNT(*) AS null_totalcharges
FROM customers
WHERE TotalCharges IS NULL;

-- Preview TotalCharges column to inspect values
SELECT TOP 10 TotalCharges FROM customers;


-- ============================================
-- 4. DATA CLEANING
-- ============================================

-- Remove records where TotalCharges is NULL
-- (These rows are incomplete and can affect analysis)
DELETE FROM customers
WHERE TotalCharges IS NULL;

-- Verify that null values are removed
SELECT COUNT(*) 
FROM customers
WHERE TotalCharges IS NULL;


-- ============================================
-- 5. TARGET VARIABLE ANALYSIS (CHURN DISTRIBUTION)
-- ============================================

-- Understand how many customers churned vs stayed
SELECT Churn, COUNT(*) AS count
FROM customers
GROUP BY Churn;


-- ============================================
-- 6. BUSINESS ANALYSIS: CONTRACT TYPE VS CHURN
-- ============================================

-- Analyze churn count based on contract type
SELECT Contract, 
COUNT(*) AS total,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM customers
GROUP BY Contract;

-- Calculate churn percentage for each contract type
SELECT Contract,
COUNT(*) AS total,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate
FROM customers
GROUP BY Contract;


-- ============================================
-- 7. BUSINESS ANALYSIS: PAYMENT METHOD VS CHURN
-- ============================================

-- Analyze churn behavior based on payment method
SELECT PaymentMethod,
       COUNT(*) AS total,
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
       (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate
FROM customers
GROUP BY PaymentMethod;


-- ============================================
-- 8. CUSTOMER SEGMENTATION BASED ON TENURE
-- ============================================

-- Segment customers into groups based on how long they stayed
-- Then analyze churn behavior for each segment
SELECT 
CASE 
WHEN tenure < 12 THEN 'New Customers'
WHEN tenure BETWEEN 12 AND 24 THEN 'Mid-term'
ELSE 'Long-term'
END AS customer_type,
COUNT(*) AS total,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,    
(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate
FROM customers
GROUP BY 
CASE 
WHEN tenure < 12 THEN 'New Customers'
WHEN tenure BETWEEN 12 AND 24 THEN 'Mid-term'
ELSE 'Long-term'
END;


-- ============================================
-- 9. ADVANCED ANALYSIS: CONTRACT + CUSTOMER STAGE
-- ============================================

-- Combine contract type and customer stage (new vs existing)
-- to identify high-risk churn segments
SELECT Contract,
CASE WHEN tenure < 12 THEN 'New' ELSE 'Existing' END AS customer_stage,
COUNT(*) AS total,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate
FROM customers
GROUP BY Contract,
CASE WHEN tenure < 12 THEN 'New' ELSE 'Existing' END;