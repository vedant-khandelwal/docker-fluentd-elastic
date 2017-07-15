.PHONY:	build push

TAG = loggly

build:
	docker build -t docker.io/falkonry/fluentd-elastic:$(TAG) .

push:
	gcloud docker push docker.io/falkonry/fluentd-elastic:$(TAG)
