FROM golang:1.16.3 as builder
LABEL maintainer="Jose Ramon Mañes - github.com/jrmanes"
ADD . /app
WORKDIR /app
RUN go fmt ./...
RUN go test -v ./... -cover -coverprofile=coverage.out
RUN go tool cover -func=coverage.out
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ./cmd/api/

######## Start a new stage from scratch #######
FROM alpine:latest
# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/main .
CMD ["./main"]