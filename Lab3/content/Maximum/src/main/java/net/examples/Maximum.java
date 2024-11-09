package net.examples;

import java.io.IOException;
import java.util.StringTokenizer;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.TextInputFormat;
import org.apache.hadoop.mapred.TextOutputFormat;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.chain.ChainMapper;
import org.apache.hadoop.mapreduce.lib.chain.ChainReducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class Maximum {

  public static class TokenizerMapper
      extends Mapper<Object, Text, Text, IntWritable> {
    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();

    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException {
      Pattern pattern = Pattern.compile("[\\w]+");
      Matcher matcher = pattern.matcher(value.toString());

      for(int i=1; matcher.find();i++) {
        word.set(matcher.group());
        context.write(word, one);
      }
    }
  }

  public static class IntSumReducer
       extends Reducer<Text, IntWritable, Text, IntWritable> {
    private IntWritable result = new IntWritable();

    public void reduce(Text key, Iterable<IntWritable> values,
                       Context context
                       ) throws IOException, InterruptedException 
    {
      int sum = 0;
      for (IntWritable val : values) {
        sum += val.get();
      }
      result.set(sum);
      context.write(key, result);
    }
  }
  
  public static class MaximumMapper
      extends Mapper<Text, IntWritable, Text, IntWritable> {
	  
	String word; 
	static int maxval = 0;	
	
	public void map(Text key, IntWritable value, Context context
	                ) throws IOException, InterruptedException 
	{
		if (value.get() > maxval) {
			maxval = value.get();
			word = key.toString();
		}		
	}
	
	public void cleanup(Context context
            ) throws IOException, InterruptedException 
	{
		Text text = new Text(word);
		IntWritable result = new IntWritable(maxval);
		context.write(text, result);
	}
	
  }
  
  
  public static void main(String[] args) throws Exception {
	  
    Configuration conf = new Configuration();    
    Job job = Job.getInstance(conf, "word count");
    
    ChainMapper.addMapper(job, TokenizerMapper.class, 
    		Object.class, Text.class, 
    		Text.class, IntWritable.class, 
    		new Configuration(false));
    
    ChainReducer.setReducer(job, IntSumReducer.class, 
    		Text.class, IntWritable.class, 
    		Text.class, IntWritable.class,
    		new Configuration(false));
    
    ChainReducer.addMapper(job, MaximumMapper.class, 
    		Text.class, IntWritable.class,
    		Text.class, IntWritable.class,
    		new Configuration(false));
    
    job.setJarByClass(Maximum.class);
    
    //job.setMapperClass(TokenizerMapper.class);
    //job.setCombinerClass(IntSumReducer.class);
    //job.setReducerClass(IntSumReducer.class);
    
    job.setNumReduceTasks(10);
    //job.setOutputKeyClass(Text.class);
    //job.setOutputValueClass(IntWritable.class);
    
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    if (!job.waitForCompletion(true))
    	System.exit(1);

    System.out.println("Jobs completed.");
  }
}
