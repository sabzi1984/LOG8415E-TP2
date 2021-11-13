import pyspark
from pyspark.sql import SparkSession
from pyspark import SparkFiles, SparkContext, SparkConf
from time import process_time
import sys
import csv
import os

start_time=process_time()

def map_words(row):

    words = row[0].split(' ') 
    for w in words:
        yield (w, 1)

def reduce_words(value1, value2):
    return value1+value2


filename = sys.argv[1]

# conf = SparkConf().setAppName("wordcount").setMaster("spark://192.168.1.10:7077")
# sc = SparkContext(conf=conf)
# spark = SparkSession.builder.config(conf=conf).getOrCreate()
spark = SparkSession.builder.getOrCreate()
book = spark.read.csv(filename, header=False)
# start_add_file_time = time.time()

book_rdd = book.rdd

book_rdd = book_rdd.flatMap(map_words)
# print(book1_rdd.collect())

book_rdd = book_rdd.reduceByKey(reduce_words)
# print(book1_rdd.collect())

book_rdd.toDF(["word", "count_word"]).show()
# yield(book_rdd.toDF(["word", "count_word"]))
end_time=st=process_time()
print(os.path.basename(filename),'\t',end_time-start_time)