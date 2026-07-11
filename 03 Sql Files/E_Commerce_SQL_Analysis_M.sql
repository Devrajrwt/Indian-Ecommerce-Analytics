========================================================================================
-- DATABASE SETUP & ENVIRONMENT INITIALIZATION
========================================================================================

-- First create Target Environment Database
DROP DATABASE IF EXISTS E_commerce_db;

CREATE DATABASE e_commerce_db;

-- Second create your table
-- Establish Core Operational Transaction Table Schema
DROP TABLE IF EXISTS ecommerce;

CREATE TABLE ecommerce_sales (
					order_id VARCHAR(50),
				    order_date DATE,
				    customer_id VARCHAR(50),
				    customer_name VARCHAR(100),
				    customer_age INT,
				    city VARCHAR(100),
				    state VARCHAR(100),
				    zone VARCHAR(50),
				    category VARCHAR(100),
				    product VARCHAR(255),
				    sku VARCHAR(100),
				    quantity INT,
				    unit_price NUMERIC(10,2),
				    gross_sales NUMERIC(12,2),
				    coupon_code VARCHAR(50),
				    discount_amount NUMERIC(12,2),
				    gst_rate NUMERIC(5,2),
				    net_sales NUMERIC(12,2),
				    gst_amount NUMERIC(12,2),
				    payment_mode VARCHAR(50),
				    order_status VARCHAR(50),
				    sales_channel VARCHAR(50),
				    sales_employee VARCHAR(100),
				    delivery_partner VARCHAR(100),
				    delivery_days INT,
				    customer_rating NUMERIC(3,1),
				    cogs NUMERIC(12,2),
				    profit NUMERIC(12,2),
				    profit_margin_pct NUMERIC(5,2),
				    shipping_charges NUMERIC(12,2),
				    invoice_amount NUMERIC(12,2)
);

SELECT * FROM ecommerce_sales;

-- CSV Import
-- Note: Adjust local system directory path parameters as necessary during deployment
COPY ecommerce_sales (order_id, order_date, customer_id, customer_name, customer_age, city, state, zone, category, product, sku, quantity, unit_price, gross_sales, coupon_code, discount_amount, gst_rate, net_sales, gst_amount, payment_mode, order_status, sales_channel, sales_employee, delivery_partner, delivery_days, customer_rating, cogs, profit, profit_margin_pct, shipping_charges, invoice_amount)
FROM 'E:\All My Study\Data Analytics Projects\All My Projects Inside\01 data\Project_2_E_Commerce\ecommerce_sales_clean_csv.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM ecommerce_sales;

========================================================================================
-- DATA QUALITY CONTROL & INTEGRITY AUDITS
========================================================================================
-- AUDIT 1: Total Baseline Logistical Records Check
-- INSIGHT: System populated exactly 2,500 transactional lines; matching the target staging footprint.
SELECT COUNT(*) AS total_records 
FROM ecommerce_sales;


-- AUDIT 2: Structural Uniqueness (Unique Customer Footprint)
-- INSIGHT: Captured 2,465 unique consumers, demonstrating low recurring purchase patterns across this period.
SELECT COUNT(DISTINCT customer_id) AS unique_customers 
FROM ecommerce_sales;


-- AUDIT 3: Product Inventory Depth Check
-- INSIGHT: Inventory distribution tracks 46 distinct product types across the commercial catalog.
SELECT COUNT(DISTINCT product) AS distinct_products 
FROM ecommerce_sales;


-- AUDIT 4: Regional Market Footprint Check
-- INSIGHT: Transactional fulfillment tracks distribution networks covering 19 Indian states.
SELECT COUNT(DISTINCT state) AS active_states 
FROM ecommerce_sales;


-- AUDIT 5: Core Financial Reconciled Revenue Validation
-- INSIGHT: Total portfolio gross sales across all order conditions balances to exactly ₹28,980,436.45.
SELECT ROUND(SUM(net_sales),2) AS total_reconciled_sales 
FROM ecommerce_sales;


-- QUESTION 1: Which top 10 specific products drive the largest share of company revenue?
-- INSIGHT: Laptops and Smartphones occupy the highest revenue velocity slots, indicating 
-- that high-ticket electronics anchor top-line performance.
SELECT
    product,
    ROUND(SUM(net_sales),2) AS revenue
FROM ecommerce_sales
GROUP BY product
ORDER BY revenue DESC
LIMIT 10;


