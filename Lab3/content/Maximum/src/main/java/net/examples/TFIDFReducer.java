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


public class TFIDFReducer extends Reducer<Text, Text, Text, Text> {
    private int totalDocuments = 1000; // Set total document count

    @Override
    protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
        int df = 0;
        HashSet<String> docCounts = new HashSet<>();

        for (Text val : values) {
            docCounts.add(val.toString());
        }
        df = docCounts.size();

        for (String docCount : docCounts) {
            String[] docTf = docCount.split("=");
            String documentId = docTf[0];
            int tf = Integer.parseInt(docTf[1]);
            double idf = Math.log((double) totalDocuments / (df + 1));
            double tfidf = tf * idf;

            context.write(new Text(documentId), new Text(key.toString() + "\t" + tfidf));
        }
    }
}