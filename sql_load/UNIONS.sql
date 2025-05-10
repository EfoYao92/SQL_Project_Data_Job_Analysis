/*

Practice Problem 1
-Get the corresponding skill and type for each job posting in Q1
-Includes those without any skills, too
-Why? Look at the skills and the type for each job in the first quarter that has a salary
> $ 70,000

*/

SELECT
    *
FROM 
    january_jobs
LIMIT 100

SELECT *
FROM skills_dim

SELECT *
FROM skills_job_dim
LIMIT 50


WITH Q1 AS (
    SELECT 
        job_id,
        job_title_short,
        job_posted_date,
        salary_year_avg
    FROM january_jobs
    UNION ALL
    SELECT 
        job_id,
        job_title_short,
        job_posted_date,
        salary_year_avg
    FROM february_jobs
    UNION ALL
    SELECT 
        job_id,
        job_title_short,
        job_posted_date,
        salary_year_avg
    FROM march_jobs
)

SELECT 
    Q1.job_id,
    Q1.job_title_short,
    Q1.job_posted_date,
    Q1.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM Q1
LEFT JOIN skills_job_dim
ON Q1.job_id = Q1.job_id
LEFT JOIN skills_dim
ON  skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    Q1.salary_year_avg > 70000 --AND
--    Q1.job_title_short = 'Data Analyst'
ORDER BY Q1.salary_year_avg --Q1.job_posted_date
LIMIT 10000




