provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
}

// sets up a single az vpc and a keypair
module "base" {
  source = "../base"
}

module "jump_box" {
  source = "../../jump_box"

  project_name = "test"
  environment  = "test"
  vpc_id       = "${module.base.vpc_vpc_id}"
  ssh_key_name = "${module.base.aws_key_pair_key_name}"
  subnet       = "${element(module.base.vpc_private_subnets, 0)}"
}
