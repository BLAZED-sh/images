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
    bc \
    sudo \
    tini \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN useradd -m -s /usr/bin/fish user && \
    usermod -aG sudo user

RUN mkdir -p /var/run/sshd
RUN mkdir -p /home/user/.ssh && chown user:user /home/user/.ssh

# Copy logo
COPY logo.txt /usr/local/share/logo.txt

# Copy scripts
COPY --chmod=755 entrypoint.sh /entrypoint.sh
COPY --chmod=755 update-motd.sh /usr/local/bin/update-motd.sh

# Setup fish config for dynamic MOTD on login
RUN mkdir -p /home/user/.config/fish
COPY config.fish /home/user/.config/fish/config.fish
RUN chown -R user:user /home/user/.config

# Disable default MOTD
RUN rm -f /etc/motd

EXPOSE 22

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
