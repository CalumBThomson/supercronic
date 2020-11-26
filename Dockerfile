ARG IMAGE_BASE_DISTRO="alpine"
ARG IMAGE_BASE_VER="3.12"
ARG IMAGE_SUPERCRONIC_VER="v0.1.11"
ARG IMAGE_SUPERCRONIC_BINARY="supercronic-linux-amd64"
ARG IMAGE_SUPERCRONIC_SHA1SUM="a2e2d47078a8dafc5949491e5ea7267cc721d67c"


FROM ${IMAGE_BASE_DISTRO}:${IMAGE_BASE_VER} AS base


LABEL maintainer="CBT Docker Maintainers <docker-maint@cbthomson.com>"


FROM base AS build
RUN apk add --update --no-cache curl
ARG IMAGE_SUPERCRONIC_VER
ARG IMAGE_SUPERCRONIC_BINARY
ARG SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/${IMAGE_SUPERCRONIC_VER}/${IMAGE_SUPERCRONIC_BINARY}
ARG IMAGE_SUPERCRONIC_SHA1SUM
RUN curl -fsSLO "${SUPERCRONIC_URL}" \
 && echo "${IMAGE_SUPERCRONIC_SHA1SUM}  ${IMAGE_SUPERCRONIC_BINARY}" | sha1sum -c - \
 && chmod +x "${IMAGE_SUPERCRONIC_BINARY}" \
 && mv "${IMAGE_SUPERCRONIC_BINARY}" "/usr/local/bin/${IMAGE_SUPERCRONIC_BINARY}" \
 && ln -s "/usr/local/bin/${IMAGE_SUPERCRONIC_BINARY}" /usr/local/bin/supercronic


FROM base AS final
# copy in required supercronic files from <build> image
ARG IMAGE_SUPERCRONIC_BINARY
COPY --from=build /usr/local/bin/${IMAGE_SUPERCRONIC_BINARY} /usr/local/bin/${IMAGE_SUPERCRONIC_BINARY}
# set up cron (with default sample crontab)
ADD --chown=nobody:nobody sample-crontab /etc/crontabs/nobody
RUN dos2unix /etc/crontabs/nobody \
 && ln -s "/usr/local/bin/${IMAGE_SUPERCRONIC_BINARY}" /usr/local/bin/supercronic
# install tini (https://github.com/krallin/tini.git)
RUN apk --no-cache add tini
# set entry point
USER nobody
ENTRYPOINT ["/sbin/tini","-vv","-e","143","--","/usr/local/bin/supercronic"]
CMD ["/etc/crontabs/nobody"]
