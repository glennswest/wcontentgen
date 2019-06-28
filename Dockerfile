FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 as builder
RUN go get github.com/glennswest/winoperatordata/winoperatordata
WORKDIR /go/src/github.com/glennswest/winoperatordata/winoperatordata
RUN  go get -d -v
RUN  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/winoperatordata

FROM scratch
VOLUME /tmp
WORKDIR /root/
COPY --from=builder /go/bin/winoperatordata /go/bin/winoperatordata
ADD wcontent/ /data
EXPOSE 8080
ENTRYPOINT ["/go/bin/winoperatordata"]
