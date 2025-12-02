USE aoc;

-- load input
TRUNCATE TABLE input_lines;

LOAD DATA LOCAL INFILE 'inputs/day01.txt'
INTO TABLE input_lines
LINES TERMINATED BY '\n'
(line);

-- part 1
SELECT 'Part 1' AS section;
SET @current = 50;
SELECT
	count(*)
FROM
	input_lines
WHERE 
	IF(
		SUBSTRING(line, 1, 1) = 'R',
		IF(
			@current + MOD(SUBSTRING(line, 2), 100) > 99,
			@current := @current + MOD(SUBSTRING(line, 2), 100) - 100,
			@current := @current + MOD(SUBSTRING(line, 2), 100)
		),
		IF(
			@current - MOD(SUBSTRING(line, 2), 100) < 0,
			@current := @current - MOD(SUBSTRING(line, 2), 100) + 100,
			@current := @current - MOD(SUBSTRING(line, 2), 100)
		)
	) = 0;

-- part 2
SELECT 'Part 2' AS section;

-- initialize session variables
SET @counter = 50;
SET @hit = 0;

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
    
    read_loop: LOOP
        FETCH cur INTO current_line;
        IF done THEN
            LEAVE read_loop;
        END IF;

		SET @steps = SUBSTRING(current_line,2);
		SET @full_cycles = @steps DIV 100;

		-- process through line and adjust counters
        IF SUBSTRING(current_line,1,1) = 'R' THEN
			IF @counter + MOD(@steps,100) > 99 THEN
				SET @hit := @hit + 1;
				SET @counter := @counter + MOD(@steps,100) - 100;
			ELSE
				SET @counter := @counter + MOD(@steps,100);
			END IF;
        ELSE
			IF @counter - MOD(@steps,100) < 0 THEN
				-- if we started on 0 then we have already counted that hit
				IF @counter != 0 THEN SET @hit := @hit + 1; END IF;
				SET @counter := @counter - MOD(@steps,100) + 100;
			ELSEIF @counter - MOD(@steps,100) = 0 THEN
				SET @counter := 0;
				-- ending on 0 so count hit
				SET @hit := @hit + 1;
			ELSE
				SET @counter := @counter - MOD(@steps,100);
			END IF;
        END IF;

		-- accounts for full loops
		SET @hit := @hit + @full_cycles;
    END LOOP;

    -- close cursor
    CLOSE cur;

	-- output result
	SELECT @hit;
END$$

DELIMITER ;

-- Call the stored procedure
CALL process_lines();