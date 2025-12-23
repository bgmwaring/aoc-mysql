USE aoc;

-- load input
TRUNCATE TABLE input_lines;

LOAD DATA LOCAL INFILE 'inputs/day07.txt'
INTO TABLE input_lines
LINES TERMINATED BY '\n'
(line);

-- part 1
SELECT 'Part 1' AS section;

DELIMITER $$

DROP PROCEDURE IF EXISTS process_lines;
CREATE PROCEDURE process_lines()
BEGIN
	DECLARE current_line TEXT;
	DECLARE i INT DEFAULT 2;
	DECLARE j INT DEFAULT 1;
	DECLARE previous_line TEXT;
	DECLARE result INT DEFAULT 0;
	DECLARE num_cols INT;
	DECLARE num_rows INT;

	-- create new table for this part
	DROP TABLE IF EXISTS graph;
	CREATE TABLE graph LIKE input_lines;
	INSERT INTO graph SELECT * FROM input_lines;

	-- update start position top pipe
	UPDATE graph SET line = REPLACE(line, 'S', '|') WHERE line_no = 1;

	SELECT line
	INTO previous_line
	FROM graph
	WHERE line_no = 1;

	SET num_cols = LENGTH(previous_line);

	SELECT COUNT(*)
	INTO num_rows
	FROM graph;

	WHILE i <= num_rows DO
		SELECT line
		INTO current_line
		FROM graph
		WHERE line_no = i;

		WHILE j <= num_cols DO
			IF SUBSTRING(previous_line FROM j FOR 1) = '|' THEN
				IF SUBSTRING(current_line FROM j FOR 1) = '.' THEN
					SET current_line = CONCAT(SUBSTRING(current_line, 1, j - 1), '|', SUBSTRING(current_line, j + 1));
				END IF;

				IF SUBSTRING(current_line FROM j FOR 1) = '^' THEN
					SET result = result + 1;

					IF j != 1 THEN 
						SET current_line = CONCAT(SUBSTRING(current_line, 1, j - 2), '|', SUBSTRING(current_line, j));
					END IF;

					IF j != num_cols THEN 
						SET current_line = CONCAT(SUBSTRING(current_line, 1, j), '|', SUBSTRING(current_line, j + 2));
					END IF;
				END IF;
			END IF;

			SET j = j + 1;
		END WHILE;

		-- update table for next part
		UPDATE graph SET line=current_line WHERE line_no=i;
		SET previous_line = current_line;
		SET i = i + 1;
		SET j = 1;
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
	DECLARE current_line TEXT;
	DECLARE i INT DEFAULT 2;
	DECLARE j INT DEFAULT 1;
	DECLARE previous_line TEXT;
	DECLARE num_cols INT;
	DECLARE num_rows INT;
	DECLARE score BIGINT DEFAULT 0;

	DECLARE above TEXT;
	DECLARE above_left TEXT;
	DECLARE above_right TEXT;

	-- create new table for this part
	DROP TABLE IF EXISTS graph;
	CREATE TABLE graph LIKE input_lines;
	INSERT INTO graph SELECT * FROM input_lines;

	-- update start position top pipe
	UPDATE graph SET line = REPLACE(line, 'S', 1) WHERE line_no = 1;

	SELECT line
	INTO previous_line
	FROM graph
	WHERE line_no = 1;

	SET num_cols = LENGTH(previous_line);

	-- create result set
	DROP TABLE IF EXISTS grid_cells;
	CREATE TABLE grid_cells (
		row_no INT,
		col_num INT,
		cell TEXT NOT NULL
	);

	-- input previous line into result grid before we iterate
	WHILE j <= num_cols DO
		INSERT INTO grid_cells VALUES (1, j, SUBSTRING(previous_line FROM j FOR 1));

		SET j = j + 1;
	END WHILE;

	-- result j count
	SET j = 1;

	SELECT COUNT(*)
	INTO num_rows
	FROM graph;

	WHILE i <= num_rows DO
		SELECT line
		INTO current_line
		FROM graph
		WHERE line_no = i;

		WHILE j <= num_cols DO
			SELECT cell
			INTO above
			FROM grid_cells
			WHERE row_no = i - 1 AND col_num = j;

			SELECT cell
			INTO above_left
			FROM grid_cells
			WHERE row_no = i - 1 AND col_num = j - 1;

			SELECT cell
			INTO above_right
			FROM grid_cells
			WHERE row_no = i - 1 AND col_num = j + 1;

			IF above != '.' AND above != '^' THEN
				SET score = score + above;
			END IF;

			IF above_left IS NOT NULL AND SUBSTRING(current_line FROM j - 1 FOR 1) = '^' AND above_left != '.' AND above_left != '^' THEN
				SET score = score + above_left;
			END IF;

			IF above_right IS NOT NULL AND SUBSTRING(current_line FROM j + 1 FOR 1) = '^' AND above_right != '.' AND above_right != '^' THEN
				SET score = score + above_right;
			END IF;

			IF SUBSTRING(current_line FROM j FOR 1) != '^' THEN
				INSERT INTO grid_cells VALUES (i, j, score);
			ELSE
				INSERT INTO grid_cells VALUES (i,j,'^');
			END IF;

			SET j = j + 1;
			SET score = 0;
		END WHILE;

		SET i = i + 1;
		SET j = 1;
	END WHILE;

	SELECT SUM(cell) FROM grid_cells WHERE row_no = 142;
END$$

DELIMITER ;

-- call the stored procedure
CALL process_lines();