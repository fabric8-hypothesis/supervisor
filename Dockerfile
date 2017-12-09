FROM centos:centos7
LABEL maintainer="Anmol Babu <anmolbudugutta@gmail.com>"

# Setup App Dir
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
ADD package.json ./package.json
ADD package-lock.json ./package-lock.json

#Install nodejs
RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - && \
    yum install nodejs -y && \
    yum clean all

# Install app
RUN npm install --production

# Bundle app source
ADD . .

# Setup non-root user node
RUN groupadd -r node \
    && useradd -r -g node node

# Switch to non-root user
USER node

# Expose port
EXPOSE 9090

# Start app
CMD [ "npm", "start" ]