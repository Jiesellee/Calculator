.PHONY: test plan apply

all: test plan apply 

test:
	./scripts/pre-commit
	./scripts/test_modules.sh

plan: plan_core plan_product

plan_core:
	cd $(CURDIR)/providers/aws/shared_dev && terraform init && terraform plan
	cd $(CURDIR)/providers/aws/shared_prod && terraform init && terraform plan
	cd $(CURDIR)/providers/aws/test && terraform init && terraform plan
	cd $(CURDIR)/providers/aws/pocs && terraform init && terraform plan
	cd $(CURDIR)/providers/aws/iam && terraform init && terraform plan
	cd $(CURDIR)/providers/aws/monitoring && terraform init && terraform plan
	cd $(CURDIR)/providers/aws/management && terraform init && terraform plan
	cd $(CURDIR)/providers/aws/styleman_prod && terraform init && terraform plan
	cd $(CURDIR)/providers/aws/root && terraform init && terraform plan

plan_product:
	for product_name in enactor order rfid payment product ; do \
		for environment in management dev staging prod ; do \
			cd $(CURDIR)/providers/aws/$${product_name}_$${environment} && terraform init && terraform plan ; \
		done \
	done

apply: apply_core apply_product

apply_core:
	cd $(CURDIR)/providers/aws/shared_dev && terraform init && terraform apply
	cd $(CURDIR)/providers/aws/shared_prod && terraform init && terraform apply
	cd $(CURDIR)/providers/aws/test && terraform init && terraform apply
	cd $(CURDIR)/providers/aws/pocs && terraform init && terraform apply
	cd $(CURDIR)/providers/aws/iam && terraform init && terraform apply
	cd $(CURDIR)/providers/aws/monitoring && terraform init && terraform apply
	cd $(CURDIR)/providers/aws/management && terraform init && terraform apply
	cd $(CURDIR)/providers/aws/styleman_prod && terraform init && terraform apply
	cd $(CURDIR)/providers/aws/root && terraform init && terraform apply

apply_product:
	for product_name in enactor order rfid payment product ; do \
		for environment in management dev staging prod ; do \
			cd $(CURDIR)/providers/aws/$${product_name}_$${environment} && terraform init && terraform apply ; \
		done \
	done