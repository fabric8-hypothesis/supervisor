ARG VERSION="8.9.2"
ARG NPM_VERSION="5.5.0"
FROM registry.devshift.net/nodejs:${VERSION}_npm_${NPM_VERSION}
LABEL maintainer="Anmol Babu <anmolbudugutta@gmail.com>"

# Setup App Dir
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
ADD package.json ./package.json
ADD package-lock.json ./package-lock.json

# Install app
RUN npm install --production

# Bundle app source
ADD . .

# Setup non-root user node
RUN groupadd -r node \
    && useradd -r -g node node

# Switch to non-root user
ENV USER node
USER node

ARG PORT=9090
ENV HDD_SUPERVISOR_PORT ${PORT}

# Expose port
EXPOSE ${PORT}

# Start app
CMD [ "npm", "start" ]
