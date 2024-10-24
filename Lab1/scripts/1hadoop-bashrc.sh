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

