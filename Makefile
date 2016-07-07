USER = registry.mywebgrocer.com/mywebgrocer
IMAGE = nexus
TAG = 3.0.0-03-patch2
TIMEOUT = 60

all: build tag-latest run logs url
staging: build tag-staging run logs url
kill: stop rm

.PHONY: clean

clean:
	-@docker rmi $(USER)/$(IMAGE):$(TAG)
	-@docker rmi $(USER)/$(IMAGE):latest

cleanimages:
	-docker images -q --filter "dangling=true" | xargs docker rmi

build: Dockerfile
	@docker \
		build \
		--tag=$(USER)/$(IMAGE):$(TAG) .

tag-staging:
	@docker \
		tag \
		$(USER)/$(IMAGE):$(TAG) $(USER)/$(IMAGE):staging

tag-latest:
	@docker \
		tag \
		$(USER)/$(IMAGE):$(TAG) $(USER)/$(IMAGE):latest

run:
	@docker \
		run \
		--detach \
		--hostname=$(IMAGE) \
		--name=$(IMAGE) \
		$(USER)/$(IMAGE):$(TAG)

logs:
	-@timeout $(TIMEOUT) docker logs -f $(IMAGE)

stop:
	@docker \
		stop $(IMAGE)

rm:
	@docker \
		rm $(IMAGE)

push:
	@docker \
		push \
		$(USER)/$(IMAGE)
