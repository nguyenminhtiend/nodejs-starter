VERSION?=latest
LOCAL_TAG=nodejs-starter:$(VERSION)
ACCOUNT_ID=621567429603
REGION=ap-southeast-1
CONTAINER_NAME=nodejs-starter
REMOTE_TAG=$(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/$(CONTAINER_NAME):$(VERSION)
ENV=staging
DESIRED_COUNT=2

docker-build:
	docker build -f Dockerfile -t $(LOCAL_TAG) .

docker-run:
	docker run -e NODE_ENV=$(ENV) -p 3000:3000 $(LOCAL_TAG) \
		
compose:
	docker-compose up

compose-build:
	docker-compose up --build

ecr-login:
	aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com

docker-push:
	make ecr-login
	docker tag $(LOCAL_TAG) $(REMOTE_TAG)
	docker push $(REMOTE_TAG)

docker-build-push:
	make docker-build
	make docker-push

check-env:
ifndef ENV
	$(error Please set ENV=[staging|prod])
endif

terraform-create-workspace: check-env
	cd terraform && \
		terraform workspace new $(ENV)

terraform-first-init: check-env
	cd terraform && \
		terraform init \
		-var-file=development.tfvars

terraform-init: check-env
	cd terraform && \
		terraform workspace select $(ENV) && \
		terraform init \
		-var-file=development.tfvars

terraform_action:
	cd terraform && \
		terraform workspace select $(ENV) && \
		terraform $(ACTION) \
		-var-file=$(ENV).tfvars \
		-var="image=$(REMOTE_TAG)" \
		-var="desired_count=$(DESIRED_COUNT)"

terraform-plan: check-env
	make terraform_action ACTION=plan

terraform-apply: check-env
	make terraform_action ACTION=apply

terraform-destroy: check-env
	make terraform_action ACTION=destroy

cicd: check-env
	cd terraform && \
		terraform workspace select $(ENV) && \
		terraform plan \
		-target=module.ecs.aws_ecs_service.service \
		-target=module.ecs.aws_ecs_task_definition.task_definition \
		-out terraform_plan.out \
		-var-file=$(ENV).tfvars \
		-var="image=$(REMOTE_TAG)" \
		-var="desired_count=$(DESIRED_COUNT)"
	cd terraform && \
		terraform apply terraform_plan.out
