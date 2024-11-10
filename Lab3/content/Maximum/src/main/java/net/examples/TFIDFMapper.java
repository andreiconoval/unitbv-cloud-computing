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


public class TFIDFMapper extends Mapper<LongWritable, Text, Text, Text> {
    private Text word = new Text();
    private Text docAndCount = new Text();

    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String[] parts = value.toString().split("\t");
        if (parts.length < 2) return;

        String[] wordDoc = parts[0].split("@");
        if (wordDoc.length < 2) return;

        word.set(wordDoc[0]);
        docAndCount.set(wordDoc[1] + "=" + parts[1]); // Output format: "word -> documentID=TF"
        context.write(word, docAndCount);
    }
}


