ARG B_VERSION=13.0.2

FROM nhtdn/bacula-base:${B_VERSION}

VOLUME ["/opt/bacula/etc"]

EXPOSE 9101/tcp

ENTRYPOINT ["bacula-dir"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-dir.conf"]