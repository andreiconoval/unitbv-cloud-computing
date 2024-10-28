
#!/bin/bash

# Path to the yarn-site.xml file
YARN_SITE_FILE="$HOME/user/apps/hadoop/etc/hadoop/yarn-site.xml"

# Check if the yarn-site.xml file exists
if [ ! -f "$YARN_SITE_FILE" ]; then
  echo "yarn-site.xml not found at $YARN_SITE_FILE"
  exit 1
fi

# Backup the original yarn-site.xml before modifying
cp "$YARN_SITE_FILE" "$YARN_SITE_FILE.bak"
echo "Backup of yarn-site.xml created at $YARN_SITE_FILE.bak"

# Check if the <configuration> block already exists
if grep -q "<configuration>" "$YARN_SITE_FILE"; then
  echo "<configuration> block found in $YARN_SITE_FILE"
else
  echo "<configuration> block not found, adding it."
  echo "<configuration>" > "$YARN_SITE_FILE"
  echo "</configuration>" >> "$YARN_SITE_FILE"
fi

# Insert or update the required properties
if grep -q "<name>yarn.nodemanager.aux-services</name>" "$YARN_SITE_FILE"; then
  echo "Updating yarn.nodemanager.aux-services property in $YARN_SITE_FILE"
  sed -i '/<name>yarn.nodemanager.aux-services<\/name>/!b;n;c<value>mapreduce_shuffle</value>' "$YARN_SITE_FILE"
else
  echo "Adding yarn.nodemanager.aux-services property to $YARN_SITE_FILE"
  sed -i '/<configuration>/a \
  <property>\n\
  <name>yarn.nodemanager.aux-services</name>\n\
  <value>mapreduce_shuffle</value>\n\
  </property>' "$YARN_SITE_FILE"
fi

if grep -q "<name>yarn.nodemanager.env-whitelist</name>" "$YARN_SITE_FILE"; then
  echo "Updating yarn.nodemanager.env-whitelist property in $YARN_SITE_FILE"
  sed -i '/<name>yarn.nodemanager.env-whitelist<\/name>/!b;n;c<value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>' "$YARN_SITE_FILE"
else
  echo "Adding yarn.nodemanager.env-whitelist property to $YARN_SITE_FILE"
  sed -i '/<configuration>/a \
  <property>\n\
  <name>yarn.nodemanager.env-whitelist</name>\n\
  <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>\n\
  </property>' "$YARN_SITE_FILE"
fi

echo "yarn-site.xml has been updated."
