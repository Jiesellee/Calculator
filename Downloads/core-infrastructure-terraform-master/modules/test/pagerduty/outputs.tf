/* outputs */

output "service_status" {
  value = "${module.pagerduty.svc_status}"
}

output "service_ids" {
  value = "${module.pagerduty.svc_id}"
}

output "cloudwatch_service_apikeys" {
  value = "${module.pagerduty.cloudwatch_integration_keys}"
}
