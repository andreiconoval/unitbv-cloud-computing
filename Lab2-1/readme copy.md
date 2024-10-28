### Build and Run the Docker Container:

\`\`\`bash
docker build -t fedora-hadoop-lab2 .
docker run -it --name fedora-hadoop-lab2-container fedora-hadoop-lab2
\`\`\`

### Running Commands on a Live Container

#### Copy the Script into a Running Container:

\`\`\`bash
docker cp script.sh my-fedora-container:/root/script.sh
\`\`\`

#### Execute the Script Inside the Running Container:

\`\`\`bash
docker exec -it my-fedora-container /bin/bash /root/script.sh
\`\`\`

### Using \`docker exec\` to Run Commands Directly:

\`\`\`bash
docker exec -it my-fedora-container <command>
\`\`\`

#### Example: Listing Files in a Directory

\`\`\`bash
docker exec -it my-fedora-container ls /root/user/apps
\`\`\`
