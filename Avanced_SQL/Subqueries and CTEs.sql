-- SUBQUERIES in action

SELECT  company_id, name AS  company_name
FROM company_dim
WHERE company_id IN (
    SELECT
            company_id
    FROM
            job_postings_fact
    WHERE
            job_no_degree_mention = TRUE
    ORDER BY
            company_id
)

-- CTEs - Common Table Expressions

WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT *
FROM january_jobs; 

/*
Find the companies that have the most job openings.
-Get the total number f job postings per company id(job_posting_fact)
-Return the total number of jobs with the company(company_dim)
*/
WITH company_job_count AS (
    SELECT
    company_id,
    COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT 
    company_dim.name AS comany_name,
    company_job_count.total_jobs

FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC

/*
Practice Problem 1
Identify top 5 skills that are most frenquently mentioned in job postings. Use subquery to
find the skill IDs with the highest counts in the (skills_job_dim) table and then join this result
with the (skill_dim) table to get the skill names.
*/

SELECT *
FROM skills_dim

SELECT *
FROM skills_job_dim
LIMIT 50

SELECT
    skill_id,
    skills,
    skill_job_count 
FROM (
        SELECT
            skills_dim.skills,
            skills_job_dim.skill_id, 
            COUNT(job_id) AS skill_job_count
        FROM
            skills_job_dim
        LEFT JOIN
            skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
        GROUP BY skills_job_dim.skill_id, skills_dim.skills
        ORDER BY skill_job_count DESC
        
)
LIMIT 5


/*
Practice Problem 2
Determine the size category ('Small','Medium','Large') for each company by first identifying
the number of job postings they have. Use a subquery to calculate the total job postings per
company. A company is considered 'Small' if it has less than 10 job postings, 'Medium' if the
number of job postings is between 10 and 50, and 'Large' if it has more than 50 job postings.
Implement a subquery to aggregate job counts per company before classifying them based on
size.

*/


-- explore comany_dim table
SELECT * FROM company_dim
LIMIT 30

-- explore job_postings_fact table
SELECT 
    company_id, 
    job_title_short 
FROM job_postings_fact
LIMIT 50

-- workings
SELECT 
    company_id, 
    name
FROM job_postings_fact
WHERE company_id IN (
        SELECT company_id
        FROM company_dim
)
LIMIT 50

WITH company_job_postings AS
    (SELECT
        company_id,
        name,
        company_job_count
    FROM (
            SELECT
                job_postings_fact.company_id,
                company_dim.name,
                COUNT(job_id) AS company_job_count
            FROM
                job_postings_fact
            LEFT JOIN
                company_dim
            ON job_postings_fact.company_id = company_dim.company_id
            GROUP BY job_postings_fact.company_id, company_dim.name
            
    )

)

SELECT *,
    CASE
        WHEN company_job_count < 10 THEN 'Small'
        WHEN company_job_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS job_count_category
FROM company_job_postings

/*
Find the count of the number of remote job postings per skill
    -Display the top 5 skills  by their demand in remote jobs
    -Include skill ID, name, and count of postings requiring the skill
*/

WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings
    ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = True AND
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN
    skills_dim AS skills
ON skills.skill_id = remote_job_skills.skill_id
ORDER BY 
    skill_count DESC
LIMIT 5