ARG KIBANA_VER=5.6.16

FROM docker.elastic.co/kibana/kibana:$KIBANA_VER

RUN bin/kibana-plugin remove x-pack && \
    kibana 2>&1 | grep -m 1 "Optimization of .* complete"
