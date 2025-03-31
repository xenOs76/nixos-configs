#!/usr/bin/env bash
#
# example:
#  mc cp -r /root/ os76-tf-backups-user/os76-tf-backups/root-00-00-01
#
USER=os76-tf-backups-user
BUCKET=os76-tf-backups
FOLDER=$(date +%Y/%m/%d/%H)

# use absolute paths and add trailing slash
DIRS="/root/ /var/lib/hass/ /home/xeno/ /etc/"

for DIR in $DIRS; do
  mc cp -r $DIR $USER/$BUCKET/${FOLDER}${DIR}
done
