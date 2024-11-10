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

public class TFMapper extends Mapper<LongWritable, Text, Text, IntWritable> {
    private final static IntWritable one = new IntWritable(1);
    private Text wordWithDoc = new Text();

    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        // Assume input format is "documentID\ttext"
        String[] parts = value.toString().split("\t", 2);
        if (parts.length < 2) return;

        String documentId = parts[0];
        String text = parts[1];

        StringTokenizer tokenizer = new StringTokenizer(text);
        while (tokenizer.hasMoreTokens()) {
            String word = tokenizer.nextToken().replaceAll("\\W", "").toLowerCase();
            if (!word.isEmpty()) {
                wordWithDoc.set(word + "@" + documentId);
                context.write(wordWithDoc, one);
            }
        }
    }
}
