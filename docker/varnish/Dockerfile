ARG UBUNTU_VER=bionic

FROM ubuntu:$UBUNTU_VER

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install varnish -y && \
    rm -rf /var/lib/apt/lists/*

ENV VARNISH_CONFIG /etc/varnish/default.vcl
ENV VARNISH_CACHE_SIZE 256m
ENV VARNISH_PARAMS -p default_ttl=3600 -p default_grace=3600 -p http_resp_hdr_len=65536 -p http_resp_size=98304

EXPOSE 80

CMD ["bash", "-c", "varnishd -F -f $VARNISH_CONFIG -s malloc,$VARNISH_CACHE_SIZE -a :80 $VARNISH_PARAMS"]
