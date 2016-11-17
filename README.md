# Collecting Docker Log Files with Fluentd and ELK stack
This directory contains the source files needed to make a Docker image
that collects Docker container log files using [Fluentd](http://www.fluentd.org/)
and sends them to elasticsearch service.

RUN COMMAND:
docker run -d \
	-v /var/log:/var/log \
	-v /var/lib/docker/containers:/var/lib/docker/containers \
	-e "ELASTIC_HOST=localhost" \
	-e "ENV_HOST=$(hostname)" \
	-e "FALKONRY_URL=localhost:8080" \
	docker.io/falkonry/fluentd-elastic:docker
