FLUSH PRIVILEGES;
CREATE USER IF NOT EXISTS 'db_user'@'%' IDENTIFIED BY 'd41e98d1eafa6d6011d3a70f1a5b92f0';
GRANT ALL ON *.* to db_user@'%' IDENTIFIED BY 'd41e98d1eafa6d6011d3a70f1a5b92f0';
CREATE DATABASE IF NOT EXISTS employee_db;
USE employee_db;
CREATE TABLE if not exists employees (name VARCHAR(20));
INSERT INTO employee_db.employees VALUES ('Marian Bugar');
