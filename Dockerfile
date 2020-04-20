# ---- Base Node ----
FROM node:12-alpine AS base
RUN apk --no-cache add git
RUN apk --no-cache add bash

# Create git directory
WORKDIR /usr/src/git
# Install command to wait for DB to be up
RUN git clone https://github.com/vishnubob/wait-for-it.git

# Create app directory
WORKDIR /usr/src/app
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

#
# ---- Dependencies ----
FROM base AS dependencies
# Install app dependencies
# RUN npm set progress=false && npm config set depth 0
# RUN npm install --only=production
# copy production node_modules aside
# RUN cp -R node_modules prod_node_modules
# install ALL node_modules, including 'devDependencies'
RUN npm install && \
    npm cache clean --force

#
# ---- Development ----
FROM dependencies AS development
# Bundle app source
COPY . .
EXPOSE 3000