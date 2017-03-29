all: build

build:
	@docker build --tag=eswork/redis .

release: build
	@docker build --tag=eswork/redis:$(shell cat VERSION) .
