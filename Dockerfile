ARG ALPINE=3.24.4
ARG SR=1.14.4

FROM alpine:${ALPINE}
LABEL org.opencontainers.image.authors="Axl <https://github.com/ADKix>"
RUN apk add -U --no-cache 7zip iproute2-minimal
ARG SR
ARG TARGETPLATFORM
WORKDIR "/opt"
RUN if   [ "${TARGETPLATFORM}" = "linux/arm64" ] || [ "${TARGETPLATFORM}" = "linux/arm64/v8" ]; then arch=arm64; \
    elif [ "${TARGETPLATFORM}" = "linux/arm/v7" ]; then arch=armv7; \
    elif [ "${TARGETPLATFORM}" = "linux/386" ]; then arch=386; \
    elif [ "${TARGETPLATFORM}" = "linux/amd64" ]; then arch=amd64; fi; \
    wget -qnc "https://github.com/SagerNet/sing-box/releases/download/v${SR}/sing-box-${SR}-linux-${arch}-musl.tar.gz" -O- | \
      tar -xzf - --strip-components=1 "sing-box-${SR}-linux-${arch}-musl/sing-box"; \
    7z a -sdel "sing-box.7z" "."
COPY "entrypoint.sh" "command.sh" /
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["sh", "/command.sh"]
ENV PORT=1080
