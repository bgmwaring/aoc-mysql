USE aoc;

-- load input
TRUNCATE TABLE input_lines;

LOAD DATA LOCAL INFILE 'inputs/day{day}.txt'
INTO TABLE input_lines
LINES TERMINATED BY '\n'
(line);

-- part 1
SELECT 'Part 1' AS section;

-- part 2
SELECT 'Part 2' AS section;