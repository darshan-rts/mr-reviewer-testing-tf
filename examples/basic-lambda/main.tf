terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "lambda_function" {
  source = "../../modules/lambda"

  function_name = "example-lambda-function"
  handler       = "index.handler"
  runtime       = "python3.9"
  timeout       = 30
  memory_size   = 256

  filename = "${path.module}/lambda_function.zip"

  description = "Example Lambda function created by Terraform"

  environment_variables = {
    ENVIRONMENT = "development"
    LOG_LEVEL   = "INFO"
  }

  create_role                    = true
  attach_cloudwatch_logs_policy  = true
  
  create_log_group      = true
  log_retention_in_days = 7

  tags = {
    Environment = "development"
    ManagedBy   = "Terraform"
    Example     = "basic-lambda"
  }
}
