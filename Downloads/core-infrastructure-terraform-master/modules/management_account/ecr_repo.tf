module "ords_ecr_repo" {
  source = "../ecr_repositories"

  repository_names = [
    "shared-ords",
  ]

  allowed_account_ids = [
    "376076567968", // prod transit
    "556748783639", // dev & staging transit
  ]
}

module "concourse_init_ecr_repo" {
  source = "../ecr_repositories"

  repository_names = [
    "concourse-init",
  ]

  allowed_account_ids = [
    "002540887416", // main managemenet
    "350793678069", // enactor management
    "728741135697", // rfid management
    "710660959603", // order management
    "713021333007", // payment management
    "460402331925", // test account
    "125479865773", // product management account
  ]
}

module "vault_ecs_ecr_repo" {
  source = "../ecr_repositories"

  repository_names = [
    "docker-vaultecs",
  ]

  allowed_account_ids = [
    "002540887416", // main managemenet
    "460402331925", // test account
  ]
}

module "documentation" {
  source = "../ecr_repositories"

  repository_names = [
    "documentation",
  ]

  allowed_account_ids = [
    "376076567968", // prod transit
    "556748783639", // dev & staging transit
  ]
}

module "shared-proxy" {
  source = "../ecr_repositories"

  repository_names = [
    "shared-proxy",
  ]

  allowed_account_ids = [
    "376076567968", // prod transit
    "556748783639", // dev & staging transit
    "460402331925", // test account
  ]
}

module "shared-k8s-tools" {
  source = "../ecr_repositories"

  repository_names = [
    "shared-k8s-tools",
  ]

  allowed_account_ids = [
    "376076567968", // prod transit
    "556748783639", // dev & staging transit
    "460402331925", // test account
  ]
}
