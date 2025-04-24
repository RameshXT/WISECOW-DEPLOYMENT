FROM ubuntu:latest

WORKDIR /app

RUN apt-get update  \
    && apt-get install -y cowsay \
    && apt-get install -y fortune-mod \
    && apt-get install -y netcat-traditional \
    && apt-get install -y netcat-openbsd

COPY wisecow.sh /app/wisecow.sh

RUN chmod +x wisecow.sh

EXPOSE 4499

ENTRYPOINT ["sh", "-c", "/app/wisecow.sh"]

ENV PATH="/usr/games:${PATH}"
