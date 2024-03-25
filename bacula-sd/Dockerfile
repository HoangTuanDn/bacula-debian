ARG B_VERSION=13.0.2

FROM nhtdn/bacula-base:${B_VERSION}

VOLUME [ "/opt/bacula/etc" ]

EXPOSE 9103/tcp

ENTRYPOINT [ "bacula-sd" ]

CMD [ "-f", "-c", "/opt/bacula/etc/bacula-sd.conf" ]