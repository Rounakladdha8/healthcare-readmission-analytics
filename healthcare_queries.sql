-- Healthcare Readmission Analytics SQL Queries
-- Dataset: diabetic_data.csv
-- These queries assume the dataset has been loaded into a table called `patients`
-- The table structure follows the columns from the original dataset.

USE healthcare_analytics;


-- Overall 30-day readmission rate

SELECT
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_30d,
    ROUND(100.0 * SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) / COUNT(*), 2) AS readmission_rate_pct
FROM patients;


-- Readmission rate by age group

SELECT
    age,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_30d,
    ROUND(100.0 * SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) / COUNT(*), 2) AS readmission_rate_pct
FROM patients
GROUP BY age
ORDER BY age;


-- Readmission rate by previous inpatient visits

SELECT
    number_inpatient,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_30d,
    ROUND(100.0 * SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) / COUNT(*), 2) AS readmission_rate_pct
FROM patients
GROUP BY number_inpatient
ORDER BY number_inpatient;


-- Medication count segmentation

SELECT
    CASE
        WHEN num_medications BETWEEN 0 AND 9 THEN '0-9'
        WHEN num_medications BETWEEN 10 AND 19 THEN '10-19'
        WHEN num_medications BETWEEN 20 AND 29 THEN '20-29'
        ELSE '30+'
    END AS medication_bucket,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_30d,
    ROUND(100.0 * SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) / COUNT(*), 2) AS readmission_rate_pct
FROM patients
GROUP BY medication_bucket
ORDER BY medication_bucket;



-- High risk patient segments

SELECT
    age,
    CASE
        WHEN number_inpatient = 0 THEN '0'
        WHEN number_inpatient BETWEEN 1 AND 2 THEN '1-2'
        ELSE '3+'
    END AS inpatient_bucket,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_30d,
    ROUND(100.0 * SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) / COUNT(*), 2) AS readmission_rate_pct
FROM patients
GROUP BY age, inpatient_bucket
HAVING COUNT(*) >= 100
ORDER BY readmission_rate_pct DESC;