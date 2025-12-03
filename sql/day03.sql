USE aoc;

-- load input
TRUNCATE TABLE input_lines;

LOAD DATA LOCAL INFILE 'inputs/day03.txt'
INTO TABLE input_lines
LINES TERMINATED BY '\n'
(line);

-- part 1
SELECT 'Part 1' AS section;

DELIMITER $$

DROP PROCEDURE IF EXISTS process_lines;
CREATE PROCEDURE process_lines()
BEGIN
    -- declare variables
    DECLARE done INT DEFAULT 0;
    DECLARE current_line TEXT;
    
    -- declare cursor to iterate over table
    DECLARE cur CURSOR FOR SELECT line FROM input_lines;
    
    -- handler to exit loop when no more rows
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- open cursor
    OPEN cur;

	-- declare counter
	SET @result := 0;
    
    read_loop: LOOP
        FETCH cur INTO current_line;
        IF done THEN
            LEAVE read_loop;
        END IF;

		SET @digit_one := 0;
		SET @digit_two := 0;

		SET @i := 1;
		WHILE @i <= LENGTH(current_line) DO
			IF SUBSTRING(current_line, @i, 1) + 0 > @digit_one AND @i != LENGTH(current_line) THEN
				SET @digit_one := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_two := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_two THEN
				SET @digit_two := SUBSTRING(current_line, @i, 1) + 0;
			END IF;

			-- increment counter
			SET @i := @i + 1;
		END WHILE;

		-- add to result
		SET @result := @result + ((@digit_one * 10) + @digit_two);

	END LOOP;

	-- output result
	SELECT @result;

    -- close cursor
    CLOSE cur;
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
    -- declare variables
    DECLARE done INT DEFAULT 0;
    DECLARE current_line TEXT;
    
    -- declare cursor to iterate over table
    DECLARE cur CURSOR FOR SELECT line FROM input_lines;
    
    -- handler to exit loop when no more rows
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- open cursor
    OPEN cur;

	-- declare counter
	SET @result := 0;
    
    read_loop: LOOP
        FETCH cur INTO current_line;
        IF done THEN
            LEAVE read_loop;
        END IF;

		SET @digit_one := 0;
		SET @digit_two := 0;
		SET @digit_three := 0;
		SET @digit_four := 0;
		SET @digit_five := 0;
		SET @digit_six := 0;
		SET @digit_seven := 0;
		SET @digit_eight := 0;
		SET @digit_nine := 0;
		SET @digit_ten := 0;
		SET @digit_eleven := 0;
		SET @digit_twelve := 0;

		SET @i := 1;
		WHILE @i <= LENGTH(current_line) DO
			IF SUBSTRING(current_line, @i, 1) + 0 > @digit_one AND @i < (LENGTH(current_line) - 10) THEN
				SET @digit_one := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_two := 0;
				SET @digit_three := 0;
				SET @digit_four := 0;
				SET @digit_five := 0;
				SET @digit_six := 0;
				SET @digit_seven := 0;
				SET @digit_eight := 0;
				SET @digit_nine := 0;
				SET @digit_ten := 0;
				SET @digit_eleven := 0;
				SET @digit_twelve := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_two AND @i < (LENGTH(current_line) - 9) THEN
				SET @digit_two := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_three := 0;
				SET @digit_four := 0;
				SET @digit_five := 0;
				SET @digit_six := 0;
				SET @digit_seven := 0;
				SET @digit_eight := 0;
				SET @digit_nine := 0;
				SET @digit_ten := 0;
				SET @digit_eleven := 0;
				SET @digit_twelve := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_three AND @i < (LENGTH(current_line) - 8) THEN
				SET @digit_three := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_four := 0;
				SET @digit_five := 0;
				SET @digit_six := 0;
				SET @digit_seven := 0;
				SET @digit_eight := 0;
				SET @digit_nine := 0;
				SET @digit_ten := 0;
				SET @digit_eleven := 0;
				SET @digit_twelve := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_four AND @i < (LENGTH(current_line) - 7) THEN
				SET @digit_four := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_five := 0;
				SET @digit_six := 0;
				SET @digit_seven := 0;
				SET @digit_eight := 0;
				SET @digit_nine := 0;
				SET @digit_ten := 0;
				SET @digit_eleven := 0;
				SET @digit_twelve := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_five AND @i < (LENGTH(current_line) - 6) THEN
				SET @digit_five := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_six := 0;
				SET @digit_seven := 0;
				SET @digit_eight := 0;
				SET @digit_nine := 0;
				SET @digit_ten := 0;
				SET @digit_eleven := 0;
				SET @digit_twelve := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_six AND @i < (LENGTH(current_line) - 5) THEN
				SET @digit_six := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_seven := 0;
				SET @digit_eight := 0;
				SET @digit_nine := 0;
				SET @digit_ten := 0;
				SET @digit_eleven := 0;
				SET @digit_twelve := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_seven AND @i < (LENGTH(current_line) - 4) THEN
				SET @digit_seven := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_eight := 0;
				SET @digit_nine := 0;
				SET @digit_ten := 0;
				SET @digit_eleven := 0;
				SET @digit_twelve := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_eight AND @i < (LENGTH(current_line) - 3) THEN
				SET @digit_eight := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_nine := 0;
				SET @digit_ten := 0;
				SET @digit_eleven := 0;
				SET @digit_twelve := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_nine AND @i < (LENGTH(current_line) - 2) THEN
				SET @digit_nine := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_ten := 0;
				SET @digit_eleven := 0;
				SET @digit_twelve := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_ten AND @i < (LENGTH(current_line) - 1) THEN
				SET @digit_ten := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_eleven := 0;
				SET @digit_twelve := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_eleven AND @i < LENGTH(current_line) THEN
				SET @digit_eleven := SUBSTRING(current_line, @i, 1) + 0;
				SET @digit_twelve := 0;
			ELSEIF SUBSTRING(current_line, @i, 1) + 0 > @digit_twelve THEN
				SET @digit_twelve := SUBSTRING(current_line, @i, 1) + 0;
			END IF;

			-- increment counter
			SET @i := @i + 1;
		END WHILE;

		-- add to result
		SET @result := @result + CONCAT(
			@digit_one,
			@digit_two,
			@digit_three,
			@digit_four,
			@digit_five,
			@digit_six,
			@digit_seven,
			@digit_eight,
			@digit_nine,
			@digit_ten,
			@digit_eleven,
			@digit_twelve
		);

	END LOOP;

	-- output result
	SELECT @result;

    -- close cursor
    CLOSE cur;
END$$

DELIMITER ;

-- call the stored procedure
CALL process_lines();