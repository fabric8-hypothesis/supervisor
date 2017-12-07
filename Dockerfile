#FROM registry.centos.org/che-stacks/centos-nodejs:NjFiNTczNTJjZT
#FROM registry.centos.org/sclo/nodejs-8-centos7:latest
FROM node:carbon
LABEL maintainer="Anmol Babu <anmolbudugutta@gmail.com>"

# Create app directory
WORKDIR /user/src/app

# Install app dependencies
COPY package.json ./package.json
COPY package-lock.json ./package-lock.json

RUN npm install --only=production
# If you are building your code for testing
# RUN npm install

# Bundle app source
COPY . .

EXPOSE 9090
CMD [ "npm", "start" ]