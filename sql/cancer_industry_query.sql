/* =========================================================
   PROJECT: Cancer & Industry Pollution Analytics
   DATABASE: Cancer_Pollution_Analysis
   PURPOSE: Analyze cancer cases, industry exposure,
            distance-based risk, and pollutant severity
========================================================= */

USE Cancer_Pollution_Analysis;
GO

/* =========================
   1. DATA VALIDATION
========================= */
SELECT 'Patients_Industries' AS TableName, COUNT(*) AS Rows FROM Patients_Industries
UNION ALL
SELECT 'Industries', COUNT(*) FROM Industries
UNION ALL
SELECT 'Pollutants', COUNT(*) FROM Pollutants;
GO

/* =========================
   2. BASIC EXPLORATION
========================= */

-- Distinct patient districts
SELECT DISTINCT District_x AS Patient_District
FROM Patients_Industries
ORDER BY Patient_District;
GO

-- Cancer type distribution
SELECT Cancer_Type, COUNT(*) AS Total_Cases
FROM Patients_Industries
GROUP BY Cancer_Type
ORDER BY Total_Cases DESC;
GO

/* =========================
   3. CORE ANALYSIS
========================= */

-- Cancer cases by district
SELECT 
    District_x AS District,
    COUNT(*) AS Cancer_Cases
FROM Patients_Industries
GROUP BY District_x
ORDER BY Cancer_Cases DESC;
GO

-- Cancer cases by village
SELECT 
    Village_x AS Village,
    COUNT(*) AS Cancer_Cases
FROM Patients_Industries
GROUP BY Village_x
ORDER BY Cancer_Cases DESC;
GO

/* =========================
   4. DISTANCE / EXPOSURE ANALYSIS
========================= */

-- Cancer cases by exposure level (distance from industry)
SELECT
    CASE
        WHEN Distance_km < 5 THEN '< 5 KM (High Exposure)'
        WHEN Distance_km BETWEEN 5 AND 20 THEN '5–20 KM (Medium Exposure)'
        ELSE '> 20 KM (Low Exposure)'
    END AS Exposure_Level,
    COUNT(*) AS Cancer_Cases
FROM Patients_Industries
GROUP BY
    CASE
        WHEN Distance_km < 5 THEN '< 5 KM (High Exposure)'
        WHEN Distance_km BETWEEN 5 AND 20 THEN '5–20 KM (Medium Exposure)'
        ELSE '> 20 KM (Low Exposure)'
    END
ORDER BY Cancer_Cases DESC;
GO

/* =========================
   5. INDUSTRY IMPACT ANALYSIS
========================= */

-- Cancer cases by industry type
SELECT 
    Industry_Type,
    COUNT(*) AS Cancer_Cases
FROM Patients_Industries
GROUP BY Industry_Type
ORDER BY Cancer_Cases DESC;
GO

-- Top industries linked to cancer cases
SELECT 
    Industry_Name,
    COUNT(*) AS Linked_Cancer_Patients
FROM Patients_Industries
GROUP BY Industry_Name
ORDER BY Linked_Cancer_Patients DESC;
GO

-- MPCB category vs cancer cases
SELECT 
    MPCB_Category,
    COUNT(*) AS Cancer_Cases
FROM Patients_Industries
GROUP BY MPCB_Category
ORDER BY Cancer_Cases DESC;
GO

/* =========================
   6. POLLUTANT RISK ANALYSIS
========================= */

-- Average pollutant risk by district
SELECT 
    District_x AS District,
    AVG(Avg_Pollutant_Risk) AS Avg_Pollution_Risk,
    COUNT(*) AS Cancer_Cases
FROM Patients_Industries
GROUP BY District_x
ORDER BY Avg_Pollution_Risk DESC;
GO

-- High risk cancer cases (risk score >= 2)
SELECT 
    District_x AS District,
    COUNT(*) AS High_Risk_Cases
FROM Patients_Industries
WHERE Avg_Pollutant_Risk >= 2
GROUP BY District_x
ORDER BY High_Risk_Cases DESC;
GO

/* =========================
   7. TIME SERIES ANALYSIS
========================= */

-- Year-wise cancer trend
SELECT 
    Diagnosis_Year,
    COUNT(*) AS Cancer_Cases
FROM Patients_Industries
GROUP BY Diagnosis_Year
ORDER BY Diagnosis_Year;
GO

/* =========================
   8. POWER BI READY VIEW
========================= */

CREATE OR ALTER VIEW vw_Cancer_Analytics_Dashboard AS
SELECT
    Patient_ID,
    Name,
    Age,
    Sex,
    Village_x AS Patient_Village,
    District_x AS Patient_District,
    Cancer_Type,
    Diagnosis_Year,
    Distance_km,
    Industry_ID,
    Industry_Name,
    Industry_Type,
    Village_y AS Industry_Village,
    District_y AS Industry_District,
    Industry_Lat,
    Industry_Long,
    MPCB_Category,
    Avg_Pollutant_Risk
FROM Patients_Industries;
GO

-- Sample check
SELECT TOP 10 * FROM vw_Cancer_Analytics_Dashboard;
GO

