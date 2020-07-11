default: image

all: image

image:
	docker build . \
	-f Dockerfile \
	--tag matplotlib/mpl-docker:debug-latest

run:
	docker run --rm -it \
	-v $(shell pwd):/mpl_source \
	-w /mpl_source \
	matplotlib/mpl-docker:debug-latest
