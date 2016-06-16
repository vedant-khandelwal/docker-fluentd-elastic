.PHONY:	build push

TAG = 1.1

build:
	docker build -t docker.io/falkonry/fluentd-elastic:$(TAG) .

push:
	gcloud docker push docker.io/falkonry/fluentd-elastic:$(TAG)
