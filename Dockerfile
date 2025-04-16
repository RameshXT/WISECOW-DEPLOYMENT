FROM alpine:3.18

RUN apk add --no-cache \
    bash \
    fortune \
    netcat-openbsd \
    nodejs \
    npm

RUN npm install -g cowsay

RUN apk add --no-cache --upgrade bash

COPY wisecow.sh /app/wisecow.sh

RUN sed -i 's/\r//' /app/wisecow.sh

RUN chmod +x /app/wisecow.sh

WORKDIR /app

EXPOSE 4499

CMD ["./wisecow.sh"]

ENV PATH="/usr/games:${PATH}"
