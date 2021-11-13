#!/bin/bash

for file in books/*.txt; do
    for i in {1..3}; do
        echo $(basename "$file") >> spark_time.txt | { time run-example JavaWordCount "$file" >> spark.log ; } 2>> spark_time.txt
    done
done

