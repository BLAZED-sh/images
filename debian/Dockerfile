FROM debian:13

RUN apt-get update && apt-get install -y \
    openssh-server \
    fish \
    vim \
    curl \
    wget \
    git \
    python3 \
    nodejs \
    htop \
    socat \
    jq \
    pwgen \
    cron \
    bc \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /usr/bin/fish user

RUN mkdir -p /var/run/sshd
RUN mkdir -p /home/user/.ssh && chown user:user /home/user/.ssh

COPY entrypoint.sh /entrypoint.sh
COPY update-motd.sh /usr/local/bin/update-motd.sh
RUN chmod +x /entrypoint.sh /usr/local/bin/update-motd.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
