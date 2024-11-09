package net.examples;

import java.io.IOException;
import java.util.PriorityQueue;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Comparator;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.chain.ChainMapper;
import org.apache.hadoop.mapreduce.lib.chain.ChainReducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class MaximumU {

  public static class TokenizerMapper extends Mapper<Object, Text, Text, IntWritable> {
    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();

    public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
      Pattern pattern = Pattern.compile("[\\w]+");
      Matcher matcher = pattern.matcher(value.toString());

      while (matcher.find()) {
        word.set(matcher.group());
        context.write(word, one);
      }
    }
  }

  public static class IntSumReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
    private IntWritable result = new IntWritable();

    public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
      int sum = 0;
      for (IntWritable val : values) {
        sum += val.get();
      }
      result.set(sum);
      context.write(key, result);
    }
  }
  
  public static class TopKReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
    private PriorityQueue<Pair> queue;
    private int k;

    @Override
    protected void setup(Context context) throws IOException, InterruptedException {
      Configuration conf = context.getConfiguration();
      this.k = conf.getInt("topk", 5); // Default to top 5 if K is not provided

      // Priority queue for top K, with custom comparator to order by frequency
      this.queue = new PriorityQueue<>(Comparator.comparingInt(p -> p.frequency));
    }

    public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
      int sum = 0;
      for (IntWritable val : values) {
        sum += val.get();
      }

      // Maintain the top K elements in the priority queue
      queue.offer(new Pair(key.toString(), sum));
      if (queue.size() > k) {
        queue.poll(); // Remove smallest frequency if we exceed K elements
      }
    }

    @Override
    protected void cleanup(Context context) throws IOException, InterruptedException {
      // Output the top K elements in descending order
      while (!queue.isEmpty()) {
        Pair pair = queue.poll();
        context.write(new Text(pair.word), new IntWritable(pair.frequency));
      }
    }

    // Helper class to hold word-frequency pairs
    private static class Pair {
      String word;
      int frequency;

      Pair(String word, int frequency) {
        this.word = word;
        this.frequency = frequency;
      }
    }
  }

  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
    if (args.length > 2) {
        conf.setInt("topk", Integer.parseInt(args[2])); // Set K value from command line if provided
    }

    Job job = Job.getInstance(conf, "word count");

    // Add TokenizerMapper as the mapper for initial processing
    ChainMapper.addMapper(job, TokenizerMapper.class, 
        Object.class, Text.class, 
        Text.class, IntWritable.class, 
        new Configuration(false));

    // Set IntSumReducer as the reducer to aggregate word counts
    ChainReducer.setReducer(job, IntSumReducer.class, 
        Text.class, IntWritable.class, 
        Text.class, IntWritable.class, 
        new Configuration(false));

    // Set TopKReducer as the final reducer to extract the top K words
    job.setReducerClass(TopKReducer.class);

    job.setJarByClass(Maximum.class);
    job.setNumReduceTasks(1); // Ensure we only have one reducer for the final top K

    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
}
}
