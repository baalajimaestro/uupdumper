FROM debian:bullseye-slim

RUN apt update
RUN apt install git python3 moreutils openssh-client openssh-server python3-pip aria2 cabextract wimtools chntpw genisoimage grep bash openssl ca-certificates -y
RUN pip3 install requests bs4 urllib3
RUN git config --global user.name baalajimaestro
RUN git config --global user.email baalajimaestro@pixelexperience.org
RUN mkdir /app
WORKDIR /app
COPY . /app

CMD bash runner.sh | ts '[%Y-%m-%d %H:%M:%S]'