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

select * from users;

-- Categories table
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE  -- Just store the category name
);

INSERT INTO categories (id, name) VALUES 
(1, 'Road Construction'),
(2, 'Drainage & Sewage'),
(3, 'Street Light'),
(4, 'Garbage & Sanitation'),
(5, 'Water Supply'),
(6, 'Electricity'),
(7, 'Healthcare Facility'),
(8, 'Other Public Service');

-- Issues table (main)
CREATE TABLE issue_reports (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(120) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    location VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8),  -- Optional: for map integration
    longitude DECIMAL(11, 8), -- Optional: for map integration
    status ENUM('pending', 'assigned', 'in_progress', 'resolved', 'rejected', 'closed') DEFAULT 'pending',
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    assigned_to INT NULL,  -- Foreign key to users table
    assigned_by INT NULL,  -- Who assigned this issue
    assigned_date TIMESTAMP NULL,
    resolved_date TIMESTAMP NULL,
    resolution_notes TEXT,
    reported_by INT,  -- Foreign key to users table (citizen who reported)
    reported_by_name VARCHAR(100), -- Optional: if not using user accounts
    reported_by_email VARCHAR(100), -- For contact
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign keys
    FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (reported_by) REFERENCES users(id) ON DELETE SET NULL,
    
    -- Indexes for faster queries
    INDEX idx_status (status),
    INDEX idx_category (category),
    INDEX idx_created_at (created_at),
    INDEX idx_assigned_to (assigned_to),
    INDEX idx_priority (priority),
    INDEX idx_location (location(100))
);

ALTER TABLE issue_reports 
ADD COLUMN category_id INT,
ADD FOREIGN KEY (category_id) REFERENCES categories(id),
ADD INDEX idx_category_id (category_id);


-- 3. Images table (separate for multiple images)
CREATE TABLE report_images (
    id INT PRIMARY KEY AUTO_INCREMENT,
    report_id INT NOT NULL,
    image_path VARCHAR(500) NOT NULL,
    image_name VARCHAR(255),
    image_size_kb INT,
    mime_type VARCHAR(50),
    image_order INT DEFAULT 0,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (report_id) REFERENCES issue_reports(id) ON DELETE CASCADE,
    INDEX idx_report_id (report_id)
);


-- Status history (audit log)
CREATE TABLE issue_status_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    issue_id INT NOT NULL,
    old_status VARCHAR(30),
    new_status VARCHAR(30) NOT NULL,
    changed_by INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES issues(id),
    FOREIGN KEY (changed_by) REFERENCES users(id)
);

create table message(
id int primary key auto_increment,
title varchar(120),
description text,
report_id int,
sent_by_id int,
sent_by_name varchar(100),
sentBy_role varchar(15),
reciever_id int,
reviever_name varchar(100),
sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
select * from message;

USE civic_issue_tracker;
select * from users;
SELECT * FROM REPORT_IMAGES;
select * from issue_reports;
select * from report_images;
select * from message;

update issue_reports
set reported_by = 3, reported_by_name = "Basya", reported_by_email  = "basya@gmail.com"
where id = 6;

update issue_reports 
set status = "rejected"
where id = 1;

update issue_reports 
set status = "in_progress"
where id = 4;

update issue_reports 
set priority = "medium"
where id = 2;

update issue_reports 
set priority = "low"
where id = 5;

update issue_reports
set status = "resolved"
where id = 3;


