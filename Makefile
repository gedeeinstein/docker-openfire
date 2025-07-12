all: build

build:
	@docker build --tag=gedeadisurya/openfire .

release: build
	@docker build --tag=gedeadisurya/openfire:$(shell cat VERSION) .
