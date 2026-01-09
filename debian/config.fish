# Display MOTD on interactive login shells
if status is-interactive; and status is-login
    bash /usr/local/bin/update-motd.sh
end
