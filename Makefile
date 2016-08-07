all: build

build:
	@docker build --tag=johnwu/redis .

release: build
	@docker build --tag=johnwu/redis:$(shell cat VERSION) .
