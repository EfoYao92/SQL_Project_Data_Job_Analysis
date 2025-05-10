SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1
LIMIT 10;

Creating Tables

-- January
CREATE TABLE january_jobs AS 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
;

-- February
CREATE TABLE february_jobs AS 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2
;

-- March
CREATE TABLE march_jobs AS 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3
;

SELECT
    job_title_short,
    job_location
FROM job_postings_fact
LIMIT 10;

/*

Label new column as follows"
- 'Anywhere 'jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'

*/

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category
;

/*

Practice Problem 1

I want to categorize the salaries from each job posting. TO see if it fis in my desired salary range.
-Put salary into different buckets
-Define what's high, standard, or low salary with our own conditions
-Why? It is necessary to determine which job postings are worth looking based on salary.
 Bucketing is a common practice in data analysis when viewing categories.
 -I only want to look at data analyst roles-Order from highest to lowest.
*/

SELECT *
FROM job_postings_fact
LIMIT 100;

SELECT
    MIN(salary_year_avg),
    AVG(salary_year_avg),
    MAX(salary_year_avg)
FROM
    job_postings_fact;

SELECT
    COUNT(job_id) AS job_count,
--    job_title_short,
    CASE
        WHEN salary_year_avg <= 90000 THEN 'Low'
        WHEN salary_year_avg BETWEEN 90000 AND 130000 THEN 'Standard'
        WHEN salary_year_avg >= 130000 THEN 'High'
        ELSE NULL
    END AS salary_range
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
AND
   salary_year_avg IS NOT NULL
GROUP BY salary_range
ORDER BY job_count ASC;

