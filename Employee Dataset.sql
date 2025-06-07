-- Databricks notebook source
CREATE DATABASE IF NOT EXISTS Employee;
USING DATABASE Employee;


CREATE TABLE IF NOT EXISTS Employee.Employees
(
  employee_id INT, 
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  department_id INT FOREIGN KEY REFERENCES Departments(department_id),
  salary DECIMAL(10)
  );

CREATE TABLE IF NOT EXISTS Employee.Departments
(
  department_id INT PRIMARY KEY,
  department_name VARCHAR(255)
  );

-- Inserting the data into the tables
INSERT INTO Employee.employees(employee_id, first_name, last_name,department_id, salary) 

VALUES
(1, 'John', 'Doe', 1, 50000),
(2, 'Jane', 'Smith', 2, 60000),
(3, 'Bob', 'Johnson', 1, 55000),
(4, 'Alice', 'Williams', 2, 65000);

INSERT INTO Employee.departments (department_id, department_name)
VALUES
(1, 'Sales'),
(2, 'Marketing');

-- Retrieve the details of all employees.
SELECT * FROM Employee.employees;

-- Retrieve the names and departments of all employees.

SELECT Employees.first_name, Employees.last_name, departments.department_name
FROM Employee.employees
JOIN Employee.departments ON Employees.department_id = departments.department_id;

-- Retrieve the total number of employees in each department.

SELECT department_name, COUNT(*) AS total_employees
FROM Employee.departments
JOIN Employee.employees ON departments.department_id = employees.department_id
GROUP BY department_name
ORDER BY total_employees DESC;

-- Retrieve the highest salary among all employees.

SELECT MAX(Employees.salary) AS highest_salary
FROM Employee.employees;

-- Retrieve the employees who earn a salary higher than 55000.
SELECT * 
FROM Employee.employees
WHERE salary > 55000;

-- Retrieve the average salary in each department.

SELECT departments.department_name, AVG(Employees.salary) AS avg_salary
FROM Employee.departments
LEFT JOIN Employee.employees ON departments.department_id = employees.department_id
GROUP BY departments.department_name
ORDER BY avg_salary DESC;

-- Retrieve the employees who belong to the Sales department.

SELECT *
FROM Employee.employees
WHERE department_id = (SELECT DISTINCT department_id FROM Employee.departments WHERE department_name = 'Sales');

-- Retrieve the total salary expenditure for each department.

SELECT departments.department_name, SUM(Employees.salary) AS total_salary
FROM Employee.departments
LEFT JOIN Employee.employees ON departments.department_id = employees.department_id
GROUP BY departments.department_name
ORDER BY total_salary DESC;

--  Retrieve the department with the highest total salary expenditure.

SELECT departments.department_name, SUM(Employees.salary) AS total_salary
FROM Employee.departments
LEFT JOIN Employee.employees ON departments.department_id = employees.department_id
GROUP BY departments.department_name
ORDER BY total_salary DESC  LIMIT 1;

-- Retrieve the employees with the highest salary in each deaprtment

SELECT departments.department_name, employee.first_name, employee.last_name, employee.salary
FROM Employee.departments
JOIN Employee.employees employee ON departments.department_id = employee.department_id
WHERE employee.salary = (SELECT MAX(salary) FROM Employee.employees WHERE Employee.department_id = departments.department_id)
ORDER BY departments.department_name;

