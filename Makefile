default: image

all: image

image:
	docker build . \
	-f Dockerfile \
	--build-arg BASE_IMAGE=python:3.8 \
	--tag matplotlib/mpl-docker:debug-latest

run:
	docker run --rm -it \
	-v $(shell pwd):/mpl_source \
	-w /mpl_source \
	matplotlib/mpl-docker:debug-latest
