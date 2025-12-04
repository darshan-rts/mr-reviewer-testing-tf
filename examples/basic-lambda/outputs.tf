output "lambda_function_arn" {
  description = "ARN of the Lambda Function"
  value       = module.lambda_function.lambda_function_arn
}

output "lambda_function_name" {
  description = "Name of the Lambda Function"
  value       = module.lambda_function.lambda_function_name
}

output "lambda_function_invoke_arn" {
  description = "Invoke ARN of the Lambda Function"
  value       = module.lambda_function.lambda_function_invoke_arn
}

output "lambda_role_arn" {
  description = "ARN of the IAM role created for the Lambda Function"
  value       = module.lambda_function.lambda_role_arn
}

output "lambda_cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = module.lambda_function.lambda_cloudwatch_log_group_name
}
