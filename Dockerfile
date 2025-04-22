FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y bash fortune cowsay netcat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN chmod +x wisecow.sh

EXPOSE 4499

CMD ["bash", "./wisecow.sh"]
