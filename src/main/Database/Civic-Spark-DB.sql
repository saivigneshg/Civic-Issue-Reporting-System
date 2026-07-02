CREATE DATABASE civic_issue_tracker;
USE civic_issue_tracker;

-- Users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mobile VARCHAR(15) NOT NULL,
    password VARCHAR(255) NOT NULL, -- store hashed password
    role ENUM('citizen', 'admin') DEFAULT 'citizen',
    village VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

update users set role = 'super-admin' where id =1;
update users set role = 'admin' where id = 2;

insert into users values(0,'Basya','basya@gmail.com','8908908901','1234',default,'Gadag',default);

alter table users 
modify role ENUM('citizen', 'admin','super-admin') DEFAULT 'citizen';

desc table users;

insert into users values(0,'kiran','kiran@gmail.com','1231230123','1234',default,'Bagalur',default);