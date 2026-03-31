
# 📊 Gross Sales Reporting with SQL  
---

## 🚀 Overview
This project showcases how SQL can be leveraged to build a **scalable reporting pipeline** for analyzing for analyzing gross sales across **retail customers**.  

It demonstrates:
- Customer identification from dimension tables  
- Fiscal year alignment using custom SQL functions  
- Product and pricing integration through joins  
- Monthly gross sales aggregation  
- Reusable stored procedures for automation  

The goal: **transform raw transactional data into actionable business insights**.

---

## 🧩 Problem Statement
Retail businesses need **accurate monthly sales reporting** aligned with fiscal years. Manual reporting is slow and error‑prone.  

This project solves that by:
- Automating fiscal year calculations  
- Standardizing reporting across customers  
- Providing reusable stored procedures for scalability  

---

## 📂 Project Workflow

### 1️⃣ Customer Identification
```sql
SELECT * 
FROM dim_customer
WHERE customer LIKE "%croma%" AND market = "India";
```
✔ Retrieves **customer code**.

---

### 2️⃣ Fiscal Year Function
```sql
CREATE FUNCTION get_fiscal_year(calendar_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fiscal_year INT;
    SET fiscal_year = YEAR(DATE_ADD(calendar_date, INTERVAL 4 MONTH));
    RETURN fiscal_year;
END;
```
✔ Converts calendar dates into **fiscal years**.

---

### 3️⃣ Sales Transactions
```sql
SELECT * 
FROM fact_sales_monthly
WHERE customer_code = 90002002 
  AND get_fiscal_year(date) = 2021
ORDER BY date ASC;
```
✔ Pulls **sales data for fiscal year 2021**.

---

### 4️⃣ Product Joins
```sql
SELECT s.date, s.product_code, p.product, p.variant, s.sold_quantity
FROM fact_sales_monthly s
JOIN dim_product p ON s.product_code = p.product_code
WHERE customer_code = 90002002 
  AND get_fiscal_year(date) = 2021
ORDER BY date ASC;
```
✔ Adds **product details** to transactions.

---

### 5️⃣ Gross Price Integration
```sql
SELECT s.date, s.product_code, p.product, p.variant, 
       s.sold_quantity, g.gross_price,
       ROUND(s.sold_quantity * g.gross_price, 2) AS gross_price_total
FROM fact_sales_monthly s
JOIN dim_product p ON s.product_code = p.product_code
JOIN fact_gross_price g 
     ON g.fiscal_year = get_fiscal_year(s.date)
    AND g.product_code = s.product_code
WHERE customer_code = 90002002 
  AND get_fiscal_year(s.date) = 2021;
```
✔ Calculates **gross sales revenue per product**.

<img width="1014" height="389" alt="Image" src="https://github.com/user-attachments/assets/d3ee1c51-e8b2-4dec-ac34-832c94e59d9c" />

---

### 6️⃣ Monthly Gross Sales Report
```sql
SELECT s.date, 
       SUM(ROUND(s.sold_quantity * g.gross_price, 2)) AS monthly_sales
FROM fact_sales_monthly s
JOIN fact_gross_price g 
     ON g.fiscal_year = get_fiscal_year(s.date) 
    AND g.product_code = s.product_code
WHERE customer_code = 90002002
GROUP BY s.date;
```
✔ Aggregates **monthly sales totals**.

<img width="268" height="464" alt="Image" src="https://github.com/user-attachments/assets/4b774cad-203d-473f-85d8-ce8c7390682f" />

---

### 7️⃣ Stored Procedure for Reusability
```sql
CREATE PROCEDURE get_monthly_gross_sales_for_customer(in_customer_codes TEXT)
BEGIN
    SELECT s.date, 
           SUM(ROUND(s.sold_quantity * g.gross_price, 2)) AS monthly_sales
    FROM fact_sales_monthly s
    JOIN fact_gross_price g 
         ON g.fiscal_year = get_fiscal_year(s.date)
        AND g.product_code = s.product_code
    WHERE FIND_IN_SET(s.customer_code, in_customer_codes) > 0
    GROUP BY s.date
    ORDER BY s.date DESC;
END;
```
✔ Generates **monthly gross sales reports for any customer**.

---

## 🏢 Business Impact
- 📈 **Automated reporting** across multiple customers  
- 🗓️ **Accurate fiscal year alignment**  
- 🔄 **Reusable stored procedures** for scalability  
- 💡 **Supports decision-making** with monthly revenue insights  


---

## 🛠️ Skills Highlighted
- SQL Functions  
- Joins & Aggregations  
- Stored Procedures  
- Business Reporting  
- Data Analysis  


## 🎯 Why This Project Matters
This project bridges **technical SQL expertise** with **real business needs**. It demonstrates how to transform raw transactional data into **actionable insights** — exactly the kind of work analysts and data engineers deliver in industry.

