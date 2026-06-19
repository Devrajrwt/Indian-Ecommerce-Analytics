# Indian E-Commerce Sales & Operational Fintech Analysis

## Project Overview
This project presents an end-to-end data analytics workflow on a multi-dimensional Indian e-commerce dataset containing 2,500 records from January 2024 to December 2025. 
	The dataset tracks 31 analytical dimensions including product categories, specialized discounting models, tax structures (GST), 
digital payment frameworks, and complex regional fulfillment logistics across India.

### The Business Problem
Modern e-commerce enterprises operating in India face complex ecosystem variables. 
Profitability relies on managing distinct domestic variables: optimizing payment gateways across hyper-growth digital networks (UPI) 
versus alternative cash options, adjusting regional promotional markdown rates, ensuring order delivery SLAs across diverse delivery partners, 
and minimizing return/cancellation leakage. This project untangles these operational nodes to maximize margins.

---

## 🛠️ Tools & Technologies Used
| Tool / Library | Purpose |
| :--- | :--- |
| **Excel & Power Query** | Initial Data Integrity Assessment, Pivot Tables, and Inconsistency Cleansing |
| **PostgreSQL** | Relational Schema Design, Window Partitions, and Core Metric Aggregation |
| **Python (Pandas & NumPy)**| Null Record Diagnostics, Data Slicing, and Vectorized Mass Mathematics |
| **Matplotlib & Seaborn** | Statistical Visualizations & Exploratory Trend Plotting |
| **Power BI Desktop** | Relational Star-Schema Modeling, Time-Intelligence DAX, & 4-Page Dashboarding |
| **GitHub** | Project Version Control and Public Portfolio Documentation |

---

##  Repository Structure

ecommerce_sales_clean_csv.csv                   # Production CSV transaction data (2,500 rows)
ecommerce_sales_clean_excel_pivot.xlsx          # Diagnostic Pivot Tables & baseline aggregations
E_Commerce_SQL_Analysis_M.sql                   # Corporate business queries & database staging schema
E_Commerce_EDA_&_Visualizations_M.ipynb         # Jupyter notebook detailing statistical Exploratory Analysis
Interactive Dashboards/
 01 Executive Overview.jpg                      # Strategic financial macro-KPI view
 02 Sales and Product Performance.jpg           # Granular inventory P&L and coupon code matrix
 03 Geography & Customer Analysis.jpg           # Demographic spend & logistics partner scorecards
 04 Operations & Trends.jpg                     # YoY growth velocities & predictive scatter models
 README.md                                       # Portfolio documentation landing page

📈 Power BI Production Dashboard (4-Page Executive Suite)
1. Executive Financial Overview
Tracks executive-level metrics including Net Sales, Net Profits, and Order Conversion Splits. 
Features dynamic slice panels allowing instantly refreshable metrics filtered by Calendar Year and Geographic Zone.

2. Commercial Inventory & Sales Channel Performance
Unpacks the profitability curves of core catalog offerings and matches revenue directly to the driving transactional 
sales channels (Mobile App vs. Web vs. Social Commerce).

3. Geographical Demographics & Logistical Velocity
Pairs delivery turnaround day metrics against consumer rating scores to rank order fulfillment partners, 
while evaluating customer age groups and category return rates.

4. Corporate Operations & Macro Trends
An advanced trending layout tracking Year-over-Year (YoY) net sales overlays, cumulative financial running velocities, 
and multi-axis category margin analyses.

🔍 Key Data Insights & SQL Highlights
1. Unified Executive Financial Base
Question: What are the combined, top-level macro financial and operational KPIs for an executive briefing?
Insight: Delivers a holistic, executive summary of health across sales, customer feedback scores, and fulfillment transit speeds.

SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(net_sales),2) AS revenue,
    ROUND(SUM(profit),2) AS profit,
    ROUND(AVG(customer_rating),2) AS avg_rating,
    ROUND(AVG(delivery_days),2) AS avg_delivery_days
FROM ecommerce_sales;

2. Revenue Share by Category
Question: What is the exact percentage contribution of each product category to global platform revenue?
Insight: Electronics represents a high dependency risk for the firm, capturing a massive 53.53% of total revenue share.

SELECT
    category,
    ROUND(SUM(net_sales),2) AS revenue,
    ROUND(SUM(net_sales) * 100.0 / SUM(SUM(net_sales)) OVER (), 2) AS revenue_share_pct
FROM ecommerce_sales
GROUP BY category
ORDER BY revenue DESC;

3. Fintech Gateway Performance
Question: Which payment channels clear the largest revenue volumes and lock in the highest profit retains?
Insight: UPI dominates platform fintech channels, driving over 45% of total revenue.

SELECT
    payment_mode,
    ROUND(SUM(net_sales),2) AS revenue,
    ROUND(SUM(profit),2) AS profit
FROM ecommerce_sales
GROUP BY payment_mode
ORDER BY revenue DESC;

4. Segmenting Consumer Demographics
Question: Which specific consumer age group segments generate the highest sales volumes and order totals?
Insight: Mid-career professionals aged 45-54 and 25-34 possess the highest relative spending capacities, yielding the platform's prime revenue engines.

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

5. Logistical Partner Efficiency
Question: What is the exact turnaround efficiency (average delivery speed) across our logistics fulfillment partners?
Insight: Highlights operational shipping speeds. India Post and Ecom Express lead operational speeds, averaging 3.39 and 3.48 delivery days respectively.

SELECT
    delivery_partner,
    COUNT(*) AS orders,
    ROUND(AVG(delivery_days),2) AS avg_delivery_days
FROM ecommerce_sales
GROUP BY delivery_partner
ORDER BY avg_delivery_days;

🚀 Data-Driven Strategic Recommendations
	Gateway Optimization: Given that UPI drives more than 45% of total platform revenue, protect transaction completion rates by establishing 
solid infrastructure integrations with top-tier payment aggregators to remove checkout friction.

  Targeted Promotional Markdown Reform: Consumers aged 45–54 generate the platform's highest sales. Shift promotional budget structures away 
from blanket site campaigns and target this age cohort with tech-focused offerings.

  Fulfillment Partner SLA Realignment: Rely on the Logistical Scorecard data to re-negotiate contracts with delivery partners whose average 
fulfillment speeds fall below baseline target rates to eliminate shipping drag on consumer ratings.

  Mitigate Category Over-Dependency: Diversify the catalog portfolio to lessen the 53.53% dependency on Electronics by scaling up high-margin 
accessories and fitness lines.

✍️ Author

Devraj Singh

Aspiring Data Analyst

GitHub: (Add GitHub Profile Link)

LinkedIn: (Add LinkedIn Profile Link)
