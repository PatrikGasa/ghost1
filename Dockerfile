# Použijeme oficiálny Ghost image
FROM ghost:5.89.5

# Nastavíme pracovný adresár Ghostu
WORKDIR $GHOST_INSTALL

# Skopírujeme len konfiguračný súbor
COPY config.production.json .

# Skopírujeme skript na zálohovanie
COPY backup.sh /usr/local/bin/backup.sh

# Nastavíme prístupové práva
RUN chmod +x /usr/local/bin/backup.sh

# Nastavíme premenné prostredia
ENV url=https://zhenaya.onrender.com
ENV port=$PORT

# Spustíme Ghost
CMD ["node", "current/index.js"]

