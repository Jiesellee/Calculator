output "invoke_arn" {
  value = "${aws_lambda_function.function_definition.invoke_arn}"
}

output "function_name" {
  value      = "${var.function_name}_${var.environment}"
  depends_on = ["aws_lambda_function.function_definition.arn"]
}

output "arn" {
  value = "${aws_lambda_function.function_definition.arn}"
}
