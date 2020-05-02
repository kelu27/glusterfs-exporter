FROM golang:buster as build

RUN go get github.com/gluster/gluster-prometheus/gluster-exporter

WORKDIR /go/src/github.com/gluster/gluster-prometheus

RUN ./scripts/install-reqs.sh

RUN make && make install


FROM debian:buster-slim

COPY --from=build /usr/local/sbin/gluster-exporter /usr/local/sbin/
COPY --from=build /usr/local/etc/gluster-exporter/gluster-exporter.toml /usr/local/etc/gluster-exporter/

CMD /usr/local/sbin/gluster-exporter --config=/usr/local/etc/gluster-exporter/gluster-exporter.toml
