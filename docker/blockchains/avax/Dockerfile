FROM golang:1.21.12-bullseye AS builder

ARG AVALANCHE_BUILD_VERSION=v1.11.9
ARG SUBNET_VERSION=v0.6.6

WORKDIR /build

RUN git clone https://github.com/ava-labs/avalanchego.git && \
    cd avalanchego && \
    git checkout $AVALANCHE_BUILD_VERSION && \
    ./scripts/build.sh

RUN git clone https://github.com/ava-labs/subnet-evm.git && \
    cd subnet-evm && \
    git checkout $SUBNET_VERSION && \
    ./scripts/build.sh ../build/plugins/mDV3QWRXfwgKUWb9sggkv4vQxAQR4y2CyKrt5pLZ5SzQ7EHBv

FROM debian:11-slim AS execution

RUN mkdir -p avalanchego/build

WORKDIR /avalanchego/build

COPY --from=builder build/avalanchego/build/ .

CMD [ "./avalanchego" ]