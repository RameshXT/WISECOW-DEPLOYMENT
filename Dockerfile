FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/games:${PATH}"

RUN apt-get update && \
    apt-get install -y cowsay fortune-mod netcat bash && \
    apt-get clean

WORKDIR /app

COPY wisecow.sh .

RUN sed -i 's/\r$//' wisecow.sh && \
    chmod +x wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]