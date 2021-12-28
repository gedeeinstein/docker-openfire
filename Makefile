all: build

build:
	@docker build --tag=gedeadisurya/docker-openfire .

release: build
	@docker build --tag=gedeadisurya/docker-openfire:$(shell cat VERSION) .
