default: image

all: image

image:
	docker build . \
	-f Dockerfile \
	--tag matplotlib/mpl-docker:debug-latest

run:
	docker run --rm -it matplotlib/mpl-docker:debug-latest
