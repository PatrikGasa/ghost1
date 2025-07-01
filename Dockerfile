FROM ghost:5.89.5

# Nainštalujeme potrebné balíky
RUN apt-get update && apt-get install -y cron supervisor

# Nastavíme pracovný adresár
WORKDIR $GHOST_INSTALL

# Skopírujeme config a skript
COPY config.production.json .
COPY backup.sh /usr/local/bin/backup.sh

# Sprístupníme skript
RUN chmod +x /usr/local/bin/backup.sh

# Pridáme crontab
COPY crontab.txt /etc/cron.d/ghost-backup
RUN chmod 0644 /etc/cron.d/ghost-backup && crontab /etc/cron.d/ghost-backup

# Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Spustíme supervisora, ktorý pustí cron + ghost
CMD ["/usr/bin/supervisord"]
