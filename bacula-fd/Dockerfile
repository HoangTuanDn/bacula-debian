ARG B_VERSION=13.0.2

FROM nhtdn/bacula-base:${B_VERSION}

VOLUME [ "/opt/bacula/etc" ]

EXPOSE 9102/tcp

ENTRYPOINT [ "bacula-fd" ]

CMD [ "-f", "-c", "/opt/bacula/etc/bacula-fd.conf" ]