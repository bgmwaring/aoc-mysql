USE aoc;

-- load input
TRUNCATE TABLE input_lines;

LOAD DATA LOCAL INFILE 'inputs/day04.txt'
INTO TABLE input_lines
LINES TERMINATED BY '\n'
(line);

-- part 1
SELECT 'Part 1' AS section;

DELIMITER $$

DROP PROCEDURE IF EXISTS process_lines $$

CREATE PROCEDURE process_lines()
BEGIN
    -- ============================
    -- Declaring everything up front.
	--
	-- This is a different approach but I think is the correct approach. Using @var session variables
	-- within a procedure could cause issues.
    -- ============================
    DECLARE done INT DEFAULT 0;
    DECLARE current_line TEXT;
    DECLARE next_line TEXT; -- I waned to use 'inline' but it is a reserved keyword
    DECLARE last_line TEXT;

    DECLARE first_line INT DEFAULT 1;
    DECLARE final_line INT DEFAULT 0;

    DECLARE i INT;
    DECLARE above INT;
    DECLARE below INT;
    DECLARE next_to INT;
    DECLARE result INT DEFAULT 0;

    DECLARE cur CURSOR FOR SELECT line FROM input_lines;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

   -- open cursor and begin execution 
    OPEN cur;

    -- look ahead to next line
    FETCH cur INTO next_line;

    read_loop: LOOP

        -- shift next to current
        SET current_line = next_line;

        -- prefetch next row
        SET done = 0;
        FETCH cur INTO next_line;

        IF done = 1 THEN
			-- we are on the final line
            SET final_line = 1;
        END IF;

        -- process current_line
        SET i = 1;
        row_loop: WHILE i <= LENGTH(current_line) DO
			-- if current char is not @ then skip
			IF SUBSTRING(current_line, i, 1) != '@' THEN
				SET i = i + 1;
				ITERATE row_loop;
			END IF;

            SET above = 0;
            SET below = 0;
            SET next_to = 0;

            -- ABOVE
            IF first_line = 0 THEN
                IF i > 1 AND SUBSTRING(last_line, i - 1, 1) = '@' THEN SET above = above + 1; END IF;
                IF SUBSTRING(last_line, i, 1) = '@' THEN SET above = above + 1; END IF;
                IF i < LENGTH(current_line) AND SUBSTRING(last_line, i + 1, 1) = '@' THEN SET above = above + 1; END IF;
            END IF;

            -- INLINE
            IF i > 1 AND SUBSTRING(current_line, i - 1, 1) = '@' THEN SET next_to = next_to + 1; END IF;
            IF i < LENGTH(current_line) AND SUBSTRING(current_line, i + 1, 1) = '@' THEN SET next_to = next_to + 1; END IF;

            -- BELOW
            IF final_line = 0 THEN
                IF i > 1 AND SUBSTRING(next_line, i - 1, 1) = '@' THEN SET below = below + 1; END IF;
                IF SUBSTRING(next_line, i, 1) = '@' THEN SET below = below + 1; END IF;
                IF i < LENGTH(current_line) AND SUBSTRING(next_line, i + 1, 1) = '@' THEN SET below = below + 1; END IF;
            END IF;

            -- update result
            IF (above + next_to + below) < 4 THEN
                SET result = result + 1;
            END IF;

            SET i = i + 1;
        END WHILE;

        -- move current line to last_line
        SET last_line = current_line;
        SET first_line = 0;

        IF final_line = 1 THEN
            LEAVE read_loop;
        END IF;

    END LOOP;

    CLOSE cur;

    SELECT result AS result;

END $$

DELIMITER ;


-- call the stored procedure
CALL process_lines();

-- part 2
SELECT 'Part 2' AS section;

DELIMITER $$

DROP PROCEDURE IF EXISTS process_lines $$

CREATE PROCEDURE process_lines()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE current_line_no INT;
    DECLARE current_line TEXT;
    DECLARE next_line TEXT; -- I waned to use 'inline' but it is a reserved keyword
    DECLARE last_line TEXT;

    DECLARE first_line INT DEFAULT 1;
    DECLARE final_line INT DEFAULT 0;

    DECLARE i INT;
    DECLARE above INT;
    DECLARE below INT;
    DECLARE next_to INT;

    DECLARE cur CURSOR FOR SELECT line FROM input_lines;
	DECLARE cur_index CURSOR FOR SELECT line_no FROM input_lines;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

   -- open cursors and begin execution 
    OPEN cur;
    OPEN cur_index;

    -- look ahead to next line
    FETCH cur INTO next_line;

    read_loop: LOOP
		FETCH cur_index INTO current_line_no;

        -- shift next to current
        SET current_line = next_line;

        -- prefetch next row
        SET done = 0;
        FETCH cur INTO next_line;

        IF done = 1 THEN
			-- we are on the final line
            SET final_line = 1;
        END IF;

        -- process current_line
        SET i = 1;
        row_loop: WHILE i <= LENGTH(current_line) DO
			-- if current char is not @ then skip
			IF SUBSTRING(current_line, i, 1) != '@' THEN
				SET i = i + 1;
				ITERATE row_loop;
			END IF;

            SET above = 0;
            SET below = 0;
            SET next_to = 0;

            -- ABOVE
            IF first_line = 0 THEN
                IF i > 1 AND SUBSTRING(last_line, i - 1, 1) = '@' THEN SET above = above + 1; END IF;
                IF SUBSTRING(last_line, i, 1) = '@' THEN SET above = above + 1; END IF;
                IF i < LENGTH(current_line) AND SUBSTRING(last_line, i + 1, 1) = '@' THEN SET above = above + 1; END IF;
            END IF;

            -- INLINE
            IF i > 1 AND SUBSTRING(current_line, i - 1, 1) = '@' THEN SET next_to = next_to + 1; END IF;
            IF i < LENGTH(current_line) AND SUBSTRING(current_line, i + 1, 1) = '@' THEN SET next_to = next_to + 1; END IF;

            -- BELOW
            IF final_line = 0 THEN
                IF i > 1 AND SUBSTRING(next_line, i - 1, 1) = '@' THEN SET below = below + 1; END IF;
                IF SUBSTRING(next_line, i, 1) = '@' THEN SET below = below + 1; END IF;
                IF i < LENGTH(current_line) AND SUBSTRING(next_line, i + 1, 1) = '@' THEN SET below = below + 1; END IF;
            END IF;

            -- update result
            IF (above + next_to + below) < 4 THEN
				-- adjust table to remove this @ (this won't work if two lines are the same...)
				UPDATE input_lines
				SET line = CONCAT(SUBSTRING(line, 1, i - 1), 'x', SUBSTRING(line, i + 1))
				WHERE line_no = current_line_no;

                SET @result = @result + 1;
            END IF;

            SET i = i + 1;
        END WHILE;

        -- move current line to last_line
        SET last_line = current_line;
        SET first_line = 0;

        IF final_line = 1 THEN
            LEAVE read_loop;
        END IF;

    END LOOP;

    CLOSE cur;
    CLOSE cur_index;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS run_loop $$

CREATE PROCEDURE run_loop()
BEGIN
    DECLARE start_result INT DEFAULT @result;

    result_loop: WHILE TRUE DO
        SET start_result := @result;
        CALL process_lines();  -- should modify @result

        -- if no change we are done so exit loop
        IF @result = start_result THEN
            LEAVE result_loop;
        END IF;
    END WHILE;

    -- output result
    SELECT @result;
END $$

DELIMITER ;

SET @result := 0;
CALL run_loop();