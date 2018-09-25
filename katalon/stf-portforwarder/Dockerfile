FROM golang:1.11-alpine
WORKDIR /go/src/app
copy main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-s -w' -o app .

FROM alpine
RUN apk add --no-cache openssh
COPY --from=0 /go/src/app/app /usr/bin/
