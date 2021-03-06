FROM amd64/ubuntu:16.04 as builder

ENV go_version=go1.12.2.linux-amd64
ARG nomad_version="v0.9.0"
ENV GOPATH=/root/go
ENV PATH="$PATH:/usr/local/go/bin:/root/go/bin"

RUN apt-get update && apt-get install -y sudo

COPY install.sh /install.sh
RUN bash /install.sh

COPY .goreleaser.yml "${GOPATH}/src/github.com/hashicorp/nomad/.goreleaser.yml"
COPY build.sh /build.sh
RUN bash /build.sh

FROM alpine:latest
COPY --from=builder \
  /root/go/src/github.com/hashicorp/nomad/dist/linux_arm_6/nomad \
  /usr/bin/nomad
