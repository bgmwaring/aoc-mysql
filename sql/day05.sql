USE aoc;

-- load input
TRUNCATE TABLE input_lines;

LOAD DATA LOCAL INFILE 'inputs/day05.txt'
INTO TABLE input_lines
LINES TERMINATED BY '\n'
(line);

-- part 1
SELECT 'Part 1' AS section;

DROP TABLE IF EXISTS input_ranges;
CREATE TABLE input_ranges AS
SELECT *
FROM input_lines
WHERE line LIKE '%-%';

DROP TABLE IF EXISTS input_values;
CREATE TABLE input_values AS
SELECT *
FROM input_lines
WHERE line REGEXP '^[0-9]+$';

DELIMITER $$

DROP PROCEDURE IF EXISTS process_lines;
CREATE PROCEDURE process_lines()
BEGIN
    -- declare variables
    DECLARE done INT DEFAULT 0;
    DECLARE input_range VARCHAR(255);
	DECLARE range_start BIGINT;
	DECLARE range_end BIGINT;
    
    -- declare cursor to iterate over table
    DECLARE cur CURSOR FOR SELECT line FROM input_ranges;
    
    -- handler to exit loop when no more rows
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- open cursor
    OPEN cur;
    
	SET @result := 0;
    read_loop: LOOP
        FETCH cur INTO input_range;
        IF done THEN
            LEAVE read_loop;
        END IF;

		SET range_start = SUBSTRING_INDEX(input_range, '-', 1) + 0;
		SET range_end = SUBSTRING_INDEX(input_range, '-', -1) + 0;

		SET @result := @result + (SELECT COUNT(*) FROM input_values WHERE line + 0 >= range_start AND line + 0 <= range_end);

		-- remove the counted values so we don't include them in a different range
		DELETE FROM input_values WHERE line + 0 >= range_start AND line + 0 <= range_end;
    END LOOP;

    -- close cursor
    CLOSE cur;

	-- output result
	SELECT @result;
END$$

DELIMITER ;

-- call the stored procedure
CALL process_lines();


-- part 2
SELECT 'Part 2' AS section;

DROP TABLE IF EXISTS ranges;
CREATE TABLE ranges AS
SELECT 
	SUBSTRING_INDEX(line, '-', 1) + 0 AS range_start,
	SUBSTRING_INDEX(line, '-', -1) + 0 AS range_end
FROM input_ranges;

DELIMITER $$

DROP PROCEDURE IF EXISTS process_lines;
CREATE PROCEDURE process_lines()
BEGIN
    -- declare variables
    DECLARE done INT DEFAULT 0;
	DECLARE current_range_start BIGINT;
	DECLARE current_range_end BIGINT;
	DECLARE tracked_range_start BIGINT DEFAULT 0;
	DECLARE tracked_range_end BIGINT DEFAULT 0;
    
    -- declare cursor to iterate over table
    DECLARE cur_start CURSOR FOR SELECT range_start FROM ranges ORDER BY range_start;
    DECLARE cur_end CURSOR FOR SELECT range_end FROM ranges ORDER BY range_start;
    
    -- handler to exit loop when no more rows
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- open cursor
    OPEN cur_start;
    OPEN cur_end;
    
	SET @result := 0;
    read_loop: LOOP
        FETCH cur_start INTO current_range_start;
        FETCH cur_end INTO current_range_end;
        IF done THEN
			SET @result := @result + (tracked_range_end - tracked_range_start) + 1;
            LEAVE read_loop;
        END IF;

		IF tracked_range_start = 0 THEN
			SET tracked_range_start := current_range_start;
			SET tracked_range_end := current_range_end;
		END IF;

		IF current_range_start <= tracked_range_end THEN 
			IF current_range_end > tracked_range_end THEN 
				SET tracked_range_end := current_range_end;
			END IF;
		ELSE
			SET @result := @result + (tracked_range_end - tracked_range_start) + 1;
			SET tracked_range_start := current_range_start;
			SET tracked_range_end := current_range_end;
		END IF;

    END LOOP;

    -- close cursor
    CLOSE cur_start;
    CLOSE cur_end;

	-- output result
	SELECT @result;
END$$

DELIMITER ;

-- call the stored procedure
CALL process_lines();
