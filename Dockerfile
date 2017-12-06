FROM node:carbon
LABEL maintainer="Anmol Babu <anmolbudugutta@gmail.com>"

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json ./package.json
COPY package-lock.json ./package-lock.json

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY . .

EXPOSE 9090
CMD [ "npm", "start" ]