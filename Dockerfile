
### STAGE 1: Build ###

# We label our stage as ‘builder’
#FROM node:10-alpine as builder

#COPY package.json package-lock.json ./

## Storing node modules on a separate layer will prevent unnecessary npm installs at each build

#RUN npm ci && mkdir /ng-app && mv ./node_modules ./ng-app

#WORKDIR /ng-app

#COPY . .

## Build the angular app in production mode and store the artifacts in dist folder

#RUN npm run ng build -- --prod --output-path=dist


### STAGE 2: Setup ###

#FROM httpd

#COPY --from=builder /ng-app/dist /usr/local/apache2/htdocs/


FROM httpd

RUN \
  apt-get update \
  && apt-get -y install gettext-base \
  && apt-get clean \
&& rm -rf /var/lib/apt/lists/*

COPY ./dist /usr/local/apache2/htdocs/

CMD ["/bin/sh",  "-c",  "envsubst < /usr/local/apache2/htdocs/assets/settings.template.json > /usr/local/apache2/htdocs/assets/settings.json && httpd-foreground"]
