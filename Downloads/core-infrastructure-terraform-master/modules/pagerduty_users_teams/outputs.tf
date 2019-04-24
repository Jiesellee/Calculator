output "team_doh_id_list" {
  value = ["${pagerduty_team.tdoh.id}"]
}

output "team_ooh_id_list" {
  value = ["${pagerduty_team.tooh.id}"]
}

output "user_id_list" {
  value = ["${pagerduty_user.users.*.id}"]
}
