TEST?=$$(go list ./... | grep -v 'vendor')
BINARY=terraform-provider-policy-sentry

# go source files, ignore vendor directory
SRC = $(shell find . -type f -name '*.go' -not -path "./vendor/*")

default: install

build:
	go build -o ${BINARY}

install: build
	mv ${BINARY} ~/.terraform.d/plugins

fmt:
	@gofmt -l -w $(SRC)

test:
	go test -i $(TEST) || exit 1
	echo $(TEST) | \
	xargs -t -n4 go test $(TESTARGS) -timeout=30s -parallel=4

testacc:
	TF_ACC=1 go test $(TEST) -v $(TESTARGS) -timeout 120m