-- QUESTION 2: Which macro product categories deliver the healthiest combination of revenue and profitability?
-- INSIGHT: Electronics acts as the primary volume driver, but Home & Kitchen shows higher net margins 
-- relative to operating scale.
SELECT
    category,
    ROUND(SUM(net_sales),2) AS revenue,
    ROUND(SUM(profit),2) AS profit
FROM ecommerce_sales
GROUP BY category
ORDER BY revenue DESC;


-- QUESTION 3: What is the exact percentage contribution of each product category to global platform revenue?
-- INSIGHT: Electronics represents a high dependency risk for the firm, capturing a massive 53.53% of total revenue share.
SELECT
    category,
    ROUND(SUM(net_sales),2) AS revenue,
    ROUND(SUM(net_sales) * 100.0 / SUM(SUM(net_sales)) OVER (),2) AS revenue_share_pct
FROM ecommerce_sales
GROUP BY category
ORDER BY revenue DESC;


-- QUESTION 4: Which geographic state environments generate the top 10 highest market sales volumes?
-- INSIGHT: Tier-1 consumer concentrations in Maharashtra and Gujarat serve as the core geographical revenue pillars.
SELECT
    state,
    ROUND(SUM(net_sales),2) AS revenue
FROM ecommerce_sales
GROUP BY state
ORDER BY revenue DESC
LIMIT 10;


-- QUESTION 5: What is the relative percentage distribution of corporate revenue across individual states?
-- INSIGHT: The top 3 geographic states drive a substantial portion of sales, providing clear direction for 
-- hyper-targeted regional marketing campaigns.
SELECT
    state,
    ROUND(SUM(net_sales),2) AS revenue,
    ROUND(SUM(net_sales) * 100.0 / (SELECT SUM(net_sales) FROM ecommerce_sales), 2) AS revenue_pct
FROM ecommerce_sales
GROUP BY state
ORDER BY revenue DESC;


-- QUESTION 6: Which payment channels clear the largest revenue volumes and lock in the highest profit retains?
-- INSIGHT: UPI dominates platform fintech channels, driving over 45% of total revenue. 
-- STRATEGIC ACTION: Ensure completely frictionless checkout engineering to protect UPI success rates.
SELECT
    payment_mode,
    ROUND(SUM(net_sales),2) AS revenue,
    ROUND(SUM(profit),2) AS profit
FROM ecommerce_sales
GROUP BY payment_mode
ORDER BY revenue DESC;


-- QUESTION 7: What is the percentage breakout of inventory across individual delivery execution statuses?
-- INSIGHT: Fulfilling orders successfully (Delivered) sits at 74.88%. 
-- Cancellations and returns account for structural margin leakage that requires operational guardrails.
SELECT
    order_status,
    COUNT(*) AS orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS order_pct
FROM ecommerce_sales
GROUP BY order_status
ORDER BY orders DESC;


-- QUESTION 8: Which specific consumer age group segments generate the highest sales volumes and order totals?
-- INSIGHT: Mid-career professionals aged 45-54 and 25-34 possess the highest relative spending capacities, 
-- yielding the platform's prime revenue engines.
SELECT
    CASE
        WHEN customer_age < 25 THEN 'Under 25'
        WHEN customer_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN customer_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN customer_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS orders,
    ROUND(SUM(net_sales),2) AS revenue
FROM ecommerce_sales
GROUP BY age_group
ORDER BY revenue DESC;


-- QUESTION 9: Who are the top 10 highest grossing client accounts across the historical dataset?
-- INSIGHT: High-value individual consumer accounts can be isolated for 
-- automated premium membership tiers or targeted customer-retention incentives.
SELECT
    customer_id,
    customer_name,
    ROUND(SUM(net_sales),2) AS revenue
FROM ecommerce_sales
GROUP BY customer_id, customer_name
ORDER BY revenue DESC
LIMIT 10;


-- QUESTION 10: How do product categories rank sequentially against each other when evaluating total net revenue performance?
-- INSIGHT: Standardizing performance metrics across macro categories via 
-- analytical window rankings easily isolates core inventory focus areas.
SELECT
    category,
    ROUND(SUM(net_sales),2) AS revenue,
    RANK() OVER (ORDER BY SUM(net_sales) DESC) AS revenue_rank
FROM ecommerce_sales
GROUP BY category;


