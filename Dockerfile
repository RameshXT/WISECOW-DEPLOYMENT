FROM alpine:3.18

# Install necessary packages in Alpine
RUN apk add --no-cache \
    bash \
    cowsay \
    fortune \
    netcat-openbsd

RUN  rm -rf /var/lib/apt/lists/*

COPY wisecow.sh /app/wisecow.sh

WORKDIR /app

RUN chmod +x wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]

ENV PATH="/usr/games:${PATH}"
