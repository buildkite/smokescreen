FROM golang:1.16beta1

RUN apt-get update -q && \
  apt-get install -y zip && \
  go get github.com/buildkite/github-release

WORKDIR /go/src/github.com/buildkite/smokescreen
ADD . /go/src/github.com/buildkite/smokescreen

ENV GO111MODULE=on

CMD [ "scripts/build" ]
