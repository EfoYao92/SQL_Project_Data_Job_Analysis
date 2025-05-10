SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date :: DATE AS date
FROM 
    job_postings_fact
LIMIT 5;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date
FROM 
    job_postings_fact
LIMIT 5;


SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM 
    job_postings_fact
LIMIT 5;

-- EXTRACT

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST',
    EXTRACT(MONTH FROM job_posted_date) AS month,
    EXTRACT(YEAR FROM job_posted_date) AS year
FROM 
    job_postings_fact
LIMIT 5;



SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    month
ORDER BY 
    job_posted_count DESC;


/**
Practice Problem 1
Write a query to find the average salary of both yearly(salary_year_avg) and hourly
(salary_hour_avg) for job postings that were posted after June 1, 2023. Group the results by
Job schedule type. 
**/

SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS yearly,
    AVG(salary_hour_avg) AS hourly
FROM job_postings_fact
WHERE job_posted_date < '2023-06-01'
GROUP BY job_schedule_type;

/**
Practice Problem 2
Write a query to count the number of job postings for each month in 2023, adjusting the 
(job_posted-date) to be in 'America/New_York' time zone before extracting (hint) the month.
Assume the job_posted_date is stored in 'UTC'. Group by and order by the month.
**/


SELECT
    COUNT(job_id),
--    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
GROUP BY 
    month
ORDER BY
    month;

/**
Practice Problem 3
Write a query to find companies (include company name) that have posted job offering health
insurance, where these postings were made in the second quarter of 2023. Use date extraction 
to filter by quarter.
**/

SELECT *
FROM company_dim
LIMIT 10;

SELECT *
FROM job_postings_fact
--WHERE job_title LIKE '%Insurance%'
LIMIT 10;

SELECT 
    company_dim.company_id,
    company_dim.name,
    job_postings_fact.job_title_short,
    job_postings_fact.job_posted_date,
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS month,
    job_postings_fact.job_health_insurance
FROM 
    company_dim
LEFT JOIN
    job_postings_fact
ON job_postings_fact.company_id = company_dim.company_id
WHERE job_health_insurance = TRUE 
AND
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) IN (4,5,6)
LIMIT 20
;


