variable "function_name" {
  description = "Unique name for the Lambda Function"
  type        = string
}

variable "handler" {
  description = "Function entrypoint in your code"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Runtime environment for the Lambda function"
  type        = string
  default     = "python3.9"
}

variable "timeout" {
  description = "Amount of time your Lambda Function has to run in seconds"
  type        = number
  default     = 3
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 128
}

variable "filename" {
  description = "Path to the function's deployment package within the local filesystem"
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket location containing the function's deployment package"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of an object containing the function's deployment package"
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "Object version containing the function's deployment package"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of what your Lambda Function does"
  type        = string
  default     = ""
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs to attach to your Lambda Function"
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Map of environment variables that are accessible from function code during execution"
  type        = map(string)
  default     = {}
}

variable "vpc_config" {
  description = "VPC configuration for the Lambda function"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "dead_letter_config" {
  description = "Dead letter queue configuration for the Lambda function"
  type = object({
    target_arn = string
  })
  default = null
}

variable "tracing_config" {
  description = "X-Ray tracing configuration"
  type = object({
    mode = string
  })
  default = null
}

variable "reserved_concurrent_executions" {
  description = "Amount of reserved concurrent executions for this lambda function"
  type        = number
  default     = -1
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "create_role" {
  description = "Whether to create an IAM role for the Lambda function"
  type        = bool
  default     = true
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role to attach to the Lambda function (only used if create_role is false)"
  type        = string
  default     = null
}

variable "attach_cloudwatch_logs_policy" {
  description = "Whether to attach the AWSLambdaBasicExecutionRole policy to the Lambda role"
  type        = bool
  default     = true
}

variable "attach_vpc_policy" {
  description = "Whether to attach the AWSLambdaVPCAccessExecutionRole policy to the Lambda role"
  type        = bool
  default     = false
}

variable "custom_policy_arns" {
  description = "Map of custom policy ARNs to attach to the Lambda role"
  type        = map(string)
  default     = {}
}

variable "lambda_permissions" {
  description = "Map of Lambda permission configurations"
  type = map(object({
    action     = string
    principal  = string
    source_arn = optional(string)
  }))
  default = {}
}

variable "create_log_group" {
  description = "Whether to create a CloudWatch Log Group for the Lambda function"
  type        = bool
  default     = true
}

variable "log_retention_in_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 14
}
