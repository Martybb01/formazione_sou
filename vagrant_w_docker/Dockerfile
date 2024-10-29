FROM ubuntu:bionic

RUN apt-get update && \
	apt-get install -y nginx && \
	apt-get clean

COPY index.html /var/www/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
