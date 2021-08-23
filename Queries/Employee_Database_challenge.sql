--Create a table of Retiring Employees by Title
SELECT e.emp_no,
       e.first_name,
	   e.last_name,
	   t.title,
	   t.from_date,
	   t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY 1;


-- Remove duplicates from retirement_titles table using distinct and order by
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;


--Retrieve employees by their most recent job title who are about to retire
SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY 1 desc


-- Create mentorship eligibility table
SELECT DISTINCT ON (e.emp_no) e.emp_no,
       e.first_name,
	   e.last_name,
	   e.birth_date,
	   ed.from_date,
	   ed.to_date,
	   t.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN employee_dept as ed
ON (e.emp_no = ed.emp_no)
INNER JOIN titles as t
ON (ed.emp_no = t.emp_no)
WHERE (ed.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY 1; 


-- Additional analysis queries

-- Select distinct titles that are still current
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
            rt.first_name,
            rt.last_name,
            rt.title,
            rt.to_date
FROM retirement_titles as rt
where to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.to_date DESC;


-- Create a table of retiring employees and current department and title
SELECT DISTINCT ON (e.emp_no) e.emp_no,
       e.first_name,
	   e.last_name,
	   e.birth_date,
	   ed.from_date,
	   ed.to_date,
	   ed.dept_no,
	   d.dept_name,
	   t.title
INTO retirement_dept_title
FROM employees as e
INNER JOIN employee_dept as ed
ON (e.emp_no = ed.emp_no)
INNER JOIN titles as t
ON (ed.emp_no = t.emp_no)
INNER JOIN departments d
ON (ed.dept_no = d.dept_no)
WHERE (ed.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY 1; 


--Summarize by title and department
SELECT COUNT(emp_no), title, dept_name
into retiring_titles_dept
FROM retirement_dept_title
GROUP BY title, dept
ORDER BY 2, 1 desc       