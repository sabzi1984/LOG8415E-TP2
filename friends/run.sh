#!/bin/bash

#Put data.txt to input directory
hdfs dfs -copyFromLocal -f data.txt input

#Remove output directory from hdfs
hdfs dfs -rm -r output

#Run job
hadoop jar friends.jar org.myorg.Friends input output

#Get output
hdfs dfs -copyToLocal -f output
