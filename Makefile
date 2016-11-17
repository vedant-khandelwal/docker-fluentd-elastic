.PHONY:	build push

TAG = docker

build:
	docker build -t docker.io/falkonry/fluentd-elastic:$(TAG) .

push:
	docker push docker.io/falkonry/fluentd-elastic:$(TAG)
