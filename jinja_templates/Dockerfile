FROM alpine:latest

LABEL maintainer="marboccu"

RUN apk update && apk add --no-cache \
	python3 \	vim \	curl
COPY . /app

WORKDIR /app

CMD ["python3 app.py"]
