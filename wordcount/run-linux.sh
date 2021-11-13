#!/bin/bash

for file in books/*.txt; do
    for i in {1..3}; do
        echo $(basename "$file") >> linux_time.txt | { time tr ' ' '\n' < $file | sort | uniq -c >> linux_tf.txt ; } 2>> linux_time.txt
    done
done
