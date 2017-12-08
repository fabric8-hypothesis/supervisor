FROM node:carbon
LABEL maintainer="Anmol Babu <anmolbudugutta@gmail.com>"

# Create app directory
WORKDIR /usr/src/app

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