FROM alpine:edge

RUN apk update
RUN apk add git python3 moreutils openssh openssl ca-certificates --no-cache
RUN pip3 install requests bs4 urllib3
RUN git config --global user.name baalajimaestro
RUN git config --global user.email baalajimaestro@pixelexperience.org
RUN mkdir /app
WORKDIR /app
COPY . /app

CMD bash runner.sh | ts '[%Y-%m-%d %H:%M:%S]'