# CD_Exercise_04

## Part 1
1. Create Docker Hub Account
2. Clone the Exercise Repo 
3. Delete the .git Folder and run `git init`
4. Implement the [Dockerfile](./Dockerfile) as described
5. Create and run `build` target in [Makefile](./Makefile)
6. Run `docker images`
```
benjaminellmer/my-first-image                   0.1            f7b73bff4713   2 seconds ago   474MB
```
7. Run `docker login` and login with credentials from docker.hub
8. Create and run `push` target in [Makefile](./Makefile)
9. View Created Image in hub.docker.com
<img width="693" alt="docker-hub" src="https://user-images.githubusercontent.com/30144387/235471700-a9e31f00-1557-4165-bde9-a2b748a4cbc3.png">

## Part 2
1. Create and run the `run` target in [Makefile](./Makefile)
2. Check the running container: 
```
$ curl -X GET http://localhost:9090
Hello, it is 14:48
```
3. View the running docker container with `docker ps`
4. Stop the container with `docker stop time-server`
<img width="1620" alt="docker-ps" src="https://user-images.githubusercontent.com/30144387/235471635-72ba0960-d377-423d-bcdd-0f3f61534ae5.png">


