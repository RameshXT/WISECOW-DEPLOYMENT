FROM ubuntu:latest

WORKDIR /app

RUN apt-get update \
    && apt-get install -y cowsay fortune-mod netcat-traditional netcat-openbsd bash

COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh && ls -la /app

EXPOSE 4499

ENTRYPOINT ["/app/wisecow.sh"]

ENV PATH="/usr/games:${PATH}"
