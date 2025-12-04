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

module "lambda_function_with_vpc" {
  source = "../../modules/lambda"

  function_name = "advanced-lambda-function"
  handler       = "index.handler"
  runtime       = "python3.9"
  timeout       = 60
  memory_size   = 512

  filename = "${path.module}/lambda_function.zip"

  description = "Advanced Lambda function with VPC configuration"

  environment_variables = {
    ENVIRONMENT = "production"
    LOG_LEVEL   = "DEBUG"
    DB_HOST     = "database.example.com"
  }

  vpc_config = length(var.subnet_ids) > 0 && length(var.security_group_ids) > 0 ? {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  } : null

  dead_letter_config = var.dlq_arn != "" ? {
    target_arn = var.dlq_arn
  } : null

  tracing_config = {
    mode = "Active"
  }

  create_role                   = true
  attach_cloudwatch_logs_policy = true
  attach_vpc_policy             = true

  custom_policy_arns = {
    s3_access      = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    dynamodb_access = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
  }

  lambda_permissions = merge(
    var.api_gateway_source_arn != "" ? {
      allow_api_gateway = {
        action     = "lambda:InvokeFunction"
        principal  = "apigateway.amazonaws.com"
        source_arn = var.api_gateway_source_arn
      }
    } : {},
    var.eventbridge_rule_arn != "" ? {
      allow_eventbridge = {
        action     = "lambda:InvokeFunction"
        principal  = "events.amazonaws.com"
        source_arn = var.eventbridge_rule_arn
      }
    } : {}
  )

  layers = var.lambda_layers

  reserved_concurrent_executions = 10
  publish                        = true

  create_log_group      = true
  log_retention_in_days = 30

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Example     = "advanced-lambda"
    Application = "MyApp"
  }
}
