PIPELINE="core-infrastructure-terraform"
PIPELINE_PRS="core-infrastructure-terraform-prs"
CONCOURSE_TARGET="aws-operations"

default: set_pipeline ;

.PHONY: set_pipeline
set_pipeline:
	$(MAKE) set_pipeline_prs
	$(MAKE) set_pipeline_master

.PHONY: set_pipeline_prs
set_pipeline_prs:
	fly -t $(CONCOURSE_TARGET) set-pipeline -c prs.yml -p $(PIPELINE_PRS)
	fly -t $(CONCOURSE_TARGET) expose-pipeline -p $(PIPELINE_PRS)

.PHONY: set_pipeline_master
set_pipeline_master:
	fly -t $(CONCOURSE_TARGET) set-pipeline -c main.yml -p $(PIPELINE)
	fly -t $(CONCOURSE_TARGET) expose-pipeline -p $(PIPELINE)
