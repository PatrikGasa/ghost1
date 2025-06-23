# see versions at https://hub.docker.com/_/ghost
FROM ghost:5.89.5

WORKDIR $GHOST_INSTALL
COPY . .

ENV url=https://zhenaya.onrender.com
ENV port=$PORT

CMD ["node", "current/index.js"]
