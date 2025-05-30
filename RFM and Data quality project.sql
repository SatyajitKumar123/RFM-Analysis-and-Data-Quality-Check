-- sample customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    total_purchases NUMERIC(10,2),
    last_purchase_date DATE
);

INSERT INTO customers (name, total_purchases, last_purchase_date) VALUES
('Alice Johnson', 1250.50, '2023-05-15'),
('Bob Smith', 850.00, '2023-06-20'),
('Carol Williams', 4200.75, '2023-04-10'),
('David Brown', 320.25, '2022-12-05'),
('Eve Davis', 1500.00, '2023-07-01');

-- RFM (Recency, Frequency, Monetary) Analysis
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




-- Sample products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10,2),
    stock_quantity INTEGER,
    category VARCHAR(50)
);

INSERT INTO products (product_name, price, stock_quantity, category) VALUES
('Laptop', 999.99, 25, 'Electronics'),
('Smartphone', NULL, 40, 'Electronics'),
('Desk Chair', 149.50, 0, 'Furniture'),
('', 19.99, 100, 'Home Goods'),
('Headphones', 79.99, -5, 'Electronics');

-- Data quality check
SELECT 
    product_id,
    product_name,
    price,
    stock_quantity,
    category,
    CASE 
        WHEN product_name IS NULL OR product_name = '' THEN 'Missing Name'
        WHEN price IS NULL THEN 'Missing Price'
        WHEN price <= 0 THEN 'Invalid Price'
        WHEN stock_quantity < 0 THEN 'Negative Inventory'
        ELSE 'OK'
    END AS data_quality_status
FROM products;