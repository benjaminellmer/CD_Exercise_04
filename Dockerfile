FROM golang:1.11-alpine

MAINTAINER benjamin.ellmer@yahoo.com

WORKDIR /src
COPY main.go /src

RUN ls

RUN apk update
RUN apk add build-base
RUN go build -o myapp

RUN mkdir /usr/app
RUN cp myapp /usr/app/.

EXPOSE 8888

ENTRYPOINT ["/usr/app/myapp"]
