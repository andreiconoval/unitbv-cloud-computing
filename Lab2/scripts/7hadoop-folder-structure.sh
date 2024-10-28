
# Create the required directory structure for Hadoop
echo "Creating directory structure..."
mkdir -p "$HOME/apps/hadoop/hadoopdata/hdfs/namenode"
mkdir -p "$HOME/apps/hadoop/hadoopdata/hdfs/datanode"
mkdir -p "$HOME/apps/hadoop/cache"
mkdir -p "$HOME/apps/hadoop/logs"
mkdir -p "$HOME/apps/hadoop/tmp"
mkdir -p "$HOME/apps/hadoop/input"

echo "Directory structure has been created successfully."
