FROM node:24-bookworm-slim

ARG REASONIX_VERSION=1.17.6

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/reasonix
ENV NPM_CONFIG_UPDATE_NOTIFIER=false

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        procps \
        python3 \
        ripgrep \
        tini \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash --uid 1000 reasonix

RUN npm install -g "reasonix@${REASONIX_VERSION}" \
    && npm cache clean --force

USER reasonix
WORKDIR /workspace

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["reasonix", "help"]