-- QUESTION 11: How do individual states rank when measuring top-line financial performance metrics?
-- INSIGHT: Clearly highlights high-yielding logistics zones 
-- versus regional markets where expansion or demand-generation operations are lagging.
SELECT
    state,
    ROUND(SUM(net_sales),2) AS revenue,
    RANK() OVER (ORDER BY SUM(net_sales) DESC) AS revenue_rank
FROM ecommerce_sales
GROUP BY state;


-- QUESTION 12: Who are the elite top 5 highest spending consumers on the platform, isolated via analytical partitions?
-- INSIGHT: Utilizing nested inner table queries allows dynamic slicing filters to 
-- isolate top-tier customer loyalty distributions.
SELECT *
FROM (
     SELECT
         customer_id,
         customer_name,
         ROUND(SUM(net_sales),2) AS revenue,
         ROW_NUMBER() OVER (ORDER BY SUM(net_sales) DESC) AS rn
     FROM ecommerce_sales
     GROUP BY customer_id, customer_name
     ) t
WHERE rn <= 5;


-- QUESTION 13: What is the monthly transactional velocity of revenue across the platform?
-- INSIGHT: Provides crucial visibility into seasonal purchase shifts, 
-- allowing management to build data-backed inventory planning schedules.
SELECT
    DATE_TRUNC('month', order_date) AS months,
    ROUND(SUM(net_sales),2) AS revenue
FROM ecommerce_sales
GROUP BY months
ORDER BY months;


-- QUESTION 14: What is the cumulative running total of revenue generated month-over-month throughout the tracking cycle?
-- INSIGHT: Showcases steady, continuous fiscal running totals, 
-- proving strong platform trajectory and sustainable long-term revenue velocity.
SELECT
    DATE_TRUNC('month', order_date) AS months,
    ROUND(SUM(net_sales),2) AS monthly_revenue,
    ROUND(SUM(SUM(net_sales)) OVER (ORDER BY DATE_TRUNC('month', order_date)),2) AS cumulative_revenue
FROM ecommerce_sales
GROUP BY months
ORDER BY months;


-- QUESTION 15: Which product categories yield the strongest absolute net profit margins for the enterprise?
-- INSIGHT: Identifies hidden profit engines; helping marketing teams balance high-volume 
-- categories against high-margin opportunities.
SELECT
    category,
    ROUND(SUM(profit),2) AS profit,
    ROUND(SUM(net_sales),2) AS revenue,
    ROUND(SUM(profit) * 100.0 / SUM(net_sales),2) AS profit_margin_pct
FROM ecommerce_sales
GROUP BY category
ORDER BY profit_margin_pct DESC;


-- QUESTION 16: Which top 10 specific products drive the highest volume of net absolute profitability?
-- INSIGHT: Ensures procurement capital investments are prioritized toward high-margin 
-- SKUs rather than zero-margin items.
SELECT
    product,
    ROUND(SUM(profit),2) AS profit
FROM ecommerce_sales
GROUP BY product
ORDER BY profit DESC
LIMIT 10;


-- QUESTION 17: Which active corporate sales channels clear the largest revenue volumes and absolute profits?
-- INSIGHT: The Mobile App channel stands out as a major growth channel, 
-- outperforming web desktop channels for modern digital consumers.
SELECT
    sales_channel,
    ROUND(SUM(net_sales),2) AS revenue,
    ROUND(SUM(profit),2) AS profit
FROM ecommerce_sales
GROUP BY sales_channel
ORDER BY revenue DESC;


-- QUESTION 18: What is the exact turnaround efficiency (average delivery speed) across our logistics fulfillment partners?
-- INSIGHT: Highlights operational shipping speeds. Third-party logistics partners underperforming 
-- established targets can be systematically held to core SLAs.
SELECT
    delivery_partner,
    COUNT(*) AS orders,
    ROUND(AVG(delivery_days),2) AS avg_delivery_days
FROM ecommerce_sales
GROUP BY delivery_partner
ORDER BY avg_delivery_days;


-- QUESTION 19: What are the combined, top-level macro financial and operational KPIs for an executive briefing?
-- INSIGHT: Delivers a holistic, executive summary of health across sales, customer feedback scores, 
-- and fulfillment transit speeds.
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(net_sales),2) AS revenue,
    ROUND(SUM(profit),2) AS profit,
    ROUND(AVG(customer_rating),2) AS avg_rating,
    ROUND(AVG(delivery_days),2) AS avg_delivery_days
FROM ecommerce_sales;



