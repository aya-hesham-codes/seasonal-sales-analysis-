use sales_analysis;
SELECT
    Year,
    CASE Season
        WHEN 'Spring' THEN 'Before Season'
        WHEN 'Summer' THEN 'During Season'
        WHEN 'Fall'   THEN 'After Season'
        ELSE 'Off-Season'
    END AS SeasonPeriod,
    ROUND(SUM(NetAmount), 2)                          AS TotalSales,
    COUNT(DISTINCT CustomerID)                        AS NumberOfCustomers,
    COUNT(DISTINCT SaleID)                             AS NumberOfOrders,
    ROUND(SUM(NetAmount) / COUNT(DISTINCT SaleID), 2) AS AOV
FROM sales
GROUP BY Year, SeasonPeriod
ORDER BY Year,
    CASE SeasonPeriod
        WHEN 'Before Season' THEN 1
        WHEN 'During Season' THEN 2
        WHEN 'After Season'  THEN 3
        ELSE 4
    END;

-- Compare Before → During and During → After

use sales_analysis;
SELECT
    Year,

    ROUND(
        (DuringSales - BeforeSales)
        / BeforeSales * 100,
        2
    ) AS Sales_Change_Before_to_During,

    ROUND(
        (AfterSales - DuringSales)
        / DuringSales * 100,
        2
    ) AS Sales_Change_During_to_After,

    ROUND(
        (DuringCustomers - BeforeCustomers)
        / BeforeCustomers * 100,
        2
    ) AS Customers_Change_Before_to_During,

    ROUND(
        (AfterCustomers - DuringCustomers)
        / DuringCustomers * 100,
        2
    ) AS Customers_Change_During_to_After,

    ROUND(
        (DuringOrders - BeforeOrders)
        / BeforeOrders * 100,
        2
    ) AS Orders_Change_Before_to_During,

    ROUND(
        (AfterOrders - DuringOrders)
        / DuringOrders * 100,
        2
    ) AS Orders_Change_During_to_After,

    ROUND(
        (DuringAOV - BeforeAOV)
        / BeforeAOV * 100,
        2
    ) AS AOV_Change_Before_to_During,

    ROUND(
        (AfterAOV - DuringAOV)
        / DuringAOV * 100,
        2
    ) AS AOV_Change_During_to_After

FROM
(
    SELECT
        Year,

        SUM(CASE
            WHEN Season = 'Spring'
            THEN NetAmount ELSE 0
        END) AS BeforeSales,

        SUM(CASE
            WHEN Season = 'Summer'
            THEN NetAmount ELSE 0
        END) AS DuringSales,

        SUM(CASE
            WHEN Season = 'Fall'
            THEN NetAmount ELSE 0
        END) AS AfterSales,

        COUNT(DISTINCT CASE
            WHEN Season = 'Spring'
            THEN CustomerID
        END) AS BeforeCustomers,

        COUNT(DISTINCT CASE
            WHEN Season = 'Summer'
            THEN CustomerID
        END) AS DuringCustomers,

        COUNT(DISTINCT CASE
            WHEN Season = 'Fall'
            THEN CustomerID
        END) AS AfterCustomers,

        COUNT(DISTINCT CASE
            WHEN Season = 'Spring'
            THEN SaleID
        END) AS BeforeOrders,

        COUNT(DISTINCT CASE
            WHEN Season = 'Summer'
            THEN SaleID
        END) AS DuringOrders,

        COUNT(DISTINCT CASE
            WHEN Season = 'Fall'
            THEN SaleID
        END) AS AfterOrders,

        SUM(CASE
            WHEN Season = 'Spring'
            THEN NetAmount ELSE 0
        END)
        /
        COUNT(DISTINCT CASE
            WHEN Season = 'Spring'
            THEN SaleID
        END) AS BeforeAOV,

        SUM(CASE
            WHEN Season = 'Summer'
            THEN NetAmount ELSE 0
        END)
        /
        COUNT(DISTINCT CASE
            WHEN Season = 'Summer'
            THEN SaleID
        END) AS DuringAOV,

        SUM(CASE
            WHEN Season = 'Fall'
            THEN NetAmount ELSE 0
        END)
        /
        COUNT(DISTINCT CASE
            WHEN Season = 'Fall'
            THEN SaleID
        END) AS AfterAOV

    FROM sales
    GROUP BY Year
) AS SeasonData

ORDER BY Year;
