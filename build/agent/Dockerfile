# syntax=docker/dockerfile:1
FROM golang:1.17 as builder
WORKDIR /build
COPY . .
ENV CGO_ENABLED=0 
ENV GOOS=linux

RUN cd cmd/agent;go build -o /runner -mod mod -a .

# build k6 with prometheus support
RUN go install go.k6.io/xk6/cmd/xk6@latest && \
    xk6 build --with github.com/grafana/xk6-output-prometheus-remote

FROM loadimpact/k6:0.36.0
WORKDIR /home/k6
COPY --from=builder /runner /bin/runner
COPY --from=builder /build/k6 /usr/bin/k6
ENTRYPOINT ["/bin/runner"]
