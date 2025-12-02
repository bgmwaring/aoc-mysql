#!/bin/bash

DAY=$(printf "%02d" "$1")

if [ -z "$1" ]; then
	echo "Usage: ./run.sh <day>"
	exit 1
fi

FILE="sql/day${DAY}.sql"

if [ ! -f "$FILE" ]; then
	echo "File $FILE does not exist"
	exit 1
fi

echo "Running Advent of Code day $DAY..."
echo "----------------------------------"

mysql -u root --local-infile=1 < "$FILE"