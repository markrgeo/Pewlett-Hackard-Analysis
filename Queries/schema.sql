--Creating tables for PH-EmployeeDB

CREATE TABLE departments (dept_no varchar(4) NOT NULL,
						 dept_name varchar(40) NOT NULL,
						  PRIMARY KEY (dept_no),
						  UNIQUE (dept_name));

CREATE TABLE employees (emp_no int NOT NULL, birth_date date NOT NULL,
					   first_name varchar NOT NULL, last_name varchar NOT NULL,
					   gender varchar NOT NULL, hire_date date NOT NULL,
					   PRIMARY KEY (emp_no));

CREATE TABLE manager (dept_no varchar(4) NOT NULL, emp_no INT NOT NULL,
					 from_date date NOT NULL, to_date date NOT NULL, 
					  FOREIGN KEY (emp_no) references employees (emp_no),
					  FOREIGN KEY (dept_no) references departments (dept_no),
					  PRIMARY KEY (emp_no, dept_no));
																				   
CREATE TABLE salaries (emp_no INT NOT NULL, salary int NOT NULL, 
					   from_date date NOT NULL, to_date date NOT NULL,
					  FOREIGN KEY (emp_no) references employees (emp_no),
					  PRIMARY KEY (emp_no));	
					  
CREATE TABLE dept_emp (emp_no int NOT NULL, dept_no varchar NOT NULL, 
					   from_date date NOT NULL, to_date date NOT NULL,
					   FOREIGN KEY (emp_no) references employees (emp_no),
					   FOREIGN KEY (dept_no) references departments (dept_no),
					   PRIMARY KEY (emp_no, dept_no));	
					   
CREATE TABLE titles (emp_no int NOT NULL, title varchar NOT NULL,
					from_date date NOT NULL, to_date date NOT NULL,
					FOREIGN KEY (emp_no) references employees (emp_no));			
					
SELECT * From departments;	
SELECT * From manager;
SELECT * From titles;

DROP TABLE titles CASCADE;

SELECT first_name, last_name 
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- Retirement Eligability
SELECT first_name, last_name 
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring (COUNT)
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Export Results into new table retirement_info
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables. Use aliases
SELECT d.dept_name, dm.emp_no, dm.from_date, dm.to_date
FROM departments AS d
INNER JOIN manager AS dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables. Use aliases
SELECT ri.emp_no, ri.first_name, ri.last_name, de.to_date
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no;

-- Join retirement_info and dept_emp into a new table, current_emp
SELECT ri.emp_no, ri.first_name, ri.last_name, de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT (ce.emp_no), de.dept_no
FROM current_emp AS ce
LEFT JOIN dept_emp AS de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number, order by dept_no
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Create new table for total number of retiring employees
SELECT COUNT(ce.emp_no), de.dept_no
INTO retiring_emp
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no

--Show new table data
SELECT * FROM retiring_emp

--Show Salary table in order of dates
SELECT * FROM salaries
ORDER BY to_date DESC;

--Request 1. Module 7.3.5
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

--Request 2. List of managers per department. Module 7.3.5
SELECT  dm.dept_no, d.dept_name, dm.emp_no, ce.last_name, ce.first_name,
        dm.from_date, dm.to_date
		INTO manager_info
FROM manager AS dm
INNER JOIN departments AS d
ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp AS ce
ON (dm.emp_no = ce.emp_no);

--Request 3. Module 7.3.5
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--Request 1. Module 7.3.6
SELECT ri.emp_no, ri.first_name, ri.last_name, de.dept_no
INTO sales_retirement
FROM retirement_info AS ri
INNER JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
WHERE (de.dept_no = 'd007');

--Request 2. Module 7.3.6
SELECT ri.emp_no, ri.first_name, ri.last_name, de.dept_no
INTO sales_dev_info
FROM retirement_info AS ri
INNER JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
WHERE de.dept_no IN ('d007', 'd005');


