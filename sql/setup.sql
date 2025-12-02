CREATE DATABASE IF NOT EXISTS `aoc`;
USE `aoc`;

-- table to store aoc input lines
CREATE TABLE IF NOT EXISTS `input_lines` (
	`line_no` INT AUTO_INCREMENT PRIMARY KEY,
	`line` TEXT NOT NULL
);