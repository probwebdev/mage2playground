ARG NODE_VER=10-alpine

FROM node:$NODE_VER

ARG VUE_STOREFRONT_ROOT=/home/node

RUN apk add --no-cache --virtual .runtime \
      shadow \
      su-exec \
      ca-certificates \
      wget \
      git

USER node

RUN mkdir $VUE_STOREFRONT_ROOT/app
WORKDIR $VUE_STOREFRONT_ROOT/app

COPY --chown=node:node package.json yarn.lock ./

RUN yarn install && yarn cache clean

USER root

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENV VS_ENV prod

ENTRYPOINT ["docker-entrypoint"]
EXPOSE 3000

CMD yarn dev
