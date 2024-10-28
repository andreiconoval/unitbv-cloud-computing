# Path to the mapred-site.xml file
MAPRED_SITE_FILE="$HOME/user/apps/hadoop/etc/hadoop/mapred-site.xml"

# Check if the mapred-site.xml file exists
if [ ! -f "$MAPRED_SITE_FILE" ]; then
  echo "mapred-site.xml not found at $MAPRED_SITE_FILE"
  exit 1
fi

# Backup the original mapred-site.xml before modifying
cp "$MAPRED_SITE_FILE" "$MAPRED_SITE_FILE.bak"
echo "Backup of mapred-site.xml created at $MAPRED_SITE_FILE.bak"

# Check if the <configuration> block already exists
if grep -q "<configuration>" "$MAPRED_SITE_FILE"; then
  echo "<configuration> block found in $MAPRED_SITE_FILE"
else
  echo "<configuration> block not found, adding it."
  echo "<configuration>" > "$MAPRED_SITE_FILE"
  echo "</configuration>" >> "$MAPRED_SITE_FILE"
fi

# Insert or update the required properties
if grep -q "<name>mapred.job.tracker</name>" "$MAPRED_SITE_FILE"; then
  echo "Updating mapred.job.tracker property in $MAPRED_SITE_FILE"
  sed -i '/<name>mapred.job.tracker<\/name>/!b;n;c<value>localhost:9001</value>' "$MAPRED_SITE_FILE"
else
  echo "Adding mapred.job.tracker property to $MAPRED_SITE_FILE"
  sed -i '/<configuration>/a \
  <property>\n\
  <name>mapred.job.tracker</name>\n\
  <value>localhost:9001</value>\n\
  </property>' "$MAPRED_SITE_FILE"
fi

if grep -q "<name>mapreduce.framework.name</name>" "$MAPRED_SITE_FILE"; then
  echo "Updating mapreduce.framework.name property in $MAPRED_SITE_FILE"
  sed -i '/<name>mapreduce.framework.name<\/name>/!b;n;c<value>yarn</value>' "$MAPRED_SITE_FILE"
else
  echo "Adding mapreduce.framework.name property to $MAPRED_SITE_FILE"
  sed -i '/<configuration>/a \
  <property>\n\
  <name>mapreduce.framework.name</name>\n\
  <value>yarn</value>\n\
  </property>' "$MAPRED_SITE_FILE"
fi

if grep -q "<name>mapreduce.application.classpath</name>" "$MAPRED_SITE_FILE"; then
  echo "Updating mapreduce.application.classpath property in $MAPRED_SITE_FILE"
  sed -i '/<name>mapreduce.application.classpath<\/name>/!b;n;c<value>\$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:\n\$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>' "$MAPRED_SITE_FILE"
else
  echo "Adding mapreduce.application.classpath property to $MAPRED_SITE_FILE"
  sed -i '/<configuration>/a \
  <property>\n\
  <name>mapreduce.application.classpath</name>\n\
  <value>\$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:\n\$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>\n\
  </property>' "$MAPRED_SITE_FILE"
fi

echo "mapred-site.xml has been updated."
