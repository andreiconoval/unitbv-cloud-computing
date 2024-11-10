package net.examples;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;
import java.util.HashSet;
import java.util.StringTokenizer;


public class TFIDF {
    
    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();

        // Job 1: Term Frequency (TF)
        Job job1 = Job.getInstance(conf, "TF Calculation");
        job1.setJarByClass(TFIDF.class);
        job1.setMapperClass(TFMapper.class);
        job1.setReducerClass(TFReducer.class);
        job1.setOutputKeyClass(Text.class);
        job1.setOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job1, new Path(args[0]));
        FileOutputFormat.setOutputPath(job1, new Path(args[1]));
        job1.waitForCompletion(true);

        // Job 2: Document Frequency (DF)
        Job job2 = Job.getInstance(conf, "DF Calculation");
        job2.setJarByClass(TFIDF.class);
        job2.setMapperClass(DFMapper.class);
        job2.setReducerClass(DFReducer.class);
        job2.setOutputKeyClass(Text.class);
        job2.setOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job2, new Path(args[1]));
        FileOutputFormat.setOutputPath(job2, new Path(args[2]));
        job2.waitForCompletion(true);

        // Job 3: TF-IDF Calculation
        Job job3 = Job.getInstance(conf, "TF-IDF Calculation");
        job3.setJarByClass(TFIDF.class);
        job3.setMapperClass(TFIDFMapper.class);
        job3.setReducerClass(TFIDFReducer.class);
        job3.setOutputKeyClass(Text.class);
        job3.setOutputValueClass(Text.class);
        FileInputFormat.addInputPath(job3, new Path(args[2]));
        FileOutputFormat.setOutputPath(job3, new Path(args[3]));
        System.exit(job3.waitForCompletion(true) ? 0 : 1);
    }
}

