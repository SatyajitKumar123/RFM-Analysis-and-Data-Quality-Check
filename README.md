# RFM Analysis and Data Quality Check

This repository contains PostgreSQL scripts for performing **RFM (Recency, Frequency, Monetary) Analysis** and **Data Quality Checks** on sample customer and product datasets. The scripts use CASE statements to categorize customers based on their purchasing behavior and to identify data quality issues in the product dataset.

## Table of Contents
- [Overview](#overview)
- [RFM Analysis](#rfm-analysis)
- [Data Quality Check](#data-quality-check)

## Overview
This project demonstrates how to:
1. Perform **RFM Analysis** to segment customers based on:
   - **Recency**: How recently a customer made a purchase.
   - **Frequency**: How often a customer makes purchases (approximated using total_purchases).
   - **Monetary**: The total monetary value of purchases.
2. Conduct a **Data Quality Check** to identify issues in the product dataset, such as missing names, invalid prices, or negative inventory.

The scripts are written in PostgreSQL and use CASE statements for dynamic categorization.

## RFM Analysis
The `rfm_analysis.sql` script segments customers based on their purchase behavior:
- **Recency Score**: Based on the last purchase date.
  - High: Within the last 3 months.
  - Medium: Within the last 6 months.
  - Low: Older than 6 months.
- **Monetary Score**: Based on total purchase amount.
  - High: > $3,000.
  - Medium: > $1,000.
  - Low: ≤ $1,000.
- **Customer Segment**: Combines recency and monetary to classify customers as:
  - Champion: Recent and high-value customers.
  - Loyal: Moderately recent and valuable customers.
  - At Risk: Customers who haven’t purchased in over a year.
  - Needs Attention: Others requiring engagement.

**Query Example:**
```sql
SELECT 
    customer_id,
    name,
    total_purchases,
    last_purchase_date,
    CASE 
        WHEN last_purchase_date > CURRENT_DATE - INTERVAL '3 months' THEN 'High'
        WHEN last_purchase_date > CURRENT_DATE - INTERVAL '6 months' THEN 'Medium'
        ELSE 'Low'
    END AS recency_score,
    CASE 
        WHEN total_purchases > 3000 THEN 'High'
        WHEN total_purchases > 1000 THEN 'Medium'
        ELSE 'Low'
    END AS monetary_score,
    CASE 
        WHEN last_purchase_date > CURRENT_DATE - INTERVAL '3 months' AND total_purchases > 3000 THEN 'Champion'
        WHEN last_purchase_date > CURRENT_DATE - INTERVAL '6 months' AND total_purchases > 1000 THEN 'Loyal'
        WHEN last_purchase_date < CURRENT_DATE - INTERVAL '1 year' THEN 'At Risk'
        ELSE 'Needs Attention'
    END AS customer_segment
FROM customers;
