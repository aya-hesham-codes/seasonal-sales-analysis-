CREATE DATABASE IF NOT EXISTS sales_analysis;
CREATE TABLE sales (
    SaleID VARCHAR(20),
    Date DATE,
    Year INT,
    Month INT,
    Season VARCHAR(10),
    CustomerID VARCHAR(20),
    ProductID VARCHAR(20),
    ProductName VARCHAR(100),
    Category VARCHAR(30),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    DiscountPercent DECIMAL(4,2),
    GrossAmount DECIMAL(10,2),
    NetAmount DECIMAL(10,2),
    Channel VARCHAR(20)
);


use sales_analysis;
LOAD DATA LOCAL INFILE 'C:/Users/NEXT/Desktop/PythonProject1/sales_data_cleaned.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
show variables like 'local_infile';
select @@local_infile;