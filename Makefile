NAME ?= testkube-k6-executor
BIN_DIR ?= $(HOME)/bin
VERSION ?= 0.36.0

build:
	go build -o $(BIN_DIR)/$(NAME) cmd/agent/main.go 

.PHONY: test cover build

run: 
	EXECUTOR_PORT=8082 go run cmd/agent/main.go

mongo-dev: 
	docker run -p 27017:27017 mongo

docker-build: 
	docker build -t lreimer/$(NAME):$(VERSION) -f build/agent/Dockerfile .

docker-push:
	docker push lreimer/$(NAME):$(VERSION)

install-swagger-codegen-mac: 
	brew install swagger-codegen

install-k6-ubuntu:
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
	echo "deb https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
	sudo apt-get update
	sudo apt-get install k6

test: 
	go test ./... -cover

test-e2e:
	go test --tags=e2e -v ./test/e2e

test-e2e-namespace:
	NAMESPACE=$(NAMESPACE) go test --tags=e2e -v  ./test/e2e 

cover: 
	@go test -failfast -count=1 -v -tags test  -coverprofile=./testCoverage.txt ./... && go tool cover -html=./testCoverage.txt -o testCoverage.html && rm ./testCoverage.txt 
	open testCoverage.html


version-bump: version-bump-patch

version-bump-patch:
	go run cmd/tools/main.go bump -k patch

version-bump-minor:
	go run cmd/tools/main.go bump -k minor

version-bump-major:
	go run cmd/tools/main.go bump -k major

version-bump-dev:
	go run cmd/tools/main.go bump --dev
