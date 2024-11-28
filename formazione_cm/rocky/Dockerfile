FROM rockylinux:9

# Install ssh and sudo
RUN dnf update -y && dnf install openssh-server sudo -y && \
	mkdir -p /var/run/sshd && chmod 0755 /var/run/sshd && \
	useradd -m -d /home/genuser -s /bin/bash genuser && \
	echo 'genuser:{{ user_passwd }}' | chpasswd && \
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
