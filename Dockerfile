FROM alpine:3.18

# Install necessary packages in Alpine, including Node.js and npm for cowsay
RUN apk add --no-cache \
    bash \
    fortune \
    netcat-openbsd \
    nodejs \
    npm

# Install cowsay via npm
RUN npm install -g cowsay

RUN  rm -rf /var/lib/apt/lists/*

COPY wisecow.sh /app/wisecow.sh

WORKDIR /app

RUN chmod +x wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]

ENV PATH="/usr/games:${PATH}"
