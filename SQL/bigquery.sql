WITH sales_data AS (
  SELECT *,
         -- Global Z-score calculations
         AVG(SAFE_CAST(`SALE PRICE` AS NUMERIC)) OVER () AS mean_sale_price,
         STDDEV(SAFE_CAST(`SALE PRICE` AS NUMERIC)) OVER () AS stddev_sale_price,
         
         -- Neighborhood + Building Class Z-score calculations
         AVG(SAFE_CAST(`SALE PRICE` AS NUMERIC)) OVER (PARTITION BY NEIGHBORHOOD, `BUILDING CLASS AT PRESENT`) AS mean_sale_price_neighborhood,
         STDDEV(SAFE_CAST(`SALE PRICE` AS NUMERIC)) OVER (PARTITION BY NEIGHBORHOOD, `BUILDING CLASS AT PRESENT`) AS stddev_sale_price_neighborhood,

         -- Square feet per unit calculation, handle division by 0 or NULL
         CASE 
           WHEN `TOTAL UNITS` > 0 THEN SAFE_CAST(`GROSS SQUARE FEET` AS NUMERIC) / `TOTAL UNITS`
           ELSE NULL
         END AS square_ft_per_unit,

         -- Price per unit calculation, handle division by 0 or NULL
         CASE 
           WHEN `TOTAL UNITS` > 0 THEN SAFE_CAST(`SALE PRICE` AS NUMERIC) / `TOTAL UNITS`
           ELSE NULL
         END AS price_per_unit
         
  FROM `nyc-rolling-sales-435007.dataset.nyc-rolling-sales`
  -- Filter rows with valid SALE PRICE values (numeric values only)
  WHERE SAFE_CAST(`SALE PRICE` AS NUMERIC) IS NOT NULL
)
SELECT *,
       -- Global Z-score, handling division by zero using CASE
       CASE 
         WHEN stddev_sale_price > 0 THEN (SAFE_CAST(`SALE PRICE` AS NUMERIC) - mean_sale_price) / stddev_sale_price
         ELSE NULL
       END AS sale_price_zscore,
       
       -- Neighborhood + Building Class Z-score, handling division by zero using CASE
       CASE 
         WHEN stddev_sale_price_neighborhood > 0 THEN (SAFE_CAST(`SALE PRICE` AS NUMERIC) - mean_sale_price_neighborhood) / stddev_sale_price_neighborhood
         ELSE NULL
       END AS sale_price_zscore_neighborhood
FROM sales_data;