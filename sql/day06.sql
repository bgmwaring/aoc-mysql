USE aoc;

-- load input
TRUNCATE TABLE input_lines;

LOAD DATA LOCAL INFILE 'inputs/day06.txt'
INTO TABLE input_lines
LINES TERMINATED BY '\n'
(line);

-- part 1
SELECT 'Part 1' AS section;

DELIMITER $$

DROP PROCEDURE IF EXISTS process_lines;
CREATE PROCEDURE process_lines()
BEGIN
	DECLARE result BIGINT DEFAULT 0;
	DECLARE value_one INT;
	DECLARE value_two INT;
	DECLARE value_three INT;
	DECLARE value_four INT;
	DECLARE operation VARCHAR(100);
	DECLARE i INT DEFAULT 1; -- this is to track our loop
	DECLARE count INT;
	DECLARE current_line TEXT;

	-- create new table for this part
	DROP TABLE IF EXISTS part_one;
	CREATE TABLE part_one LIKE input_lines;
	INSERT INTO part_one SELECT * FROM input_lines;

	-- strip excess whitespace from rows
	strip_loop: WHILE TRUE DO
		UPDATE part_one SET line = REPLACE(line, '  ', ' ');

		IF ROW_COUNT() = 0 THEN
			LEAVE strip_loop;
		END IF;
	END WHILE;

	SELECT line
	INTO current_line
	FROM part_one
	WHERE line_no = 1;
	SET count = LENGTH(current_line) - LENGTH(REPLACE(current_line, ' ', '')) + 1;

	main_loop: WHILE i <= count DO
		SELECT line
		INTO current_line
		FROM part_one
		WHERE line_no = 1;
		SET value_one = SUBSTRING_INDEX(
			SUBSTRING_INDEX(
				current_line,
				' ',
				i
			),
			' ',
			-1
		);

		SELECT line
		INTO current_line
		FROM part_one
		WHERE line_no = 2;
		SET value_two = SUBSTRING_INDEX(
			SUBSTRING_INDEX(
				current_line,
				' ',
				i
			),
			' ',
			-1
		);

		SELECT line
		INTO current_line
		FROM part_one
		WHERE line_no = 3;
		SET value_three = SUBSTRING_INDEX(
			SUBSTRING_INDEX(
				current_line,
				' ',
				i
			),
			' ',
			-1
		);

		SELECT line
		INTO current_line
		FROM part_one
		WHERE line_no = 4;
		SET value_four = SUBSTRING_INDEX(
			SUBSTRING_INDEX(
				current_line,
				' ',
				i
			),
			' ',
			-1
		);

		SELECT line
		INTO current_line
		FROM part_one
		WHERE line_no = 5;
		SET operation = SUBSTRING_INDEX(
			SUBSTRING_INDEX(
				current_line,
				' ',
				i
			),
			' ',
			-1
		);

		IF operation = '*' THEN
			SET result := result + (value_one * value_two * value_three * value_four);
		END IF;

		IF operation = '+' THEN
			SET result := result + value_one + value_two + value_three + value_four;
		END IF;

		SET i := i + 1;
	END WHILE;

	SELECT result;

END$$

DELIMITER ;

-- call the stored procedure
CALL process_lines();

-- part 2
SELECT 'Part 2' AS section;

DELIMITER $$

DROP PROCEDURE IF EXISTS process_lines;
CREATE PROCEDURE process_lines()
BEGIN
	DECLARE current_line TEXT DEFAULT '';
	DECLARE current_one TEXT DEFAULT '';
	DECLARE current_two TEXT DEFAULT '';
	DECLARE current_three TEXT DEFAULT '';
	DECLARE current_four TEXT DEFAULT '';
	DECLARE current_operation VARCHAR(100) DEFAULT '';
	DECLARE i INT DEFAULT 1;
	DECLARE operation VARCHAR(100) DEFAULT '';
	DECLARE p INT DEFAULT 1;
	DECLARE result BIGINT DEFAULT 0;
	DECLARE value_one TEXT DEFAULT '';
	DECLARE value_two TEXT DEFAULT '';
	DECLARE value_three TEXT DEFAULT '';
	DECLARE value_four TEXT DEFAULT '';

	-- create new table for this part
	DROP TABLE IF EXISTS part_two;
	CREATE TABLE part_two LIKE input_lines;
	INSERT INTO part_two SELECT * FROM input_lines;

	SELECT line
	INTO current_line
	FROM part_two
	WHERE line_no = 1;

	-- iterate through each character
	strip_loop: WHILE i <= LENGTH(current_line) + 1 DO
		SELECT line
		INTO current_line
		FROM part_two
		WHERE line_no = 1;
		SET current_one = SUBSTRING(current_line FROM i FOR 1);

		SELECT line
		INTO current_line
		FROM part_two
		WHERE line_no = 2;
		SET current_two = SUBSTRING(current_line FROM i FOR 1);

		SELECT line
		INTO current_line
		FROM part_two
		WHERE line_no = 3;
		SET current_three = SUBSTRING(current_line FROM i FOR 1);

		SELECT line
		INTO current_line
		FROM part_two
		WHERE line_no = 4;
		SET current_four = SUBSTRING(current_line FROM i FOR 1);

		SELECT line
		INTO current_line
		FROM part_two
		WHERE line_no = 5;
		SET current_operation = SUBSTRING(current_line FROM i FOR 1);

		IF current_one = ' ' AND current_two = ' ' AND current_three = ' ' AND current_four = ' ' OR current_one = '' AND current_two = '' AND current_three = '' AND current_four = '' THEN
			SET value_one = TRIM(value_one);
			SET value_two = TRIM(value_two);
			SET value_three = TRIM(value_three);
			SET value_four = TRIM(value_four);
			SET operation = TRIM(operation);

			IF operation = '*' THEN
				IF p = 2 THEN
					SET result = result + value_one;
				END IF;
				IF p = 3 THEN
					SET result = result + (value_one * value_two);
				END IF;
				IF p = 4 THEN
					SET result = result + (value_one * value_two * value_three);
				END IF;
				IF p = 5 THEN
					SET result = result + (value_one * value_two * value_three * value_four);
				END IF;
			END IF;

			IF operation = '+' THEN
				IF p = 2 THEN
					SET result = result + value_one;
				END IF;
				IF p = 3 THEN
					SET result = result + value_one + value_two;
				END IF;
				IF p = 4 THEN
					SET result = result + value_one + value_two + value_three;
				END IF;
				IF p = 5 THEN
					SET result = result + value_one + value_two + value_three + value_four;
				END IF;
			END IF;

			SET i = i + 1;
			SET p = 1;

			-- reset values
			SET operation = '';
			SET value_one = '';
			SET value_two = '';
			SET value_three = '';
			SET value_four = '';
		ELSE
			IF p = 1 THEN
				SET value_one = CONCAT(current_one, current_two, current_three, current_four);
			END IF;
			IF p = 2 THEN
				SET value_two = CONCAT(current_one, current_two, current_three, current_four);
			END IF;
			IF p = 3 THEN
				SET value_three = CONCAT(current_one, current_two, current_three, current_four);
			END IF;
			IF p = 4 THEN
				SET value_four = CONCAT(current_one, current_two, current_three, current_four);
			END IF;

			SET operation = CONCAT(operation, current_operation);

			SET i = i + 1;
			SET p = p + 1;
		END IF;
	END WHILE;

	SELECT result;
END$$

DELIMITER ;

-- call the stored procedure
CALL process_lines();