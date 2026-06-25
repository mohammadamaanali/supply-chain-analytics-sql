-- create a database named as project_dataCo
CREATE DATABASE IF NOT EXISTS project_dataCo;
SHOW DATABASES;

-- After this i created a special connection for the project with project_dataCo database so that bydefault this database is used.

-- Create the required tables structure
--1.dim_customers
CREATE TABLE dim_customers (
    customer_id INT PRIMARY KEY,
    customer_fname VARCHAR(30),
    customer_lname VARCHAR(30),
    customer_email VARCHAR(40),
    customer_segment VARCHAR(50),
    customer_city VARCHAR(50),
    customer_state VARCHAR(50),
    customer_country VARCHAR(50),
    customer_zipcode VARCHAR(20),
    customer_street VARCHAR(60)
);

--2. dim_departments
CREATE TABLE dim_departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(45)
);

--3. dim_categories
CREATE TABLE dim_categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50),
    department_id INT,

    FOREIGN KEY (department_id) REFERENCES dim_departments(department_id)
);

--4.dim_products
CREATE TABLE dim_products (
    product_card_id INT PRIMARY KEY,
    product_name VARCHAR(200),
    product_price DECIMAL(10,2),
    product_status BOOLEAN,
    category_id INT,

    FOREIGN KEY (category_id) REFERENCES dim_categories(category_id)
);

--5.dim_geography
CREATE TABLE dim_geography (
    geo_id INT PRIMARY KEY,
    market VARCHAR(30),
    order_region VARCHAR(30),
    order_country VARCHAR(30),
    order_state VARCHAR(50),
    order_city VARCHAR(50),
    order_zipcode VARCHAR(20),
    latitude DECIMAL(11,8),
    longitude DECIMAL(11,8)
);

--6. fact_shipping
CREATE TABLE fact_shipping (
    shipping_key INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT ,
    shipping_date DATETIME,
    days_for_shipping_real INT,
    days_for_shipping_scheduled INT,
    delivery_status VARCHAR(30),
    late_delivery_risk BOOLEAN,
    shipping_mode VARCHAR(30)
);


--7. fact_orders (Main fact table)
CREATE TABLE fact_orders (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    customer_id INT,
    product_card_id INT,
    geo_id INT,
    order_date DATETIME,
    order_item_quantity INT,
    sales DECIMAL(10,2),
    order_item_total DECIMAL(10,2),
    benefit_per_order DECIMAL(10,2),
    order_profit_per_order DECIMAL(10,2),
    order_item_profit_ratio DECIMAL(8,2),
    order_status VARCHAR(30),

    FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id),

    FOREIGN KEY (product_card_id) REFERENCES dim_products(product_card_id),

    FOREIGN KEY (geo_id) REFERENCES dim_geography(geo_id)
);

--check all the tables
SHOW TABLES;


--Load the data in the tables
-- mysql --local-infile=1 -u root -p project_dataco   (Use these at cmd and then run the below)

--1. dim_customers
LOAD DATA LOCAL INFILE 'C:\\Users\\Amaan\\Desktop\\supply-chain-analytics-sql\\data\\processed\\dim_customers.csv'
INTO TABLE dim_customers
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    customer_id,
    customer_fname,
    customer_lname,
    customer_email,
    customer_segment,
    customer_city,
    customer_state,
    customer_country,
    customer_zipcode,
    customer_street
);

--2. dim_departments
LOAD DATA LOCAL INFILE 'C:\\Users\\Amaan\\Desktop\\supply-chain-analytics-sql\\data\\processed\\dim_departments.csv'
INTO TABLE dim_departments
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    department_id,
    department_name
);

--3. dim_categories
LOAD DATA LOCAL INFILE 'C:\\Users\\Amaan\\Desktop\\supply-chain-analytics-sql\\data\\processed\\dim_categories.csv'
INTO TABLE dim_categories
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    category_id,
    category_name,
    department_id
);

--4. dim_products
LOAD DATA LOCAL INFILE 'C:\\Users\\Amaan\\Desktop\\supply-chain-analytics-sql\\data\\processed\\dim_products.csv'
INTO TABLE dim_products
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(
    product_card_id,
    product_name,
    product_price,
    product_status,
    category_id
);
SELECT * 
FROM dim_products;

--5. dim_geography
LOAD DATA LOCAL INFILE 'C:\\Users\\Amaan\\Desktop\\supply-chain-analytics-sql\\data\\processed\\dim_geography.csv'
INTO TABLE dim_geography
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(
    geo_id,
    market,
    order_region,
    order_country,
    order_state,
    order_city,
    order_zipcode,
    latitude,
    longitude
);

--6. fact_shipping
LOAD DATA LOCAL INFILE 'C:\\Users\\Amaan\\Desktop\\supply-chain-analytics-sql\\data\\processed\\fact_shipping.csv'
INTO TABLE fact_shipping
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    order_id,
    @raw_shipping_date,
    days_for_shipping_real,
    days_for_shipping_scheduled,
    delivery_status,
    late_delivery_risk,
    shipping_mode
)
SET shipping_date = STR_TO_DATE(TRIM(@raw_shipping_date), '%c/%e/%Y %H:%i');

--7. fact_orders
LOAD DATA LOCAL INFILE 'C:\\Users\\Amaan\\Desktop\\supply-chain-analytics-sql\\data\\processed\\fact_orders.csv'
INTO TABLE fact_orders
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(
    order_item_id,
    order_id,
    customer_id,
    product_card_id,
    geo_id,
    @raw_order_date,
    order_item_quantity,
    sales,
    order_item_total,
    benefit_per_order,
    order_profit_per_order,
    order_item_profit_ratio,
    order_status
)
SET order_date = STR_TO_DATE(TRIM(@raw_order_date), '%c/%e/%Y %H:%i');
