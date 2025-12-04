variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Lambda function"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs for the Lambda function"
  type        = list(string)
  default     = []
}

variable "dlq_arn" {
  description = "ARN of the dead letter queue (SQS or SNS)"
  type        = string
  default     = ""
}

variable "api_gateway_source_arn" {
  description = "ARN of the API Gateway that can invoke the Lambda"
  type        = string
  default     = ""
}

variable "eventbridge_rule_arn" {
  description = "ARN of the EventBridge rule that can invoke the Lambda"
  type        = string
  default     = ""
}

variable "lambda_layers" {
  description = "List of Lambda Layer ARNs to attach"
  type        = list(string)
  default     = []
}
