FROM ubuntu:24.04

ARG TZ="Etc/GMT"

COPY ./build-root.sh /usr/local/bin/build-root.sh
RUN TZ=$TZ /usr/local/bin/build-root.sh

USER dev

COPY ./build-dev.sh /usr/local/bin/build-dev.sh
RUN TZ=$TZ /usr/local/bin/build-dev.sh

RUN sudo rm /usr/local/bin/build-root.sh /usr/local/bin/build-dev.sh

COPY ./entry.sh /usr/local/bin/entry

ENTRYPOINT [ "entry" ]
