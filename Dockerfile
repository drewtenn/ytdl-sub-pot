FROM ghcr.io/jmbannon/ytdl-sub

RUN apk add --no-cache --repository=http://dl-3.alpinelinux.org/alpine/edge/main/ \
	"python3>=3.10" py3-pip

RUN python3 -m pip install --break-system-packages --no-cache-dir bgutil-ytdlp-pot-provider
