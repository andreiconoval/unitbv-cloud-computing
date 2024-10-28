#!/bin/bash
echo "Running lab1 prepare hadoop scripts..."

bash 1hadoop-bashrc.sh
bash 2set-openjdk.sh
bash 3set-core-site.sh
bash 4set-hdfs-site.sh
bash 5set-mapred-site.sh
bash 6set-yarn-site.sh
bash 7hadoop-folder-structure.sh
bash 8formatting-hdfs-namenode.sh
bash 9enable-start-sshd.sh
bash 10create-ssh.sh

echo "Finished lab1 prepare hadoop scripts..."
echo "DO YOUR JOB with Hadoop......."