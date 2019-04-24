provider "pagerduty" {
  token   = "${var.pagerduty_tf_token_ci}"
  version = "~> 0.1"
}

module "payment_pagerduty" {
  source = "../../pagerduty"

  environment  = "${var.environment}"
  project_name = "${var.project_name}"
}

// using differently named variable to distinguish between test and real pagerduty tokens
variable "pagerduty_tf_token_ci" {
  type        = "string"
  description = "the pagerduty full access API token"
}

variable "environment" {
  type        = "string"
  description = "the environment of the account"
  default     = "dev"
}

variable "project_name" {
  type        = "string"
  description = "describe your variable"
  default     = "payment"
}
