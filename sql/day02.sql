USE aoc;

-- load input
TRUNCATE TABLE input_lines;

LOAD DATA LOCAL INFILE 'inputs/day02.txt'
INTO TABLE input_lines
LINES TERMINATED BY ','
(line);

-- part 1
SELECT 'Part 1' AS section;

DELIMITER $$

DROP PROCEDURE IF EXISTS process_lines;
CREATE PROCEDURE process_lines()
BEGIN
    -- declare variables
    DECLARE done INT DEFAULT 0;
    DECLARE current_line VARCHAR(100);
    
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

		-- pull apart the range from the lines 
		SET @start =  REGEXP_SUBSTR(current_line, '[^-]+', 1, 1) + 0;
		SET @end =  REGEXP_SUBSTR(current_line, '[^-]+', 1, 2) + 0;

		-- declare counter to keep track of loop
		SET @counter := @start;

		-- loop through range
		WHILE @counter <= @end DO
			-- skip if there is an odd number of digits
			IF LENGTH(@counter) % 2 = 0 THEN
				-- pull the digit into it's two halves
				SET @first_half = SUBSTRING(@counter, 1, LENGTH(@counter) / 2);
				SET @second_half = SUBSTRING(@counter, (LENGTH(@counter) / 2) + 1);

				-- add id to result if the two halves are the same
				IF @first_half = @second_half THEN
					SET @result := @result + @counter;
				END IF;
			END IF;
			
			-- increment counter
			SET @counter := @counter + 1;
		END WHILE;
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
    DECLARE current_line VARCHAR(100);
    
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

		-- pull apart the range from the lines 
		SET @start =  REGEXP_SUBSTR(current_line, '[^-]+', 1, 1) + 0;
		SET @end =  REGEXP_SUBSTR(current_line, '[^-]+', 1, 2) + 0;

		-- declare counter to keep track of loop
		SET @counter := @start;

		-- loop through range
		WHILE @counter <= @end DO
			SET @i := 1;

			counter_loop: WHILE @i <= LENGTH(@counter) / 2 DO
				IF LENGTH(@counter) % @i = 0 THEN
					SET @part = LEFT(@counter, @i);
					IF REPEAT(@part, LENGTH(@counter) / @i) = @counter THEN
						SET @result := @result + @counter;

						-- leave while loop to avoid double counts
						LEAVE counter_loop;
					END IF;
				END IF;

				SET @i := @i + 1;
			END WHILE;

			-- increment counter
			SET @counter := @counter + 1;
		END WHILE;
	END LOOP;

	-- output result
	SELECT @result;

    -- close cursor
    CLOSE cur;
END$$

DELIMITER ;

-- call the stored procedure
CALL process_lines();