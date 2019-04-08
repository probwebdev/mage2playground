FROM node:10-alpine

WORKDIR /home/node

RUN apk --no-cache --virtual add \
      python \
      make \
      g++

COPY docker/pwa-studio.sh /usr/local/bin/pwa-studio
RUN chmod +x /usr/local/bin/pwa-studio

USER node

COPY --chown=node:node packages ./packages/
COPY --chown=node:node package.json yarn.lock babel.config.js browserslist.js magento-compatibility.js ./

RUN yarn install && yarn cache clean

CMD ["pwa-studio"]
