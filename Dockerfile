# This Dockerfile will build an image that is configured
# to run Fluentd with a elasticsearch plug-in and the
# provided configuration file.

FROM gcr.io/google_containers/ubuntu-slim:0.4

# Ensure there are enough file descriptors for running Fluentd.
# RUN ulimit -n 65536

# Disable prompts from apt.
ENV DEBIAN_FRONTEND noninteractive

# Install prerequisites.
RUN apt-get update && \
    apt-get install -y -q --no-install-recommends curl ca-certificates make g++ sudo bash

# Install Fluentd.
RUN /usr/bin/curl -sSL https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent2.sh | sh

# Change the default user and group to root.
# Needed to allow access to /var/log/docker/... files.
RUN sed -i -e "s/USER=td-agent/USER=root/" -e "s/GROUP=td-agent/GROUP=root/" /etc/init.d/td-agent

# Install the elasticsearch plug-ins.
RUN td-agent-gem install --no-document fluent-plugin-elasticsearch

RUN rm -rf /opt/td-agent/embedded/share/doc \
  /opt/td-agent/embedded/share/gtk-doc \
  /opt/td-agent/embedded/lib/postgresql \
  /opt/td-agent/embedded/bin/postgres \
  /opt/td-agent/embedded/share/postgresql

# Cleanup
RUN apt-get remove -y make g++
RUN apt-get autoremove -y 
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy the Fluentd configuration file.
COPY td-agent.conf /etc/td-agent/td-agent.conf

ENV LD_PRELOAD /opt/td-agent/embedded/lib/libjemalloc.so

# Environment variables for configuration
ENV ELASTIC_HOST localhost
ENV ELASTIC_PORT 9200
ENV ELASTIC_INDEX docker

# Run the Fluentd service.
ENTRYPOINT ["td-agent"]
