FROM ghcr.io/jmbannon/ytdl-sub

RUN apk add --no-cache --repository=http://dl-3.alpinelinux.org/alpine/edge/main/ \
	"python3>=3.10" py3-pip

RUN python3 -m pip install --break-system-packages --no-cache-dir bgutil-ytdlp-pot-provider

# Add s6 service to tail the cron log to Docker stdout.
# The base image's universal-stdout-logs mod is supposed to do this but
# requires a runtime network download that doesn't always succeed.
RUN mkdir -p \
        /etc/s6-overlay/s6-rc.d/svc-cron-log/dependencies.d && \
    echo "longrun" > /etc/s6-overlay/s6-rc.d/svc-cron-log/type && \
    printf '#!/bin/sh\nexec tail -F "${LOGS_TO_STDOUT:-/config/.cron.log}"\n' \
        > /etc/s6-overlay/s6-rc.d/svc-cron-log/run && \
    chmod +x /etc/s6-overlay/s6-rc.d/svc-cron-log/run && \
    touch /etc/s6-overlay/s6-rc.d/svc-cron-log/dependencies.d/base && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/svc-cron-log
