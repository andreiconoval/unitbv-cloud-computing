
# Search for java-11-openjdk in /usr/lib/jvm/
JAVA_DIR=$(ls -d /usr/lib/jvm/java-11-openjdk* 2>/dev/null | head -n 1)

# Check if Java was found
if [ -z "$JAVA_DIR" ]; then
  echo "java-11-openjdk not found in /usr/lib/jvm/"
  exit 1
else
  echo "Found java-11-openjdk at: $JAVA_DIR"
fi

# Path to the Hadoop configuration file
HADOOP_ENV_FILE="$HOME/user/apps/hadoop/etc/hadoop/hadoop-env.sh"

# Check if the hadoop-env.sh file exists
if [ ! -f "$HADOOP_ENV_FILE" ]; then
  echo "hadoop-env.sh not found at $HADOOP_ENV_FILE"
  exit 1
fi

# Check if JAVA_HOME is set or commented out in the hadoop-env.sh file
if grep -q "^#.*export JAVA_HOME=" "$HADOOP_ENV_FILE"; then
  echo "Found commented JAVA_HOME, uncommenting and updating in $HADOOP_ENV_FILE"
  # Use sed to uncomment and replace the existing JAVA_HOME with the new one
  sed -i "s|^#.*export JAVA_HOME=.*|export JAVA_HOME=\"$JAVA_DIR\"|" "$HADOOP_ENV_FILE"
  echo "JAVA_HOME uncommented and updated to: $JAVA_DIR"
elif grep -q "^export JAVA_HOME=" "$HADOOP_ENV_FILE"; then
  echo "JAVA_HOME is already set, updating it in $HADOOP_ENV_FILE"
  # Use sed to update the existing JAVA_HOME line
  sed -i "s|^export JAVA_HOME=.*|export JAVA_HOME=\"$JAVA_DIR\"|" "$HADOOP_ENV_FILE"
  echo "JAVA_HOME updated to: $JAVA_DIR"
else
  echo "JAVA_HOME is not set. Adding it to $HADOOP_ENV_FILE"
  # Append the JAVA_HOME variable to the hadoop-env.sh file
  echo -e "\n# Set JAVA_HOME for Hadoop" >> "$HADOOP_ENV_FILE"
  echo "export JAVA_HOME=\"$JAVA_DIR\"" >> "$HADOOP_ENV_FILE"
  echo "JAVA_HOME added successfully."
fi

# Add HDFS and YARN user environment variables
if ! grep -q "^export HDFS_NAMENODE_USER=" "$HADOOP_ENV_FILE"; then
  echo "Setting HDFS and YARN user variables in $HADOOP_ENV_FILE"
  echo "export HDFS_NAMENODE_USER=root" >> "$HADOOP_ENV_FILE"
  echo "export HDFS_DATANODE_USER=root" >> "$HADOOP_ENV_FILE"
  echo "export HDFS_SECONDARYNAMENODE_USER=root" >> "$HADOOP_ENV_FILE"
  echo "export YARN_RESOURCEMANAGER_USER=root" >> "$HADOOP_ENV_FILE"
  echo "export YARN_NODEMANAGER_USER=root" >> "$HADOOP_ENV_FILE"
  echo "HDFS and YARN user variables added successfully."
else
  echo "HDFS and YARN user variables are already set in $HADOOP_ENV_FILE"
fi