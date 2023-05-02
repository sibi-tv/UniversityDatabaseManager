CREATE DATABASE students;
USE students;

CREATE TABLE students(
	first_name VARCHAR(20), last_name VARCHAR(20), 
	id INT AUTO_INCREMENT PRIMARY KEY);

CREATE TABLE departments(
	name ENUM('Bio', 'Chem', 'CS', 'Eng', 'Math', 'Phys') PRIMARY KEY, 
	campus ENUM('Busch', 'CAC', 'Livi', 'CD'));
ALTER TABLE departments MODIFY COLUMN name VARCHAR(30);
    
CREATE TABLE classes(name VARCHAR(60) PRIMARY KEY, credits TINYINT CHECK(credits = 3 OR credits = 4));

CREATE TABLE majors(
	sid INT AUTO_INCREMENT PRIMARY KEY, 
    dname ENUM('Bio', 'Chem', 'CS', 'Eng', 'Math', 'Phys'), 
    FOREIGN KEY(sid) REFERENCES students(id),
    FOREIGN KEY(dname) REFERENCES departments(name));
ALTER TABLE majors MODIFY COLUMN dname VARCHAR(30);

CREATE TABLE minors(
	sid INT AUTO_INCREMENT PRIMARY KEY, 
    dname ENUM('Bio', 'Chem', 'CS', 'Eng', 'Math', 'Phys'), 
    FOREIGN KEY(sid) REFERENCES students(id),
    FOREIGN KEY(dname) REFERENCES departments(name));
    
CREATE TABLE isTaking(
	sid INTEGER,
    name VARCHAR(60),
    FOREIGN KEY(sid) REFERENCES students(id),
    FOREIGN KEY(name) REFERENCES classes(name));
    
CREATE TABLE hasTaken(
	sid INTEGER,
    name VARCHAR(60),
    grade CHAR(1),
    FOREIGN KEY(sid) REFERENCES students(id),
    FOREIGN KEY(name) REFERENCES classes(name));

drop table hasTaken;
drop table isTaking;
drop table majors;
drop table minors;
drop table classes;
drop table departments;
drop table students;
	