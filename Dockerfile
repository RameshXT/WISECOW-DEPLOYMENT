FROM ubuntu:latest

ENV PATH="/usr/games:/usr/local/games:$PATH"

RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get install -y fortune-mod cowsay netcat-openbsd

COPY src/wisecow.sh /usr/local/bin/wisecow.sh

RUN chmod +xr /usr/local/bin/wisecow.sh

EXPOSE 4499

CMD ["/usr/local/bin/wisecow.sh"]