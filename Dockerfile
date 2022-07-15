FROM golang
WORKDIR /app
ADD . /app
RUN go build hello.go
CMD /app/hello
