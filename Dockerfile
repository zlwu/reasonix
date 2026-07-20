FROM node:24-bookworm-slim@sha256:6f7b03f7c2c8e2e784dcf9295400527b9b1270fd37b7e9a7285cf83b6951452d

ARG REASONIX_VERSION=1.17.16
ARG LARK_CLI_VERSION=1.0.72

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/reasonix
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV NPM_CONFIG_UPDATE_NOTIFIER=false

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        jq \
        openssh-client \
        procps \
        python3 \
        ripgrep \
        tini \
        vim-nox \
    && rm -rf /var/lib/apt/lists/*

RUN existing_user="$(getent passwd 1000 | cut -d: -f1 || true)" \
    && if [ -n "${existing_user}" ]; then \
        existing_group="$(id -gn "${existing_user}")" \
        && if [ "${existing_group}" != "reasonix" ]; then groupmod --new-name reasonix "${existing_group}"; fi \
        && if [ "${existing_user}" != "reasonix" ]; then \
            usermod --login reasonix --home /home/reasonix --move-home "${existing_user}"; \
        else \
            usermod --home /home/reasonix --move-home reasonix; \
        fi; \
    else \
        useradd --create-home --shell /bin/bash --uid 1000 reasonix; \
    fi

RUN mkdir -p /home/reasonix/workspace \
    && chown -R reasonix:reasonix /home/reasonix \
    && npm install -g \
        "reasonix@${REASONIX_VERSION}" \
        "@larksuite/cli@${LARK_CLI_VERSION}" \
    && npm cache clean --force

USER reasonix
WORKDIR /home/reasonix/workspace

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["reasonix", "help"]
