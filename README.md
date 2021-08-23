# Pewlett-Hackard-Analysis

## Project Overview
This project is part of a larger overall project to look at the large number of employees who are becoming eligible to retire from Pewlett-Hackard in a short span of time (referred to internally as the "Silver Tsunami"), in order guage impact to the company and to plan for the future.  

In this phase of the project we are looking specifically at the following two areas of analysis:
1.  The number of retiring employees per title (employees eligible for retirement were born between the years 1952 and 1955)
1.  Employees who are eligible to participate in a mentorship program (employees who were born in the year 1965)


##  Resources
The following resources were used to complete this analysis:
- Data Sources: PH-EmployeeDB (Database)
- Software:  PostgreSQL, Visual Studio Code, 1.58.2


## Analysis Results
### Retiring Employees by Title 
For this analysis, we created a file containing the number of retirement-age employees by job title.  To do this, we first joined the employees table containing a listing of all employees, to the titles table which contains a listing of titles by employee. Since the titles table contains all titles, both past and current held by an employee, we created a new table containing just the current title by employee.  We then created a summary table from that data containing number of retiring employees by job title.  The summary table, as well as the employee titles table and current title by employee table, were then exported as CSV files.

![retiring_titles](https://github.com/adbauer06/Pewlett-Hackard-Analysis/blob/main/Data/retiring_titles.csv)
    
### Employees Eligible for Mentorship Program    
For this analysis, we created a file listing employees eligible for the mentorship program.  To do this we selected all current employees who were born in the year 1965.  We joined to the employee_dept table to get the date they started in their current department and to the titles table to get their curent job title.  We created a new table called 'mentorship_eligibility', which was also exported to a CSV file.   


### Results Summary    
The results of both of these analyses showed:
- There are just over 90,000 employees who will be retiring from Pewlett-Hackard in the very near future.
- More than half of those are senior level positions (57,668 Senior Engineer and Senior Staff).
- There are only 1,549 current employees who are eligible for the mentorship program.  
- Of those eligible for the mentorship program, nearly half of them (738 employees) are already in senior level positions.


 ## Summary

As the "Silver Tsunami" begins to make an impact, over a short period of time over 90,000 positions will become vacant.  These roles will include engineers, assistant engineers, senior engineers, staff members, senior staff members, technique leaders, as well as a couple of management positions.

While there are sufficient qualified retirement-ready employees to mentor the next generation of Pewlett Hackard employees, there does not appear to be a sufficient number of current employees to move up into the positions being vacated by the large number of retiring employees.

A couple of additional queries that can provide more insight are as follows:

- In creating the "unique_titles" table listing all retiring employees and their most recent position, it was not taken into account that the most recent position may not necessarily be the current position, such as might be the case if an employee is no longer with the company.  The following query can be used to evaluate if this situation does impact the original number of retiring employees:

        SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
            rt.first_name,
            rt.last_name,
            rt.title,
            rt.to_date
        FROM retirement_titles as rt
        --where to_date = '9999-01-01'
        ORDER BY rt.emp_no, rt.to_date DESC;

    Running the above query shows that there are indeed rows where the most recent position has an ending date (to_date) in the past.  Adding a where-condition specifying that to_date = '9999-01-01' (meaning it is still a currently held position title) returns 72,458 retiring employees, which is still a very large number, but quite a bit less than the original number of over 90,000.

- Another query that could give more insight into this analysis overall would be to look not only at number of retiring employees by title, but by title within department to get a better idea of impact not only with positions needing to be replaced, but departments being impacted by this large number of impending retirements.  The first query below can be used to select both the current title and department of retiring employees.  The following query can then be used to summarize counts by title and department.  These produce the same total number of retiring employees, but shows by title by department.

        -- Create a table of retiring employees and current department 
        -- and title
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
