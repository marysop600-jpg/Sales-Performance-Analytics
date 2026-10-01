-- Create database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ECommerce_DB')
    CREATE DATABASE ECommerce_DB;
GO

USE ECommerce_DB;
GO

-- Cleanup existing tables
IF OBJECT_ID('dbo.Fact_Sales', 'U') IS NOT NULL DROP TABLE dbo.Fact_Sales;
IF OBJECT_ID('dbo.Dim_Customers', 'U') IS NOT NULL DROP TABLE dbo.Dim_Customers;
IF OBJECT_ID('dbo.Dim_Products', 'U') IS NOT NULL DROP TABLE dbo.Dim_Products;
GO

-- 1. Customers Table
CREATE TABLE dbo.Dim_Customers (
    customer_id   INT PRIMARY KEY,
    customer_name NVARCHAR(100) NOT NULL,
    city          NVARCHAR(50) NOT NULL,
    join_date     DATE NOT NULL
);

-- 2. Products Table
CREATE TABLE dbo.Dim_Products (
    product_id   INT PRIMARY KEY,
    product_name NVARCHAR(100) NOT NULL,
    category     NVARCHAR(50) NOT NULL,
    unit_price   DECIMAL(10,2) NOT NULL
);

-- 3. Sales Fact Table
CREATE TABLE dbo.Fact_Sales (
    order_id     INT PRIMARY KEY,
    customer_id  INT NOT NULL,
    product_id   INT NOT NULL,
    order_date   DATE NOT NULL,
    quantity     INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES dbo.Dim_Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES dbo.Dim_Products(product_id)
);
GO

-- Insert Customers
INSERT INTO dbo.Dim_Customers VALUES 
(1, N'أحمد الشمري', N'عمان', '2025-01-15'),
(2, N'سارة النابلسي', N'إربد', '2025-02-10'),
(3, N'محمود الزعبي', N'الزرقاء', '2025-03-01'),
(4, N'رانيا الكردي', N'عمان', '2025-03-20'),
(5, N'خالد حداد', N'العقبة', '2025-04-05');

-- Insert Products
INSERT INTO dbo.Dim_Products VALUES 
(101, N'سماعات لاسلكية', N'إلكترونيات', 45.00),
(102, N'شاشة حماية آيفون', N'إكسسوارات', 10.00),
(103, N'ساعة ذكية', N'إلكترونيات', 120.00),
(104, N'حقيبة ظهر للابتوب', N'حقائب', 35.00),
(105, N'شاحن سريع 65 واط', N'إكسسوارات', 25.00);

-- Insert Orders
INSERT INTO dbo.Fact_Sales VALUES 
(5001, 1, 101, '2026-01-10', 2, 90.00),
(5002, 2, 103, '2026-01-12', 1, 120.00),
(5003, 3, 102, '2026-01-15', 3, 30.00),
(5004, 1, 105, '2026-02-01', 1, 25.00),
(5005, 4, 104, '2026-02-05', 2, 70.00),
(5006, 5, 101, '2026-02-10', 1, 45.00),
(5007, 2, 105, '2026-02-18', 2, 50.00),
(5008, 3, 103, '2026-03-02', 1, 120.00),
(5009, 1, 102, '2026-03-11', 5, 50.00),
(5010, 4, 101, '2026-03-22', 1, 45.00);
GO

-- Check data
SELECT * FROM dbo.Fact_Sales;