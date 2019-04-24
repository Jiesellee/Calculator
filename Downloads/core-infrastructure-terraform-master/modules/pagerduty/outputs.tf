// outputs

output "svc_status" {
  value = ["${
             pagerduty_service.svc.*.status
           }"]
}

output "svc_id" {
  value = "${
      zipmap(
        pagerduty_service.svc.*.id,
        values(service_lookup)
      )
  }"
}

output "cloudwatch_integration_keys" {
  value = "${
              zipmap(
                pagerduty_service.svc.*.id,
                pagerduty_service_integration.cloudwatch.*.integration_key
              )
           }"
}
