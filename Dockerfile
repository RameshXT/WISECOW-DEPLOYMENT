FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y fortune-mod cowsay bash curl

WORKDIR /app

COPY . .

RUN chmod +x wisecow.sh

EXPOSE 4499

CMD ["bash", "wisecow.sh"]
