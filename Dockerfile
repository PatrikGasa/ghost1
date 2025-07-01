# Použijeme oficiálny Ghost image
FROM ghost:5.89.5

# Inštalujeme cron, supervisor a nástroje potrebné pre kompiláciu sharp
RUN apt-get update && \
    apt-get install -y cron supervisor build-essential python3 make g++ && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Inštalácia sharp (pre generovanie obrázkov rôznych veľkostí)
WORKDIR /tmp
RUN npm install --no-save sharp && \
    node -e "require('sharp')" || (echo '⚠️ Sharp is not working!' && exit 1)

# Nastavíme pracovný adresár Ghostu
WORKDIR $GHOST_INSTALL

# Skopírujeme konfiguračný súbor a zálohovací skript
COPY config.production.json $GHOST_INSTALL/config.production.json
COPY backup.sh /usr/local/bin/backup.sh

# Nastavíme práva na spúšťanie skriptu
RUN chmod +x /usr/local/bin/backup.sh

# Pridáme crontab
COPY crontab.txt /etc/cron.d/ghost-backup
RUN chmod 0644 /etc/cron.d/ghost-backup && crontab /etc/cron.d/ghost-backup

# Skopírujeme supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Vytvoríme adresár pre zálohy (Render ho môže mountnuť)
RUN mkdir -p /var/lib/ghost/content/backups

# Exponujeme port Ghostu
EXPOSE 2368

# Spustíme supervisora
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]



