-- Fix authentication for all users
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'rootpassword';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'rootpassword';
ALTER USER 'mindful'@'%' IDENTIFIED WITH mysql_native_password BY 'mindful2025';

-- Create additional user with native password as backup
CREATE USER IF NOT EXISTS 'mindful_native'@'%' IDENTIFIED WITH mysql_native_password BY 'mindful2025';
GRANT ALL PRIVILEGES ON *.* TO 'mindful_native'@'%' WITH GRANT OPTION;

-- Ensure mindful user has all privileges
GRANT ALL PRIVILEGES ON *.* TO 'mindful'@'%' WITH GRANT OPTION;

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS productdb;

-- Grant specific database privileges
GRANT ALL PRIVILEGES ON productdb.* TO 'mindful'@'%';
GRANT ALL PRIVILEGES ON productdb.* TO 'mindful_native'@'%';

FLUSH PRIVILEGES;