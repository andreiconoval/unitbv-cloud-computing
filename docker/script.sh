
echo "Running commands inside the container"

# Example commands
#nano /root/user/apps/example-file.txt
#tar -xvzf /root/user/apps/hadoop-3.3.6.tar.gz -C /root/user/apps
echo "Hadoop setup complete."



echo "Settup Hadoop environment variables"

# File to edit
BASHRC_FILE="$HOME/.bashrc"

# Check if the variables are already set, to avoid duplicates
if grep -q "export HADOOP_HOME=\$HOME/user/apps/hadoop" "$BASHRC_FILE"; then
  echo "Hadoop environment variables are already set in $BASHRC_FILE"
else
  echo "Adding Hadoop environment variables to $BASHRC_FILE"

  # Append the required lines to the .bashrc file
  echo -e "\n# Hadoop Environment Variables" >> "$BASHRC_FILE"
  echo "export HADOOP_HOME=\$HOME/user/apps/hadoop" >> "$BASHRC_FILE"
  echo "export HADOOP_CONF_DIR=\$HOME/user/apps/hadoop/etc/hadoop" >> "$BASHRC_FILE"
  echo "export HADOOP_MAPRED_HOME=\$HOME/user/apps/hadoop" >> "$BASHRC_FILE"
  echo "export HADOOP_COMMON_HOME=\$HOME/user/apps/hadoop" >> "$BASHRC_FILE"
  echo "export HADOOP_HDFS_HOME=\$HOME/user/apps/hadoop" >> "$BASHRC_FILE"
  echo "export YARN_HOME=\$HOME/user/apps/hadoop" >> "$BASHRC_FILE"
  echo "export PATH=\$PATH:\$HOME/user/apps/hadoop/bin" >> "$BASHRC_FILE"

  echo "Hadoop environment variables added successfully."

  # Optionally, source the .bashrc file to apply changes immediately
  source "$BASHRC_FILE"
fi


#------------------------------------------------------


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
#-----------------------------------------------------



# Path to the core-site.xml file
CORE_SITE_FILE="$HOME/user/apps/hadoop/etc/hadoop/core-site.xml"

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

#------------------------------------


# Path to the hdfs-site.xml file
HDFS_SITE_FILE="$HOME/user/apps/hadoop/etc/hadoop/hdfs-site.xml"

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

#-------------------------------------


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



#----------------
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


#-----------------------------------


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




#-------------------------------------


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



#----------------------------------------------



# Create the required directory structure for Hadoop
echo "Creating directory structure..."
mkdir -p "$HOME/user/apps/hadoop/hadoopdata/hdfs/namenode"
mkdir -p "$HOME/user/apps/hadoop/hadoopdata/hdfs/datanode"
mkdir -p "$HOME/user/apps/hadoop/cache"
mkdir -p "$HOME/user/apps/hadoop/logs"
mkdir -p "$HOME/user/apps/hadoop/tmp"
mkdir -p "$HOME/user/apps/hadoop/input"

echo "Directory structure has been created successfully."


#--------------------------------------

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



#------------------------------------------------------------------------------------------------

#!/bin/bash

# Function to check if systemd is running
check_systemd() {
  if [ "$(ps -p 1 -o comm=)" == "systemd" ]; then
    return 0  # System is using systemd
  else
    return 1  # System is not using systemd
  fi
}

# Function to generate SSH host keys if they are missing
generate_ssh_host_keys() {
  echo "Checking for missing SSH host keys..."
  sudo ssh-keygen -A
  if [ $? -eq 0 ]; then
    echo "SSH host keys generated successfully."
  else
    echo "Failed to generate SSH host keys."
    exit 1
  fi
}

# Function to start and enable sshd with systemd
start_and_enable_sshd_systemd() {
  echo "Starting and enabling sshd using systemd..."

  # Enable sshd service
  sudo systemctl enable sshd
  if [ $? -eq 0 ]; then
    echo "sshd service enabled successfully."
  else
    echo "Failed to enable sshd service."
  fi

  # Start sshd service
  sudo systemctl start sshd
  if [ $? -eq 0 ]; then
    echo "sshd service started successfully using systemd."
  else
    echo "Failed to start sshd using systemd."
  fi
}

# Function to start sshd without systemd
start_sshd_non_systemd() {
  # Check if the service command exists
  if command -v service >/dev/null 2>&1; then
    echo "Detected service command, starting sshd using service..."
    sudo service ssh start
  elif [ -f "/usr/sbin/sshd" ]; then
    echo "System not using systemd, starting sshd manually..."
    generate_ssh_host_keys  # Ensure host keys are available
    /usr/sbin/sshd
    if [ $? -eq 0 ]; then
      echo "sshd service started successfully."
    else
      echo "Failed to start sshd."
    fi
  else
    echo "sshd command not found. Ensure OpenSSH server is installed."
  fi
}

# Main script logic
if check_systemd; then
  generate_ssh_host_keys  # Ensure host keys are available
  start_and_enable_sshd_systemd
else
  start_sshd_non_systemd
fi

#-----------

#!/bin/bash

# Check if the .ssh directory exists, create it if it doesn't
if [ ! -d "$HOME/.ssh" ]; then
    echo "Creating .ssh directory..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# Generate an RSA key pair without a passphrase
echo "Generating RSA key pair..."
ssh-keygen -t rsa -P '' -f "$HOME/.ssh/id_rsa"

# Append the public key to the authorized_keys file
echo "Adding the public key to authorized_keys..."
cat "$HOME/.ssh/id_rsa.pub" >> "$HOME/.ssh/authorized_keys"

# Set the correct permissions for the authorized_keys file
echo "Setting permissions for authorized_keys..."
chmod 600 "$HOME/.ssh/authorized_keys"

echo "SSH key setup complete."