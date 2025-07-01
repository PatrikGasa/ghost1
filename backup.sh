#!/bin/bash

# Nastavenie cesty pre uloženie záloh
BACKUP_DIR="/var/lib/ghost/content/backups"
mkdir -p $BACKUP_DIR

# Vytvoríme názov súboru s časovou pečiatkou
FILENAME="zhenaya.ghost.$(date +%Y-%m-%d-%H-%M-%S).json"

# Spustíme export pomocou Ghost CLI
ghost export $BACKUP_DIR/$FILENAME

# Odstránime staré zálohy staršie ako 14 dní (voliteľné)
find $BACKUP_DIR -type f -name "*.json" -mtime +14 -delete

