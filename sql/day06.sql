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