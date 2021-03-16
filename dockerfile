FROM golang:1.16.2
LABEL maintainer="zspishere@163.com"

ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn,direct
# ENV GOMAXPROCS=8

RUN mkdir /code
WORKDIR /code
COPY . /code/
RUN cd /code && make all

ENTRYPOINT ["tour"]
CMD ["time", "now"]
