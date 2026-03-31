
# ⚙️ Stored Procedures for Business Reporting

## 1️⃣ Procedure: `get_monthly_gross_sales_for_customer`

### Purpose
Generates a **monthly gross sales report** for one or more customers. This procedure makes reporting reusable and scalable across different customer codes.

### Code
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

### Example Usage
```sql
CALL get_monthly_gross_sales_for_customer('90002002,90002003');
```

➡ Returns monthly sales totals for the specified customer codes.

---

## 2️⃣ Procedure: `get_market_badge`

### Purpose
Assigns a **performance badge (Gold/Silver)** to a market based on total sold quantity in a given fiscal year. This helps classify markets by sales performance.

### Code
```sql
CREATE PROCEDURE get_market_badge(
    IN in_market VARCHAR(45),
    IN in_fiscal_year YEAR,
    OUT out_level VARCHAR(45)
)
BEGIN
    DECLARE qty INT DEFAULT 0;

    -- Default market is India
    IF in_market = "" THEN
        SET in_market = "India";
    END IF;

    -- Retrieve total sold quantity for a given market in a given year
    SELECT SUM(s.sold_quantity) INTO qty
    FROM fact_sales_monthly s
    JOIN dim_customer c ON s.customer_code = c.customer_code
    WHERE get_fiscal_year(s.date) = in_fiscal_year
      AND c.market = in_market;

    -- Determine Gold vs Silver status
    IF qty > 5000000 THEN
        SET out_level = 'Gold';
    ELSE
        SET out_level = 'Silver';
    END IF;
END;
```

### Example Usage
```sql
CALL get_market_badge('India', 2021, @badge);
SELECT @badge;
```

➡ Returns **Gold** if the market sold more than 5,000,000 units in the fiscal year, otherwise **Silver**.

---

## 🏢 Business Impact
- **Reusable reporting logic**: Procedures simplify repeated queries.  
- **Scalability**: Works across multiple customers and markets.  
- **Performance classification**: Market badge helps in quick benchmarking.  
- **Decision support**: Enables managers to identify strong vs. weak markets.  

---

## 🛠️ Skills Highlighted
- SQL Stored Procedures  
- Conditional Logic (`IF/ELSE`)  
- Aggregations (`SUM`)  
- Parameterized Queries  
- Business Reporting Automation  

