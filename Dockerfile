# Použijeme oficiálny Ghost image
FROM ghost:5.89.5

# Nastavíme pracovný adresár Ghostu
WORKDIR $GHOST_INSTALL

# Skopírujeme konfiguračný súbor a zálohovací skript
COPY config.production.json .
COPY backup.sh /usr/local/bin/backup.sh

# Nastavíme prístupové práva na spúšťanie skriptu
RUN chmod +x /usr/local/bin/backup.sh

# Premenné prostredia (voliteľné)
ENV url=https://zhenaya.onrender.com
ENV port=$PORT

# Predvolený príkaz na spustenie Ghostu
CMD ["node", "current/index.js"]
