# Docker image customizing
# source: https://github.com/cloudposse/geodesic#customizing-your-docker-image
ARG VERSION=3.1.0
ARG OS=debian

FROM cloudposse/geodesic:$VERSION-$OS

ARG TERRAFORM_VERSION=1.9.4
ARG TFLINT_VERSION=0.52.0
ARG TRIVY_VERSION=0.53.0

ENV BANNER="local-dev"

ENV DOCKER_IMAGE="mtweeman/hajle-silesia_local-development"
ENV DOCKER_TAG="latest"

# Debian repository configuration
# source: https://github.com/cloudposse/packages#for-docker
#RUN apt-get update && apt-get install -y \
#    apt-utils \
#    curl \
#RUN curl -1sLf 'https://dl.cloudsmith.io/public/cloudposse/packages/cfg/setup/bash.deb.sh' | bash
#RUN apt-get update && apt-get install -y \
#    tflint=${TFLINT_VERSION}-\* \
#    trivy=${TRIVY_VERSION}-\* \

# Terraform configuration
ARG PACKAGE_VERSION=1.9.5
ARG OS=linux
ARG ARCH=amd64
RUN curl https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip -o terraform.zip
RUN unzip terraform.zip
RUN chmod +x terraform
