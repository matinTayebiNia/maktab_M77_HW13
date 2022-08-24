CREATE
DATABASE ChainStore;

USE
ChainStore;

CREATE TABLE branches
(
    id        INT         NOT NULL AUTO_INCREMENT,
    name      VARCHAR(70) NOT NULL,
    city      VARCHAR(70) NOT NULL,
    createdAt TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE units
(
    id          INT         NOT NULL AUTO_INCREMENT,
    name        VARCHAR(80) NOT NULL,
    description TEXT NULL,
    branch_id   INT         NOT NUll,
    PRIMARY KEY (id),
    FOREIGN KEY (branch_id) REFERENCES branches (id)
);

CREATE TABLE employee
(
    id      INT         NOT NULL AUTO_INCREMENT,
    name    VARCHAR(80) NOT NULL,
    age     INT         NOT NULL,
    salary  INT         NOT NULL,
    unit_id INT         NOT NUll,
    PRIMARY KEY (id),
    FOREIGN KEY (unit_id) REFERENCES units (id)
);

--Names of employees whose salary is less than 1000.
SELECT employee.name FROM employee WHERE employee.salary <1000

--Names of employees along with the name of their administrative unit
SELECT employee.name, units.name FROM units
INNER JOIN employee
ON employee.unit_id= units.id

-- Average salary of employees of each unit
SELECT DISTINCT avgsalary, units.name AS "unitName"
FROM units
    INNER JOIN (SELECT e.*, AVG(salary) over (PARTITION BY e.unit_id) AS avgsalary
    FROM employee e
) e
ON e.unit_id = units.id

--The name of the administrative units of the "Isfahan" branch
SELECT units.name FROM units
INNER JOIN branches
ON branches.id= units.branch_id
WHERE branches.city="اصفهان"

--The name of the branches along with the number of units of each
SELECT COUNT(units.id) as "units", branches.name AS "name_branch"
FROM units INNER JOIN branches
ON branches.id= units.branch_id GROUP BY name_branch;

--The names of the employees along with the name of their branch
SELECT DISTINCT employee.name, branches.name FROM branches
INNER JOIN units ON branches.id= units.branch_id
INNER JOIN employee ON units.id=employee.unit_id


-- Average salary of employees of "Isfahan" branch
SELECT AVG(employee.salary) AS "salary" FROM units
INNER JOIN (SELECT * FROM branches WHERE branches.city="اصفهان") b ON b.id = units.branch_id
INNER JOIN employee ON units.id = employee.unit_id


--The name of the branches along with the number of employees in each
SELECT COUNT(employee.id) AS "employees", branches.name FROM units
INNER JOIN branches ON branches.id = units.branch_id
INNER JOIN employee ON units.id = employee.unit_id
GROUP BY branches.name

--The name of the administrative units of "Isfahan" branch along with the number of employees in each unit
SELECT DISTINCT units.name,COUNT(employee.id) FROM units
INNER JOIN (SELECT * FROM branches WHERE branches.city="اصفهان") b
ON units.branch_id=b.id
LEFT JOIN  employee
ON employee.unit_id=units.id
GROUP BY units.name


--Names of branches with less than 10 employees
SELECT DISTINCT branches.name FROM units
INNER JOIN branches
ON units.branch_id=branches.id
INNER JOIN employee
ON employee.unit_id=units.id
GROUP BY branches.name
HAVING COUNT(employee.id) < 10


