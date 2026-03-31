-- a. first grab customer codes for Croma india

select * from dim_customer
where customer like "%croma%" and market = "India";

-- b.Get all the sales transaction data from fact_sales_monthly table for that customer(croma: 90002002) in the fiscal_year 2021

select * from fact_sales_monthly
	WHERE 
            customer_code=90002002 AND
            YEAR(DATE_ADD(date, INTERVAL 4 MONTH))=2021 
	ORDER BY date asc;
    
-- c. create a function 'get_fiscal_year' to get fiscal year by passing the date

DELIMITER //

CREATE FUNCTION get_fiscal_year(calendar_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fiscal_year INT;
    SET fiscal_year = YEAR(DATE_ADD(calendar_date, INTERVAL 4 MONTH));
    RETURN fiscal_year;
END //

DELIMITER ;

-- d. Replacing the function created in the step:b

SELECT * FROM fact_sales_monthly 
WHERE 
	 customer_code=90002002 AND
	 get_fiscal_year(date)=2021 
ORDER BY date asc;

###  Gross Sales Report: Monthly Product Transactions

-- a.Perform joins to pull product information

SELECT s.date, s.product_code, p.product, p.variant, s.sold_quantity
FROM fact_sales_monthly s 
join dim_product p
on s.product_code=p.product_code
WHERE 
	 customer_code=90002002 AND
	 get_fiscal_year(date)=2021 
ORDER BY date asc;

-- b.Performing join with 'fact_gross_price' table with the above query and generating required fields

SELECT 
    	    s.date, 
            s.product_code, 
            p.product, 
            p.variant, 
            s.sold_quantity, 
            g.gross_price,
            ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total
	FROM fact_sales_monthly s
	JOIN dim_product p
            ON s.product_code=p.product_code
	JOIN fact_gross_price g
            ON g.fiscal_year=get_fiscal_year(s.date)
    	AND g.product_code=s.product_code
	WHERE 
    	    customer_code=90002002 AND 
            get_fiscal_year(s.date)=2021 ;

### Gross Sales Report: Total Sales Amount

-- Generate monthly gross sales report for Croma India for all the years
	SELECT 
            s.date, 
    	    SUM(ROUND(s.sold_quantity*g.gross_price,2)) as monthly_sales
	FROM fact_sales_monthly s
	JOIN fact_gross_price g
        ON g.fiscal_year=get_fiscal_year(s.date) AND g.product_code=s.product_code
	WHERE 
             customer_code=90002002
	GROUP BY date;

### Stored Procedures: Monthly Gross Sales Report

-- Generate monthly gross sales report for any customer using stored procedure

DELIMITER $$

CREATE PROCEDURE `get_monthly_gross_sales_for_customer`(
    in_customer_codes TEXT
)
BEGIN
    SELECT 
        s.date, 
        SUM(ROUND(s.sold_quantity*g.gross_price,2)) AS monthly_sales
    FROM fact_sales_monthly s
    JOIN fact_gross_price g
        ON g.fiscal_year = get_fiscal_year(s.date)
        AND g.product_code = s.product_code
    WHERE 
        FIND_IN_SET(s.customer_code, in_customer_codes) > 0
    GROUP BY s.date
    ORDER BY s.date DESC;
END$$

DELIMITER ;



    
