#based in https://docs.docker.com/engine/reference/commandline/docker/

docker ps -a #List al dockers 
docker rm BC365  #Delete a container name 



docker run #– Runs a command in a new container.
docker start #– Starts one or more stopped containers
docker stop #– Stops one or more running containers
docker build #– Builds an image form a Docker file
docker pull #– Pulls an image or a repository from a registry
docker push #– Pushes an image or a repository to a registry
docker export #– Exports a container’s filesystem as a tar archive
docker exec #– Runs a command in a run-time container
docker search #– Searches the Docker Hub for images
docker attach #– Attaches to a running container
docker commit #– Creates a new image from a container’s changes