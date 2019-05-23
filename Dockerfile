FROM golang:1.12 as builder
# RoarRunner build step borrowed from https://github.com/n1215/roadrunner-docker-skeleton

ENV GO111MODULE on
ENV RR_VERSION v1.4.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends git

WORKDIR /go/src

# Build RoadRunner
RUN git clone --depth 1 --branch ${RR_VERSION} https://github.com/spiral/roadrunner \
    && cd /go/src/roadrunner \
    && make \
    && make install

FROM alpine:3.9.4

# Install PHP
RUN apk --no-cache add \
    php7 \
    php7-curl \
    php7-json \
    php7-mbstring \
    php7-openssl \
    php7-phar \
    php7-zip

# Install RoadRunner
COPY --from=builder /go/src/roadrunner/rr /usr/local/bin/rr

# Install Composer
ADD ./composer_installer.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/composer_installer.sh && \
    /usr/local/bin/composer_installer.sh && \
    rm /usr/local/bin/composer_installer.sh

# Setup application source
RUN mkdir -p /app
ADD . /app

# Configure runtime
WORKDIR /app
EXPOSE 80
CMD ["/usr/local/bin/rr", "serve", "-d", "-c", "/app/.rr.yaml"]
