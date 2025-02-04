FROM rust:1.84.1-bookworm AS rust-analyzer-build

WORKDIR /src
RUN git clone https://github.com/rust-lang/rust-analyzer -b 2025-02-03

WORKDIR /src/rust-analyzer
RUN cargo xtask install --server

FROM rust:1.76.0-bookworm AS helix-build

WORKDIR /src
RUN git clone https://github.com/helix-editor/helix -b 25.01.1

WORKDIR /src/helix
RUN cargo install --locked --path ./helix-term/

FROM rust:1.84.1-bookworm AS gitui-build

RUN apt-get update && apt-get install -y cmake

WORKDIR /src
RUN git clone https://github.com/extrawurst/gitui -b v0.27.0

WORKDIR /src/gitui
RUN cargo install --locked --path .

FROM ubuntu:24.04

ARG TZ="Etc/GMT"

COPY ./build-root.sh /usr/local/bin/build-root.sh
RUN TZ=$TZ /usr/local/bin/build-root.sh

USER dev

COPY ./build-dev.sh /usr/local/bin/build-dev.sh
RUN TZ=$TZ /usr/local/bin/build-dev.sh

RUN sudo rm /usr/local/bin/build-root.sh /usr/local/bin/build-dev.sh

COPY --from=rust-analyzer-build /usr/local/cargo/bin/rust-analyzer /usr/bin/rust-analyzer
COPY --from=helix-build /usr/local/cargo/bin/hx /usr/bin/hx
COPY --from=helix-build /src/helix/runtime /var/lib/helix/runtime
COPY --from=gitui-build /usr/local/cargo/bin/gitui /usr/bin/gitui

COPY ./entry.sh /usr/local/bin/entry

ENTRYPOINT [ "entry" ]
