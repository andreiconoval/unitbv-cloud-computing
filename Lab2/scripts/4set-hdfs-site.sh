# Path to the hdfs-site.xml file
HDFS_SITE_FILE="$HOME/apps/hadoop/etc/hadoop/hdfs-site.xml"

# Check if the hdfs-site.xml file exists
if [ ! -f "$HDFS_SITE_FILE" ]; then
  echo "hdfs-site.xml not found at $HDFS_SITE_FILE"
  exit 1
fi

# Backup the original hdfs-site.xml before modifying
cp "$HDFS_SITE_FILE" "$HDFS_SITE_FILE.bak"
echo "Backup of hdfs-site.xml created at $HDFS_SITE_FILE.bak"

# Check if the <configuration> block already exists
if grep -q "<configuration>" "$HDFS_SITE_FILE"; then
  echo "<configuration> block found in $HDFS_SITE_FILE"
else
  echo "<configuration> block not found, adding it."
  echo "<configuration>" > "$HDFS_SITE_FILE"
  echo "</configuration>" >> "$HDFS_SITE_FILE"
fi

# Insert or update the required properties
if grep -q "<name>dfs.replication</name>" "$HDFS_SITE_FILE"; then
  echo "Updating dfs.replication property in $HDFS_SITE_FILE"
  sed -i '/<name>dfs.replication<\/name>/!b;n;c<value>1</value>' "$HDFS_SITE_FILE"
else
  echo "Adding dfs.replication property to $HDFS_SITE_FILE"
  sed -i '/<configuration>/a \
  <property>\n\
  <name>dfs.replication</name>\n\
  <value>1</value>\n\
  </property>' "$HDFS_SITE_FILE"
fi

if grep -q "<name>dfs.name.dir</name>" "$HDFS_SITE_FILE"; then
  echo "Updating dfs.name.dir property in $HDFS_SITE_FILE"
  sed -i '/<name>dfs.name.dir<\/name>/!b;n;c<value>file:///root/user/apps/hadoop/hadoopdata/hdfs/namenode</value>' "$HDFS_SITE_FILE"
else
  echo "Adding dfs.name.dir property to $HDFS_SITE_FILE"
  sed -i '/<configuration>/a \
  <property>\n\
  <name>dfs.name.dir</name>\n\
  <value>file:///root/user/apps/hadoop/hadoopdata/hdfs/namenode</value>\n\
  </property>' "$HDFS_SITE_FILE"
fi

if grep -q "<name>dfs.data.dir</name>" "$HDFS_SITE_FILE"; then
  echo "Updating dfs.data.dir property in $HDFS_SITE_FILE"
  sed -i '/<name>dfs.data.dir<\/name>/!b;n;c<value>file:///root/user/apps/hadoop/hadoopdata/hdfs/datanode</value>' "$HDFS_SITE_FILE"
else
  echo "Adding dfs.data.dir property to $HDFS_SITE_FILE"
  sed -i '/<configuration>/a \
  <property>\n\
  <name>dfs.data.dir</name>\n\
  <value>file:///root/user/apps/hadoop/hadoopdata/hdfs/datanode</value>\n\
  </property>' "$HDFS_SITE_FILE"
fi

echo "hdfs-site.xml has been updated."