all: build

build:
	@docker build --tag=gedeeinstein/openfire .

release: build
	@docker build --tag=gedeeinstein/openfire:$(shell cat VERSION) .
