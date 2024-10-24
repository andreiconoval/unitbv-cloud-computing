# Navigate to the Hadoop bin directory
cd "$HOME/user/apps/hadoop"

# Check if the bin/hdfs command exists
if [ ! -f "bin/hdfs" ]; then
  echo "Hadoop HDFS command not found in $HOME/user/apps/hadoop/bin"
  exit 1
fi

# Format the HDFS namenode and respond with "yes" automatically
echo "Formatting HDFS Namenode..."
yes | bin/hdfs namenode -format

echo "HDFS Namenode formatted successfully."
