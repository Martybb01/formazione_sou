FROM alpine:latest

# Install ssh and sudo
RUN apk update && apk add --no-cache openssh sudo && \
	mkdir -p /var/run/sshd && chmod 0755 /var/run/sshd && \
	adduser -D -h /home/genuser -s /bin/sh genuser && \
	echo 'genuser:pippo' | chpasswd && \
	echo 'genuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
	mkdir /home/genuser/.ssh && \
	chmod 700 /home/genuser/.ssh

RUN ssh-keygen -A

# Copy public key
COPY id_key_genuser.pub /home/genuser/.ssh/authorized_keys
RUN chmod 600 /home/genuser/.ssh/authorized_keys && \
	chown -R genuser:genuser /home/genuser/.ssh

# Configure ssh
RUN	sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'AllowUsers genuser' >> /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
