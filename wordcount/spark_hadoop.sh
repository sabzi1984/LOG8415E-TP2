#!/bin/bash
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install git
sudo git clone https://github.com/sabzi1984/pyspark_wordcount.git

sudo apt install python3 python3-pip -y

sudo apt-get install openjdk-8-jdk -y
sudo pip3 install pyspark
sudo apt-get install ssh
# sudo apt-get install pdsh -y #do not install pdsh will encounter problem when starting dfs



# after java installation

echo JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/environment
source /etc/environment
echo source /etc/environment >>~/.bashrc

#spark installation
wget https://dlcdn.apache.org/spark/spark-3.2.0/spark-3.2.0-bin-hadoop3.2.tgz
sudo tar -zxvf spark-3.2.0-bin-hadoop3.2.tgz


#moving spark installation
mv spark-3.2.0-bin-hadoop3.2 spark-hadoop3
sudo mv spark-hadoop3/ /usr/share/


#environment variables for spark
echo export SPARK_HOME=/usr/share/spark-hadoop3 >>~/.bashrc
echo export PATH=$PATH:$SPARK_HOME/bin >>~/.bashrc
echo export PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH >>~/.bashrc
echo export PYSPARK_PYTHON=python3 >>~/.bashrc
echo export PATH=$PATH:$JAVA_HOME/jre/bin >>~/.bashrc

/usr/share/spark-hadoop3/python



#installing hadoop
sudo wget http://www.gtlib.gatech.edu/pub/apache/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz
sudo tar -xvf hadoop-3.3.0.tar.gz

#moving hadoop installation
sudo mv hadoop-3.3.0 hadoop
sudo mv hadoop/ /usr/share/

#Defining hadoop environment
echo export HADOOP_PREFIX=/usr/share/hadoop >>~/.bashrc
echo export PATH=$HADOOP_PREFIX/bin:$PATH >>~/.bashrc
source ~/.bashrc

#/usr/share/hadoop/etc/hadoop/hadoop-env.sh

#make sure hadoop working in stanalone mode
cd /usr/share/hadoop
sudo bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.0.jar pi 16 1000
#time for i in {1..3}; do sudo bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.0.jar pi 16 1000; done

#Hadoop Pseudo-Distributed Mode

sudo chmod -R 777 /usr/local/hadoop


# HADOOP ENVIRONMENT
echo export HADOOP_HOME=/usr/share/hadoop >> ~/.bashrc
echo export HADOOP_CONF_DIR=/usr/share/hadoop/etc/hadoop >> ~/.bashrc
echo export HADOOP_MAPRED_HOME=/usr/share/hadoop >> ~/.bashrc
echo export HADOOP_COMMON_HOME=/usr/share/hadoop >> ~/.bashrc
echo export HADOOP_HDFS_HOME=/usr/share/hadoop >> ~/.bashrc
echo export YARN_HOME=/usr/share/hadoop >> ~/.bashrc
echo export PATH=$PATH:/usr/share/hadoop/bin >> ~/.bashrc
echo export PATH=$PATH:/usr/share/hadoop/sbin >> ~/.bashrc
# HADOOP NATIVE PATH
echo export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native >> ~/.bashrc
echo export HADOOP_OPTS=-Djava.library.path=$HADOOP_PREFIX/lib >> ~/.bashrc

source ~/.bashrc

cd /usr/share/hadoop/etc/hadoop/
sudo vi hadoop-env.sh
export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export HADOOP_HOME_WARN_SUPPRESS="TRUE"
export HADOOP_ROOT_LOGGER="WARN,DRFA"

sudo nano yarn-site.xml
#Add the following configurations between the configuration tag
<property>
<name>yarn.nodemanager.aux-services</name>
<value>mapreduce_shuffle</value>
</property>
<property>
<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
<value>org.apache.hadoop.mapred.ShuffleHandler</value>
</property>


sudo nano hdfs-site.xml

#Add the following configurations between the configuration tag (<configuration></configuration>)
<property>
<name>dfs.replication</name>
<value>1</value>
</property>
<property>
<name>dfs.namenode.name.dir</name>
<value>/usr/local/hadoop/yarn_data/hdfs/namenode</value>
</property>
<property>
<name>dfs.datanode.data.dir</name>
<value>/usr/local/hadoop/yarn_data/hdfs/datanode</value>
</property>
<property>
<name>dfs.namenode.http-address</name>
<value>localhost:50070</value>
</property>

sudo nano core-site.xml

#Add the following configurations between the configuration tag (<configuration></configuration>)
<property>
<name>hadoop.tmp.dir</name>
<value>/bigdata/hadoop/tmp</value>
</property>
<property>
<name>fs.default.name</name>
<value>hdfs://localhost:9000</value>
</property>

sudo nano mapred-site.xml
#Add the following configurations between the configuration tag (<configuration></configuration>)
<property>
<name>mapred.framework.name</name>
<value>yarn</value>
</property>
<property>
<name>mapreduce.jobhistory.address</name>
<value>localhost:10020</value>
</property>

#Generating Keys
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod og-wx ~/.ssh/authorized_keys

#ormat the HDFS file system
hdfs namenode -format
#create directory /tmp/boooks to save books
sudo mkdir ~/books
#download books to /tmp/boooks
sudo wget -P ~/books http://www.gutenberg.ca/ebooks/buchanj-midwinter/buchanj-midwinter-00-t.txt
sudo wget -P ~/books http://www.gutenberg.ca/ebooks/carman-farhorizons/carman-farhorizons-00-t.txt
sudo wget -P ~/books http://www.gutenberg.ca/ebooks/colby-champlain/colby-champlain-00-t.txt
sudo wget -P ~/books http://www.gutenberg.ca/ebooks/cheyneyp-darkbahama/cheyneyp-darkbahama-00-t.txt

