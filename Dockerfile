FROM rust:1.76.0-bookworm AS helix-build

WORKDIR /src
RUN git clone https://github.com/helix-editor/helix -b 25.01.1

WORKDIR /src/helix
RUN cargo install --locked --path ./helix-term/

FROM ubuntu:24.04

ARG TZ="Etc/GMT"

COPY --from=helix-build /usr/local/cargo/bin/hx /usr/bin/hx
COPY --from=helix-build /src/helix/runtime /var/lib/helix/runtime

COPY ./build-root.sh /usr/local/bin/build-root.sh
RUN TZ=$TZ /usr/local/bin/build-root.sh

USER dev

COPY ./build-dev.sh /usr/local/bin/build-dev.sh
RUN TZ=$TZ /usr/local/bin/build-dev.sh

RUN sudo rm /usr/local/bin/build-root.sh /usr/local/bin/build-dev.sh

COPY ./entry.sh /usr/local/bin/entry

ENTRYPOINT [ "entry" ]
