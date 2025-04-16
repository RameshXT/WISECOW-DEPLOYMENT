FROM alpine:3.18

# Install necessary packages, including coreutils to ensure utilities like rm and mkfifo are available
RUN apk add --no-cache \
    bash \
    fortune \
    netcat-openbsd \
    nodejs \
    npm \
    coreutils

# Install cowsay via npm
RUN npm install -g cowsay

COPY wisecow.sh /app/wisecow.sh

RUN sed -i 's/\r//' /app/wisecow.sh

RUN chmod +x /app/wisecow.sh

WORKDIR /app

EXPOSE 4499

CMD ["./wisecow.sh"]

ENV PATH="/usr/games:${PATH}"
