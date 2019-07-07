ARG NODE_VER=10-alpine

FROM node:$NODE_VER

ARG PWA_STUDIO_ROOT=/home/node

RUN apk add --no-cache --virtual .runtime \
      shadow \
      su-exec \
      python \
      make \
      g++

USER node

RUN mkdir $PWA_STUDIO_ROOT/app
WORKDIR $PWA_STUDIO_ROOT/app

COPY --chown=node:node packages/peregrine/package.json ./packages/peregrine/package.json
COPY --chown=node:node packages/pwa-buildpack/package.json ./packages/pwa-buildpack/package.json
COPY --chown=node:node packages/upward-js/package.json ./packages/upward-js/package.json
COPY --chown=node:node packages/upward-spec/package.json ./packages/upward-spec/package.json
COPY --chown=node:node packages/venia-concept/package.json ./packages/venia-concept/package.json
COPY --chown=node:node package.json yarn.lock babel.config.js browserslist.js magento-compatibility.js ./

RUN yarn install && yarn cache clean

COPY --chown=node:node packages ./packages

USER root

COPY pwa-studio.sh /usr/local/bin/pwa-studio
RUN chmod +x /usr/local/bin/pwa-studio

ENV DEV_SERVER_HOST localhost

ENTRYPOINT ["pwa-studio"]
EXPOSE 10000

CMD yarn workspace @magento/venia-concept run watch -- --host ${DEV_SERVER_HOST}
