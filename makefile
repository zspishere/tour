BINARY_NAME=tour

all: test install

#compile:
#	echo "Compiling for every OS and Platform"
#	GOOS=freebsd GOARCH=386 go build -o bin/main-freebsd-386 main.go
#	GOOS=linux GOARCH=386 go build -o bin/main-linux-386 main.go
#	GOOS=windows GOARCH=386 go build -o bin/main-windows-386 main.go

build:
	go build -o ${BINARY_NAME} main.go

test:
	go test -v main.go

run: build
	./${BINARY_NAME}

install: build
	cp ./${BINARY_NAME} ${GOPATH}/bin

deps:
	go mod download

clean:
	go clean
	rm ${BINARY_NAME} ${GOPATH}/bin
