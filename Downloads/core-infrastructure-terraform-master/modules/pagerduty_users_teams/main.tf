/* teams */

resource "pagerduty_team" "tooh" {
  name = "${var.team_ooh}-${var.project_name}-${var.environment}"
}

resource "pagerduty_team" "tdoh" {
  name = "${var.team_doh}-${var.project_name}-${var.environment}"
}

/* users */

resource "pagerduty_user" "users" {
  count = "${length(var.users) > 0 ? length(var.users) : 0}"

  name  = "${element(values(var.users), count.index)}"
  email = "${element(values(var.user_emails), count.index)}"
  role  = "${element(values(var.user_pg_roles), count.index)}"
  teams = ["${pagerduty_team.tooh.id}", "${pagerduty_team.tdoh.id}"]
}
