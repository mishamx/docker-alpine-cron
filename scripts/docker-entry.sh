#!/bin/sh
set -e

rm -rf /var/spool/cron/crontabs && mkdir -m 0644 -p /var/spool/cron/crontabs

[ "$(ls -A /etc/cron.d)" ] && cp -f /etc/cron.d/* /var/spool/cron/crontabs/ || true

[ ! -z "$CRON_STRINGS" ] && echo -e "$CRON_STRINGS\n" > /var/spool/cron/crontabs/CRON_STRINGS

chmod -R 0644 /var/spool/cron/crontabs

env | while read -r LINE; do
    IFS="=" read VAR VAL <<< ${LINE}
    sed --in-place "/^${VAR}/d" /etc/security/pam_env.conf || true
    echo "${VAR} DEFAULT=\"${VAL}\"" >> /etc/security/pam_env.conf
done

exec "$@"
