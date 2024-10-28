
# Path to the core-site.xml file
CORE_SITE_FILE="$HOME/apps/hadoop/etc/hadoop/core-site.xml"

# Check if the core-site.xml file exists
if [ ! -f "$CORE_SITE_FILE" ]; then
  echo "core-site.xml not found at $CORE_SITE_FILE"
  exit 1
fi

# Backup the original core-site.xml before modifying
cp "$CORE_SITE_FILE" "$CORE_SITE_FILE.bak"
echo "Backup of core-site.xml created at $CORE_SITE_FILE.bak"

# Check if the <configuration> block already exists
if grep -q "<configuration>" "$CORE_SITE_FILE"; then
  echo "<configuration> block found in $CORE_SITE_FILE"
else
  echo "<configuration> block not found, adding it."
  echo "<configuration>" > "$CORE_SITE_FILE"
  echo "</configuration>" >> "$CORE_SITE_FILE"
fi

# Insert or update the required properties
if grep -q "<name>fs.default.name</name>" "$CORE_SITE_FILE"; then
  echo "Updating fs.default.name property in $CORE_SITE_FILE"
  sed -i '/<name>fs.default.name<\/name>/!b;n;c<value>hdfs://localhost:9000</value>' "$CORE_SITE_FILE"
else
  echo "Adding fs.default.name property to $CORE_SITE_FILE"
  sed -i '/<configuration>/a \
  <property>\n\
  <name>fs.default.name</name>\n\
  <value>hdfs://localhost:9000</value>\n\
  </property>' "$CORE_SITE_FILE"
fi

if grep -q "<name>hadoop.tmp.dir</name>" "$CORE_SITE_FILE"; then
  echo "Updating hadoop.tmp.dir property in $CORE_SITE_FILE"
  sed -i '/<name>hadoop.tmp.dir<\/name>/!b;n;c<value>/root/user/apps/hadoop/tmp</value>' "$CORE_SITE_FILE"
else
  echo "Adding hadoop.tmp.dir property to $CORE_SITE_FILE"
  sed -i '/<configuration>/a \
  <property>\n\
  <name>hadoop.tmp.dir</name>\n\
  <value>/root/user/apps/hadoop/tmp</value>\n\
  </property>' "$CORE_SITE_FILE"
fi

echo "core-site.xml has been updated."
