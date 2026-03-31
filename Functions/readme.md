
# 📂 SQL Functions

This folder contains reusable **SQL functions** designed to support business reporting and analytics. They encapsulate logic for fiscal year alignment, making queries cleaner, more consistent, and easier to maintain.

---

## 🔧 Function: `get_fiscal_year`

### Purpose
Converts a calendar date into the corresponding **fiscal year** (assuming fiscal year starts in April).  
This function ensures that all reporting aligns with business fiscal years rather than calendar years.

### Code
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

### Example Usage
```sql
SELECT get_fiscal_year('2021-03-31'); 
-- Returns 2021

SELECT get_fiscal_year('2021-04-01'); 
-- Returns 2022
```

---

## 🏢 Business Impact
- 📈 Ensures **accurate fiscal year alignment** across reports  
- 🔄 Simplifies queries by replacing repeated fiscal year logic  
- 💡 Improves readability and maintainability of SQL scripts  

---

## 🛠️ Skills Highlighted
- SQL Functions  
- Date Manipulation (`DATE_ADD`)  
- Business Reporting Automation  


