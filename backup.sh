#!/bin/bash

# Install:
#   sudo apt install s3cmd


source scripts/locking.sh

set -e
STAGEDIR=`mktemp -d /tmp/mkbackups.XXXX`
USED=`df -P /tmp  |grep ^/ | perl -pe 's/.*?(\d+)%.*$/$1/g'`
if [ $USED -ge 90 ]; then
  exit 1
fi
export TZ=/usr/share/zoneinfo/US/Central

tar -czf $STAGEDIR/smokeping-data.tar.gz ~/binddirs/smokeping/data 2>/dev/null
/usr/bin/s3cmd -q put --storage-class=STANDARD_IA $STAGEDIR/smokeping-data.tar.gz s3://family-backups/pi/smokeping-data.tar.gz
rm -rf $STAGEDIR
