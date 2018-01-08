FROM golang:alpine

ENV TERRAFORM_VERSION=0.10.8

RUN apk add --update git bash openssh

ENV TF_DEV=true
ENV TF_RELEASE=true

WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
    git checkout v${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh

WORKDIR /usr

RUN ["/bin/bash", "-c", "shopt -s extglob"]
CMD bash