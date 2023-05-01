version=latest
build:
	docker image build -t benjaminellmer/my-first-image:0.1 .

push:
	docker image push benjaminellmer/my-first-image:0.1

run:
	docker rm -f time-server
	docker image build -t benjaminellmer/my-first-image:$(version) .
	docker container run --name time-server -p 9090:8888 -d benjaminellmer/my-first-image:$(version) 

publish:
	docker image build -t benjaminellmer/my-first-image:$(version) .
	docker image push benjaminellmer/my-first-image:$(version)
