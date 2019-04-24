// main

/* schedules */

resource "pagerduty_schedule" "sooh" {
  name      = "outside_office_hours-${var.project_name}-${var.environment}"
  time_zone = "Europe/London"

  layer {
    name                         = "Outside office hours"
    start                        = "${var.sched_rot_start}"
    rotation_virtual_start       = "${var.sched_rot_start}"
    rotation_turn_length_seconds = "${var.sched_rot_interval}"

    users = ["${var.users_ids}"]

    restriction {
      type              = "daily_restriction"
      start_time_of_day = "09:00:00"
      duration_seconds  = 32400
    }
  }
}

resource "pagerduty_schedule" "sdoh" {
  name      = "during_office_hours-${var.project_name}-${var.environment}"
  time_zone = "Europe/London"

  layer {
    name                         = "During office hours"
    start                        = "${var.sched_rot_start}"
    rotation_virtual_start       = "${var.sched_rot_start}"
    rotation_turn_length_seconds = "${var.sched_rot_interval}"

    users = ["${var.users_ids}"]

    restriction {
      type              = "daily_restriction"
      start_time_of_day = "18:00:00"
      duration_seconds  = 54000
    }
  }
}

/* escalation policies */

resource "pagerduty_escalation_policy" "ooh_esc_policy" {
  name      = "outside_office_hours-${var.project_name}-${var.environment}"
  num_loops = 5
  teams     = ["${var.team_ooh_list}"]

  rule {
    escalation_delay_in_minutes = 15

    target {
      type = "schedule_reference"
      id   = "${pagerduty_schedule.sooh.id}"
    }
  }
}

resource "pagerduty_escalation_policy" "doh_esc_policy" {
  name      = "during_office_hours-${var.project_name}-${var.environment}"
  num_loops = 5
  teams     = ["${var.team_doh_list}"]

  rule {
    escalation_delay_in_minutes = 15

    target {
      type = "schedule_reference"
      id   = "${pagerduty_schedule.sdoh.id}"
    }
  }
}

/* services */

resource "pagerduty_service" "svc" {
  count = "${length(keys(var.services))}"

  name                    = "${element(split(",",lookup(var.services, count.index)), 0)}-${var.project_name}-${var.environment}"
  auto_resolve_timeout    = "${element(split(",",lookup(var.services, count.index)), 1)}"
  acknowledgement_timeout = "${element(split(",",lookup(var.services, count.index)), 2)}"
  escalation_policy       = "${element(split(",",lookup(var.services, count.index)), 3) == "ooh" ? pagerduty_escalation_policy.ooh_esc_policy.id : pagerduty_escalation_policy.doh_esc_policy.id }"

  incident_urgency_rule {
    type    = "constant"
    urgency = "high"
  }
}

/* cloudwatch integration */
data "pagerduty_vendor" "cloudwatch" {
  name = "Cloudwatch"
}

resource "pagerduty_service_integration" "cloudwatch" {
  count = "${length(keys(var.services))}"

  name    = "${data.pagerduty_vendor.cloudwatch.name}"
  service = "${element(pagerduty_service.svc.*.id, count.index)}"
  vendor  = "${data.pagerduty_vendor.cloudwatch.id}"
}
