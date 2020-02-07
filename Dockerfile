FROM debian:buster

RUN apt-get update && \
    apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key* && \
	 groupadd --gid 10001 work && \
     adduser  --uid 10001 --gid 10001 work --quiet >/dev/null 2>&1 && \
	 chown  -R 10001:10001 /home/work && \
	 chmod 755 /home/work && \
	 echo work:changeme | chpasswd && \
	 mkdir /var/run/sftp && \
	 chown 10001:10001 /var/run/sftp && \
	 chown -R 10001:10001 /etc/ssh/ && \
	 touch /run/sshd.pid && \
	 chown 10001:10001 /run/sshd.pid && \
	 chown -R 10001:10001 /etc/passwd && \
	 chown -R 10001:10001  /etc/shadow
    
COPY --chown=10001:10001 files/sshd_config /etc/ssh/sshd_config
COPY --chown=10001:10001 files/create-sftp-user /usr/local/bin/
COPY --chown=10001:10001 files/entrypoint /

EXPOSE 2222

USER 10001
WORKDIR  /home/work

ENTRYPOINT ["/entrypoint"]