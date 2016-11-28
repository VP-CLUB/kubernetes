all: push

# 0.0 shouldn't clobber any release builds
TAG = 1.0.0
PREFIX = hub.docker.vpclub.cn/vpclub_containers/vp-traffic-monetisation-provider

container: 
	docker build -t $(PREFIX):$(TAG) .

push: container
	docker push $(PREFIX):$(TAG)


