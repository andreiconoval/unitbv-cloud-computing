# Calculate Term Frequency
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -input dumas/ -output q4_output/tf \
    -file tf_mapper.py -mapper 'python3 tf_mapper.py' \
    -file tf_reducer.py -reducer 'python3 tf_reducer.py'

# Calculate Document Frequency
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -input q4_output/tf/ -output q4_output/df \
    -mapper 'python3 df_mapper.py' -reducer 'python3 df_reducer.py' \
    -file df_mapper.py -file df_reducer.py

# Calculate TF-IDF
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -input q4_output/tf/ -output q4_output/tfidf \
    -mapper tfidf_mapper.py -reducer NONE \
    -files q4_output/df/part-00000 


    cat ../text/Dumas-TheBorgias.txt | python3 tf_mapper.py | python3 tf_reducer.py | python3 df_mapper.py | python3 df_reducer.py | python3 tfidf_mapper.py 



    hadoop jar target/Maximum-1.0-SNAPSHOT.jar net.examples.TFIDF  dumas/  q4j_output_tf/ q4j_output_df/ q4j_output_tf_idf/




    hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar     -input dumas/ -output lab3/q4/tf     -file tf_mapper.py -mapper 'python3 tf_mapper.py'      -file tf_reducer.py -reducer 'python3 tf_reducer.py' -numReduceTasks 0

    hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar -input lab3/q4/tf -output lab3/q4/df   -mapper 'python3 df_mapper.py' -reducer 'python3 df_reducer.py' -file df_mapper.py -file df_reducer.py -numReduceTasks 0



        hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar -input lab3/q4/tf -output lab3/q4/df    -reducer 'python3 df_reducer.py' -file df_mapper.py -file df_reducer.py -numReduceTasks 0