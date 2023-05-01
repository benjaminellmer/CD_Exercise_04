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

## Part 3
1. Create the workflow [go.yaml](.github/workflows/go.yml) that includes go build and test and is executed, when a PR is created, or when something is committed on master.
Additionally I added workflow_dispatch, so the workflow can be run manually without PR or commit.
```
name: Go

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]
  workflow_dispatch:

jobs:
  buildAndTest:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3

    - name: Set up Go
      uses: actions/setup-go@v3
      with:
        go-version: 1.11

    - name: Build
      run: go build -v ./...

    - name: Test
      run: go test -v ./...
```
2. Add the `dockerBuildAndPublish` job and create short sha using bash script
```
  dockerBuildAndPublish:
    runs-on: ubuntu-latest
    needs: buildAndTest
    steps:
    - uses: actions/checkout@v3
    - id: vars
      run: echo "sha_short=$(git rev-parse --short HEAD)" >> $GITHUB_OUTPUT
```
3. Create an Docker Access Token under Account Settings -> Security -> New Access Token
4. Add the `DOCKER_USERNAME` and `DOCKER_TOKEN` secrets to the repository secrets under Settings -> Secrets and variables -> Actions
5. Add the `docker/login-action` task using the created secrets
```
    - name: Docker Login
      uses: docker/login-action@v2.1.0
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_TOKEN }}
```
6. Add the `docker/build-push-action` task with the `latest` tag and the short sha, created before. The Push argument has to be set to true, otherwise it will only build.
```
    - name: Build and push Docker images
      uses: docker/build-push-action@v4.0.0
      with:
        push: true
        tags: ${{ secrets.DOCKER_USERNAME }}/my-first-image:latest,${{ secrets.DOCKER_USERNAME }}/my-first-image:${{ steps.vars.outputs.sha_short }}
```

## Part 4
1. Add the `trivy-action` that scans the Docker image for vulnerabilities. Set the `exit-code` to 1 but `continue-on-error` to true
```
    - name: Scan Docker Image
      uses: aquasecurity/trivy-action@0.10.0
      continue-on-error: true
      with:
        image-ref: '${{ secrets.DOCKER_USERNAME }}/my-first-image:${{ steps.vars.outputs.sha_short }}'
        severity: 'CRITICAL,HIGH'
        exit-code: 1
```
2. Add the `trivy-action` that scans the configuration (IaC) for vulnerabilities. Set the `exit-code` to 1 but `continue-on-error` to true
```
    - name: Scan IaC
      uses: aquasecurity/trivy-action@0.10.0
      continue-on-error: true
      with:
        scan-type: 'config'
        severity: 'CRITICAL,HIGH'
        exit-code: 1
```

In a more realistic scenario we would execute the vulnerability scans before publishing the image, and publish it only when there are no Critical or High CSVs.
Since fixing the CSVs is not part of this exercise I just ran the vulnerability scans after creating the image...


