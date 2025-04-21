FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    bash \
    cowsay \
    fortune \
    netcat-openbsd \
    coreutils \
    net-tools \
    iputils-ping \
    procps && \
    rm -rf /var/lib/apt/lists/*

COPY wisecow.sh /app/wisecow.sh
RUN sed -i 's/\r//' /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

WORKDIR /app
EXPOSE 4499

CMD ["/usr/bin/bash", "/app/wisecow.sh"]
