FROM debian:bullseye-slim

RUN apt update > /dev/null
RUN apt install git python3 moreutils openssh-client openssh-server python3-pip aria2 zip unzip cabextract wimtools chntpw genisoimage grep bash openssl ca-certificates -y > /dev/null
RUN pip3 install requests bs4 urllib3 > /dev/null
RUN git config --global user.name baalajimaestro
RUN git config --global user.email baalajimaestro@pixelexperience.org
RUN mkdir /app
WORKDIR /app
COPY . /app

CMD bash runner.sh | ts '[%Y-%m-%d %H:%M:%S]'