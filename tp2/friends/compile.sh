#!/bin/bash

${JAVA_HOME}/bin/javac -classpath `${HADOOP_HOME}/bin/hadoop classpath` -d classes Friends.java
${JAVA_HOME}/bin/jar -cvf friends.jar -C classes/ .

rm -rf classes/*
