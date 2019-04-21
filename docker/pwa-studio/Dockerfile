ARG NODE_VER=10-alpine

FROM node:$NODE_VER

WORKDIR /home/node

RUN apk --no-cache --virtual add \
      python \
      make \
      g++

COPY pwa-studio.sh /usr/local/bin/pwa-studio
RUN chmod +x /usr/local/bin/pwa-studio

COPY --chown=node:node packages ./packages/
COPY --chown=node:node package.json yarn.lock babel.config.js browserslist.js magento-compatibility.js ./

USER node

RUN yarn install && yarn cache clean

CMD ["pwa-studio"]
