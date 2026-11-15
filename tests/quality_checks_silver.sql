-- Check For Nulls or Duplicates in Primary Key
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 AND prd_id IS NOT NULL

-- Check for un-wanter spaces
SELECT 
prd_nm
FROM 
silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Data Standardization & Consistency
SELECT Distinct cst_gndr FROM silver.crm_cust_info

-- Check for NULL or Negative Numbers
SELECT prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Check the Date column to validate if the value is less then equal to 0 or Len is not 8 digits
SELECT
NULLIF(sls_order_dt, 0) as sls_order_dt
FROM bronze.crm_sales_details
where sls_order_dt <= 0 OR LEN(sls_order_dt) != 8

-- Check order_date should be less then from due_date or ship_order
SELECT * FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt

-- Check data consistency: between sales, quantity and price
-->> sales = quantity * price
-->> values must not be null, zero, or negative number.
SELECT DISTINCT
sls_quantity,
sls_sales old_sls_sales,
sls_price old_sls_price,
CASE 
	WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
		THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
	END AS sls_sales,
CASE 
	WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price
	END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_price * sls_quantity 
OR sls_sales = NULL OR sls_quantity = NULL  OR sls_price = NULL 
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price
