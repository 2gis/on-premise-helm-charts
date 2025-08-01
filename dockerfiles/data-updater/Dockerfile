FROM alpine:3.21.3
LABEL maintainer="On-Premise <team-on-premise@2gis.ru>"

ARG KUBECTL_VERSION=1.29.13
ARG HELM_VERSION=3.18.2
ARG HELM_DIFF_VERSION=3.12.0

RUN apk add --update --no-cache ca-certificates curl bash jq

RUN curl -s -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -zx -C /usr/bin --strip-components=1 linux-amd64/helm && \
    curl -s -L https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl && \
    chmod 755 /usr/bin/helm /usr/bin/kubectl && \
    mkdir -p ~/.local/share/helm/plugins && \
    curl -s -L https://github.com/databus23/helm-diff/releases/download/v${HELM_DIFF_VERSION}/helm-diff-linux-amd64.tgz | tar -zxC ~/.local/share/helm/plugins

ARG ON_PREMISE_RELEASE

RUN mkdir -p /charts && chmod 777 /charts && \
    curl -s -L https://codeload.github.com/2gis/on-premise-helm-charts/tar.gz/refs/tags/${ON_PREMISE_RELEASE} | tar -zx -C /charts --strip-components=2 on-premise-helm-charts-${ON_PREMISE_RELEASE}/charts
