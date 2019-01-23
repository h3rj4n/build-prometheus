FROM arm64v8/busybox:latest

ARG ARCH=arm64
ARG VERSION=2.7.0-rc.1

RUN cd /tmp/ \
  && wget https://github.com/prometheus/prometheus/releases/download/v$VERSION/prometheus-$VERSION.linux-$ARCH.tar.gz \
  && tar -xvzf prometheus-$VERSION.linux-$ARCH.tar.gz && rm prometheus-$VERSION.linux-$ARCH.tar.gz \
  && mkdir -p /etc/prometheus \
  && cd prometheus-$VERSION.linux-$ARCH \
  && cp prometheus /bin/prometheus \
  && cp promtool /bin/promtool \
  && cp prometheus.yml /etc/prometheus/prometheus.yml \
  && cp -r console_libraries/ /etc/prometheus/ \
  && cp -r consoles /etc/prometheus/

EXPOSE 9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus", \
             "--web.console.libraries=/etc/prometheus/console_libraries", \
             "--web.console.templates=/etc/prometheus/consoles" ]
