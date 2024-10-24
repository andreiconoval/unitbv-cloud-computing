
# Create the required directory structure for Hadoop
echo "Creating directory structure..."
mkdir -p "$HOME/user/apps/hadoop/hadoopdata/hdfs/namenode"
mkdir -p "$HOME/user/apps/hadoop/hadoopdata/hdfs/datanode"
mkdir -p "$HOME/user/apps/hadoop/cache"
mkdir -p "$HOME/user/apps/hadoop/logs"
mkdir -p "$HOME/user/apps/hadoop/tmp"
mkdir -p "$HOME/user/apps/hadoop/input"

echo "Directory structure has been created successfully."
