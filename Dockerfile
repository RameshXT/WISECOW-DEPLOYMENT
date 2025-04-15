FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y cowsay fortune netcat-openbsd

RUN  rm -rf /var/lib/apt/lists/*

COPY wisecow.sh /app/wisecow.sh

WORKDIR /app

ENV PATH="/usr/games:${PATH}"

RUN chmod +x wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]
