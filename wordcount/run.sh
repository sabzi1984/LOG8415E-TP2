#!/bin/bash

for file in books/*.txt; do
    #Put file into input directory
    hdfs dfs -copyFromLocal -f $file input

    for i in {1..3}; do
        echo $(basename "$file") >> hadoop_time.txt | { time hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar wordcount input output >>hadoop_results.txt 2> hadoop.stderr; } 2>> hadoop_time.txt
        
        #Remove output directory
        hdfs dfs -rm -r output
    done

    hdfs dfs -rm input/*
done

