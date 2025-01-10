# Build stage
FROM golang:1.23.2 AS build-stage

WORKDIR /app

# Copy go.mod and go.sum files first for dependency caching
COPY go.mod ./

# Download dependencies
RUN go mod download 

# Copy the rest of the application files
COPY . .

# Build the Go binary with CGO disabled and target Linux OS
RUN CGO_ENABLED=0 GOOS=linux go build -o /test

# Release stage (using distroless image for minimal size)
FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /app

# Copy the built binary from the build stage
COPY --from=build-stage /test /test

# Copy the environment file


# Expose the port your app will run on
EXPOSE 8080

# Set the entry point to run your app
ENTRYPOINT ["/test"]
