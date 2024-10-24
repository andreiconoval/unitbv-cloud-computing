1. Create a Fedora Docker Container

docker run -it --name my-fedora-container fedora

2. Save Changes in Docker Container

docker commit my-fedora-container my-fedora-image

2.2. Now you can start a new container based on the updated image:

docker run -it --name my-new-fedora-container my-fedora-image

3. Mount a Volume for Persistent Storage (Optional)
   If you want to ensure that files persist even after removing the container, mount a directory from your host machine as a volume:

docker run -it --name my-fedora-container -v /path/to/host/dir:/path/to/container/dir fedora

### Build and run the Docker container:

docker build -t fedora-hadoop .

docker run -it --name fedora-hadoop-container fedora-hadoop

### . Running Commands on a Live Container

Copy the script into a running container:

docker cp script.sh my-fedora-container:/root/script.sh

Execute the script inside the running container:

docker exec -it my-fedora-container /bin/bash /root/script.sh

Using docker exec to Run Commands Directly

docker exec -it my-fedora-container <command>
docker exec -it my-fedora-container ls /root/user/apps
