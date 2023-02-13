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