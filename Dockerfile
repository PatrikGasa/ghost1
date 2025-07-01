# Použijeme oficiálny Ghost image
FROM ghost:5.89.5

# Nainštalujeme cron a supervisord
RUN apt-get update && \
    apt-get install -y cron supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Nastavíme pracovný adresár
WORKDIR $GHOST_INSTALL

# Skopírujeme konfiguračný súbor a skript na zálohovanie
COPY config.production.json .
COPY backup.sh /usr/local/bin/backup.sh

# Nastavíme práva na spúšťanie skriptu
RUN chmod +x /usr/local/bin/backup.sh

# Pridáme crontab s dennou zálohou
COPY crontab.txt /etc/cron.d/ghost-backup
RUN chmod 0644 /etc/cron.d/ghost-backup && crontab /etc/cron.d/ghost-backup

# Skopírujeme supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Vytvoríme adresár na zálohy, ak ešte neexistuje
RUN mkdir -p /var/lib/ghost/content/backups

# Exponujeme port (voliteľne)
EXPOSE 2368

# Spustíme supervisora – ten spustí cron aj Ghost
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

