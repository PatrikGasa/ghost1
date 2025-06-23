# see versions at https://hub.docker.com/_/ghost
FROM ghost:5.14.1

WORKDIR $GHOST_INSTALL
COPY . .

# 🔧 Pridaj URL, aby Ghost vedel o verejnej adrese
ENV url=https://zhenaya.onrender.com

# 🔁 Spusti Ghost priamo (Render potrebuje štandardné CMD)
CMD ["node", "current/index.js"]
