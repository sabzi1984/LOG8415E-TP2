package org.myorg;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapred.*;
import org.apache.hadoop.util.*;

public class Friends {

  public static class Map extends MapReduceBase implements Mapper<LongWritable, Text, Text, Text> {
    private final static IntWritable one = new IntWritable(1);
    private final static IntWritable negative = new IntWritable(-2147483648);

    public void map(LongWritable key, Text value, OutputCollector<Text, Text> output, Reporter reporter)
        throws IOException {
      String line[] = value.toString().split("\t");
      Long fromUser = Long.parseLong(line[0]);
      List<Long> toUsers = new ArrayList<Long>();
      Text tuple = new Text();

      if (line.length == 2) {
        StringTokenizer tokenizer = new StringTokenizer(line[1], ",");
        while (tokenizer.hasMoreTokens()) {
          Long toUser = Long.parseLong(tokenizer.nextToken());
          toUsers.add(toUser);
          tuple.set(toUser.toString() + "," + negative.toString());
          output.collect(new Text(fromUser.toString()), tuple);
        }

        for (int i = 0; i < toUsers.size(); i++) {
          for (int j = i + 1; j < toUsers.size(); j++) {
            tuple.set(toUsers.get(j).toString() + "," + one.toString());
            output.collect(new Text(toUsers.get(i).toString()), tuple);

            tuple.set(toUsers.get(i).toString() + "," + one.toString());
            output.collect(new Text(toUsers.get(j).toString()), tuple);
          }
        }
      }
    }
  }

  public static class Reduce extends MapReduceBase implements Reducer<Text, Text, Text, Text> {
    HashMap<Text, HashMap<String, Integer>> map = new HashMap<>();

    private static HashMap<String, Integer> sortByValueDesc(HashMap<String, Integer> unsortMap)
    {
        List<java.util.Map.Entry<String, Integer>> list = new LinkedList<>(unsortMap.entrySet());

        // Sorting the list based on values
        list.sort((o1, o2) -> o2.getValue().compareTo(o1.getValue()));
        return list.stream().collect(Collectors.toMap(java.util.Map.Entry::getKey, java.util.Map.Entry::getValue, (a, b) -> b, LinkedHashMap::new));
    }

    public void reduce(Text key, Iterator<Text> values, OutputCollector<Text, Text> output, Reporter reporter)
        throws IOException {

      if (map.get(key) == null)
        map.put(key, new HashMap<>());

      while (values.hasNext()) {
        String tuple[] = values.next().toString().split(",");

        if (tuple.length == 2) {

        String potentialFriend = tuple[0];
        int value = Integer.parseInt(tuple[1]);

        if (!map.get(key).containsKey(potentialFriend))
          map.get(key).put(potentialFriend, value);
        
        else {
            int t = map.get(key).get(potentialFriend);
            map.get(key).put(potentialFriend, t + value);
          }
        }
      }

      //Filter
      HashMap<String, Integer> filtered = new HashMap<>();

      for (java.util.Map.Entry<String, Integer> f : map.get(key).entrySet()) {
        if (f.getValue() > 0) {
          filtered.put(f.getKey(), f.getValue());
        }
      }

      //Sort
      HashMap<String, Integer> sorted = sortByValueDesc(filtered);
      
      map.put(key, sorted);

      //TOP 10
      String suggestions = String.join(",", map.get(key).keySet().stream().limit(10).collect(Collectors.toList()));

      output.collect(key, new Text(suggestions));
    }

  }

  public static void main(String[] args) throws Exception {
    JobConf conf = new JobConf(Friends.class);
    conf.setJobName("friends");

    conf.setOutputKeyClass(Text.class);
    conf.setOutputValueClass(Text.class);

    conf.setMapperClass(Map.class);
    conf.setReducerClass(Reduce.class);

    conf.setInputFormat(TextInputFormat.class);
    conf.setOutputFormat(TextOutputFormat.class);

    FileInputFormat.setInputPaths(conf, new Path(args[0]));
    FileOutputFormat.setOutputPath(conf, new Path(args[1]));

    JobClient.runJob(conf);
  }
}
