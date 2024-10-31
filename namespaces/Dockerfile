FROM nginx:alpine

RUN apk update && apk add procps

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
