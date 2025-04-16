FROM ubuntu:22.04

RUN apt-get update && apt-get install -y bash cowsay fortune netcat-openbsd

RUN  rm -rf /var/lib/apt/lists/*

COPY wisecow.sh /app/wisecow.sh

WORKDIR /app

RUN chmod +x wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]

ENV PATH="/usr/games:${PATH}"