sudo wget -P ~/books http://www.gutenberg.ca/ebooks/delamare-bumps/delamare-bumps-00-t.txt
sudo wget -P ~/books http://www.gutenberg.ca/ebooks/charlesworth-scene/charlesworth-scene-00-t.txt
sudo wget -P ~/books http://www.gutenberg.ca/ebooks/delamare-lucy/delamare-lucy-00-t.txt

sudo wget -P ~/books http://www.gutenberg.ca/ebooks/delamare-myfanwy/delamare-myfanwy-00-t.txt
sudo wget -P ~/books http://www.gutenberg.ca/ebooks/delamare-penny/delamare-penny-00-t.txt

cd /usr/share/hadoop
hdfs dfs -copyFromLocal ~/books /books

#director of hadoop-streaming.jar
#find / -name 'hadoop-streaming*.jar'
/home/hdoop/hadoop-3.3.0/share/hadoop/tools/lib/hadoop-streaming-3.3.0.jar
#mapreduce
hdfs jar /home/hdoop/hadoop-3.3.0/share/hadoop/tools/lib/hadoop-streaming-3.3.0.jar \
-file ~/pyspark_wordcount/mapper_had.py    -mapper ~/pyspark_wordcount/mapper_had.py \
-file ~/pyspark_wordcount/reducer_had.py   -reducer ~/pyspark_wordcount/reducer_had.py \
-input /books/* -output /books-had-output

hadoop jar share/hadoop/tools/lib/hadoop-streaming-3.3.0.jar -mapper /pyspark_wordcount/mapper_had.py -reducer /pyspark_wordcount/reducer_had.py -input /books/* -output /books-had-output
#check the result

hdfs dfs -ls /books-had-output

#running python code for wordcount
echo "WordCount Using Pyspark"
# sudo python3 /pyspark_wordcount/spark_wordCount.py
chown -R $USER:$USER /pyspark_wordcount
time for i in {1..3}; do sudo python3 /pyspark_wordcount/spark_wordCount.py>/pyspark_wordcount/pyspark_wordcount_result.txt; done
# vim pyspark_wordcount_result.txt



echo "foo foo quux labs foo bar quux" | /pyspark_wordcount/mapper_had.py | sort -k1,1 | /pyspark_wordcount/reducer_had.py

git reset --hard HEAD
git pull

for file in ~/books/*.txt; do time python3 pysp_wordcount.py "$file"; done
for file in ~/books/*.txt; do for i in {1..3}; do time python3 pysp_wordcount.py "$file">>spark_results.txt; done;done
for file in ~/books/*.txt; do for i in {1..3}; do { time python3 pysp_wordcount.py "$file">>spark_results.txt 2> spark.stderr; } 2>>spark_time.txt ;done ;done
for file in ~/books/*.txt; do for i in {1..3}; do echo $(basename "$file") >>spark_time.txt| { time python3 pysp_wordcount.py "$file">>spark_results.txt 2> spark.stderr; } 2>>spark_time.txt ;done ;done

start-dfs.sh
start-yarn.sh
cp /pyspark_wordcount/mapper_had.py namenode:mapper_had.py
cp /pyspark_wordcount/reducer_had.py namenode:reducer_had.py

hadoop jar /home/hdoop/hadoop-3.3.0/share/hadoop/tools/lib/hadoop-streaming-3.3.0.jar -mapper /pyspark_wordcount/mapper_had.py -reducer /pyspark_wordcount/reducer_had.py -input /books/* -output /books-had-output

hadoop jar /home/hdoop/hadoop-3.3.0/share/hadoop/tools/lib/hadoop-streaming-3.3.0.jar \
-file /pyspark_wordcount/mapper_had.py    -mapper /pyspark_wordcount/mapper_had.py \
-file /pyspark_wordcount/reducer_had.py   -reducer /pyspark_wordcount/reducer_had.py \
-input /books -output output
#make the directory sudo nano 
sudo chmod -R 777 /pyspark_wordcount
for file in ~/books/*.txt; do for i in {1..3}; do echo $(basename "$file") >>spark_time.txt| { time spark-submit pysp_wordcount.py "$file">>spark_results.txt 2> spark.stderr; } 2>>spark_time.txt ;done ;done

for file in ~/books/*.txt; do for i in {1..3}; do echo $(basename "$file") >>spark_time.txt| { time spark-submit /pyspark_wordcount/pysp_wordcount.py "$file"  >>spark_results.txt 2> spark.stderr; } 2>>spark_time.txt ;done ;done

sed -i -e 's/\r$//' mapper_had.py
sed -i -e 's/\r$//' reducer_had.py

hadoop jar /home/hdoop/hadoop-3.3.0/share/hadoop/tools/lib/hadoop-streaming-3.3.0.jar -file ~/pyspark_wordcount/mapper_had.py    -mapper ~/pyspark_wordcount/mapper_had.py -file ~/pyspark_wordcount/reducer_had.py   -reducer ~/pyspark_wordcount/reducer_had.py -input /books/* -output /books-had-output

for file in hadoop dfs /books/*.txt; do for i in {1..3}; do echo $(basename "$file") >>hadoop_time.txt| { time hadoop jar /home/hdoop/hadoop-3.3.0/share/hadoop/tools/lib/hadoop-streaming-3.3.0.jar -mapper /pyspark_wordcount/mapper_had.py -reducer /pyspark_wordcount/reducer_had.py -input "$file" -output /books-had-output_2; } 2>>hadoop_time.txt ;done ;done


python3 ~/pyspark_wordcount/pysp_wordcount.py ~/books/buchanj-midwinter-00-t.txt