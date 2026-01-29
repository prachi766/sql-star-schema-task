

CREATE TABLE dim_customer (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(255)
);

CREATE TABLE dim_product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    sub_category VARCHAR(100)
);

CREATE TABLE dim_region (
    region_id SERIAL PRIMARY KEY,
    region VARCHAR(100)
);

CREATE TABLE dim_date (
    date_id SERIAL PRIMARY KEY,
    order_date DATE,
    year INT,
    month INT,
    day INT
);

--------------------------------------------------
-- Fact Table
--------------------------------------------------

CREATE TABLE fact_sales (
    sales_id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    region_id INT,
    date_id INT,
    sales DECIMAL(10,2),
    profit DECIMAL(10,2),

    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (region_id) REFERENCES dim_region(region_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);

--------------------------------------------------
-- Indexes for performance
--------------------------------------------------

CREATE INDEX idx_fact_customer ON fact_sales(customer_id);
CREATE INDEX idx_fact_product ON fact_sales(product_id);
CREATE INDEX idx_fact_region ON fact_sales(region_id);
CREATE INDEX idx_fact_date ON fact_sales(date_id);

--------------------------------------------------
-- Example Analytics Query (Star Schema Join)
--------------------------------------------------

SELECT
    r.region,
    p.category,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_region r ON f.region_id = r.region_id
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY r.region, p.category;
