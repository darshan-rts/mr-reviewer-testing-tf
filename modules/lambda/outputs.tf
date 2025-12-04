output "lambda_function_arn" {
  description = "ARN of the Lambda Function"
  value       = aws_lambda_function.this.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda Function"
  value       = aws_lambda_function.this.function_name
}

output "lambda_function_invoke_arn" {
  description = "Invoke ARN of the Lambda Function"
  value       = aws_lambda_function.this.invoke_arn
}

output "lambda_function_qualified_arn" {
  description = "Qualified ARN of the Lambda Function"
  value       = aws_lambda_function.this.qualified_arn
}

output "lambda_function_version" {
  description = "Latest published version of the Lambda Function"
  value       = aws_lambda_function.this.version
}

output "lambda_function_last_modified" {
  description = "Date this resource was last modified"
  value       = aws_lambda_function.this.last_modified
}

output "lambda_role_arn" {
  description = "ARN of the IAM role created for the Lambda Function"
  value       = var.create_role ? aws_iam_role.lambda[0].arn : var.lambda_role_arn
}

output "lambda_role_name" {
  description = "Name of the IAM role created for the Lambda Function"
  value       = var.create_role ? aws_iam_role.lambda[0].name : null
}

output "lambda_cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group for the Lambda Function"
  value       = var.create_log_group ? aws_cloudwatch_log_group.lambda[0].name : null
}

output "lambda_cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch Log Group for the Lambda Function"
  value       = var.create_log_group ? aws_cloudwatch_log_group.lambda[0].arn : null
}
