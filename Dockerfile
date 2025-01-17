ARG ARCH=
ARG DIST=v3.20
FROM ghcr.io/asymworks/multiarch-alpine:${ARCH}-${DIST}

ARG DIST=v3.20

ENV RSA_PRIVATE_KEY_NAME packages@asymworks.com-5ff0a833.rsa
ENV PACKAGER_PRIVKEY /home/builder/${RSA_PRIVATE_KEY_NAME}
ENV REPODEST /packages

RUN apk --no-cache add alpine-sdk coreutils cmake sudo \
  && adduser -u 501 -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir /packages \
  && chown builder:abuild /packages \
  && mkdir -p /var/cache/apk \
  && ln -s /var/cache/apk /etc/apk/cache \
  && wget -qO /etc/apk/keys/${RSA_PRIVATE_KEY_NAME}.pub \
    https://pkgs.asymworks.net/${RSA_PRIVATE_KEY_NAME}.pub

COPY /abuilder /bin/
USER builder
ENTRYPOINT ["abuilder", "-r"]
WORKDIR /home/builder/main/package

VOLUME ["/home/builder/package"]
