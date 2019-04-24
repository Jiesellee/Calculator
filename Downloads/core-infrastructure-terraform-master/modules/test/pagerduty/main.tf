provider "pagerduty" {
  token   = "${var.pagerduty_tf_token_ci_test}"
  version = "~> 0.1"
}

module "pagerduty_users_teams" {
  source = "../../pagerduty_users_teams"

  environment  = "${var.environment}"
  project_name = "${var.project_name}"
  team_ooh     = "${var.team_ooh}"
  team_doh     = "${var.team_doh}"

  users         = "${var.users}"
  user_emails   = "${var.user_emails}"
  user_pg_roles = "${var.user_pg_roles}"
}

module "pagerduty" {
  source = "../../pagerduty"

  environment  = "${var.environment}"
  project_name = "${var.project_name}"

  team_ooh_list = "${module.pagerduty_users_teams.team_doh_id_list}"
  team_doh_list = "${module.pagerduty_users_teams.team_ooh_id_list}"
  users_ids     = "${module.pagerduty_users_teams.user_id_list}"

  sched_rot_interval = "${var.sched_rot_interval}"
  sched_rot_start    = "${var.sched_rot_start}"

  services       = "${var.services}"
  service_lookup = "${var.service_lookup}"
}
