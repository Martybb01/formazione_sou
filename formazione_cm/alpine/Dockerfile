FROM alpine:latest

# Install ssh and sudo
RUN apk update && apk add --no-cache openssh sudo && \
	mkdir /var/run/sshd && \
	adduser -h -D /home/genericuser -s /bin/bash genericuser && \
	echo 'genericuser:pippo' | chpasswd && \
	echo 'genericuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
	mkdir /home/genericuser/.ssh && \
	chmod 700 /home/genericuser/.ssh

# Copy public key
COPY id_key_genericuser.pub /home/genericuser/.ssh/authorized_keys
RUN chmod 600 /home/genericuser/.ssh/authorized_keys && \
	chown -R genericuser:genericuser /home/genericuser/.ssh

# Configure ssh
RUN	sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'AllowUsers genericuser' >> /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
