# STEP 1: Build
FROM golang:1.23.3-alpine AS builder
ARG VERSION
RUN apk update && apk add --no-cache git upx
WORKDIR /build
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH="amd64" go build -ldflags="-w -s" -o ./bin/gease ./cmd/api/main.go

# STEP 2: Optimize
RUN upx --best --lzma ./bin/gease

# STEP 3: Run
FROM alpine:latest
ARG VERSION
WORKDIR /app
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk*
COPY --from=builder /build/bin/gease ./gease
EXPOSE 3000
CMD [ "/app/gease" ]