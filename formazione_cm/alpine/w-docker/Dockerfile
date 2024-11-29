FROM alpine:latest

# Install ssh, sudo, docker, and openrc
RUN apk update && apk add --no-cache openssh sudo docker openrc && \
    mkdir -p /var/run/sshd && chmod 0755 /var/run/sshd && \
    adduser -D -h /home/genuser -s /bin/sh genuser && \
    echo 'genuser:{{ user_passwd }}' | chpasswd && \
    echo 'genuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    adduser genuser docker && \
    mkdir /home/genuser/.ssh && chmod 700 /home/genuser/.ssh && \
    ssh-keygen -A

# Copy public key
COPY id_key_genuser.pub /home/genuser/.ssh/authorized_keys
RUN chmod 600 /home/genuser/.ssh/authorized_keys && \
    chown -R genuser:genuser /home/genuser/.ssh

# Configure ssh
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'AllowUsers genuser' >> /etc/ssh/sshd_config

# Configure Docker and openrc
RUN rc-update add docker boot
RUN mkdir /var/lib/docker
VOLUME /var/lib/docker

# Copy and set entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
# CMD ["/usr/sbin/sshd", "-D"]

