CREATE DATABASE employee_db;
GRANT ALL ON *.* to db_user@'%' IDENTIFIED BY 'Passw0rd';
USE employee_db;
CREATE TABLE employees (name VARCHAR(20));