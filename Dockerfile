# Použijeme oficiálny Ghost image
FROM ghost:5.89.5

# Nastavíme pracovný adresár Ghostu
WORKDIR $GHOST_INSTALL

# Skopírujeme len konfiguračný súbor, NIE celý projekt
COPY config.production.json .

# Nastavíme premenné prostredia
ENV url=https://zhenaya.onrender.com
ENV port=$PORT

# Spustíme Ghost
CMD ["node", "current/index.js"]
