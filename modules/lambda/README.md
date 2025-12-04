# AWS Lambda Terraform Module

This Terraform module creates an AWS Lambda function with associated IAM roles, permissions, and CloudWatch log groups.

## Features

- Creates AWS Lambda function with configurable runtime, memory, and timeout
- Optional IAM role creation with customizable policies
- Support for both local file and S3-based deployment packages
- VPC configuration support
- Dead letter queue configuration
- X-Ray tracing support
- CloudWatch Logs integration with configurable retention
- Lambda permissions for external services
- Lambda layers support
- Environment variables configuration
- Concurrent execution limits

## Usage

### Basic Example

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name = "my-lambda-function"
  handler       = "index.handler"
  runtime       = "python3.9"
  filename      = "lambda_function.zip"

  environment_variables = {
    ENV = "production"
  }

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### Example with S3 Deployment

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name = "my-lambda-function"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  
  s3_bucket = "my-lambda-deployment-bucket"
  s3_key    = "lambda-functions/my-function.zip"

  memory_size = 256
  timeout     = 30
}
```

### Example with VPC Configuration

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name = "my-vpc-lambda"
  handler       = "index.handler"
  runtime       = "python3.9"
  filename      = "lambda_function.zip"

  vpc_config = {
    subnet_ids         = ["subnet-12345678", "subnet-87654321"]
    security_group_ids = ["sg-12345678"]
  }

  attach_vpc_policy = true
}
```

### Example with Custom IAM Policies

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name = "my-lambda-function"
  handler       = "index.handler"
  runtime       = "python3.9"
  filename      = "lambda_function.zip"

  create_role = true
  
  custom_policy_arns = {
    dynamodb = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
    s3       = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  }
}
```

### Example with Lambda Permissions

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name = "my-lambda-function"
  handler       = "index.handler"
  runtime       = "python3.9"
  filename      = "lambda_function.zip"

  lambda_permissions = {
    allow_api_gateway = {
      action     = "lambda:InvokeFunction"
      principal  = "apigateway.amazonaws.com"
      source_arn = "arn:aws:execute-api:us-east-1:123456789012:abcdef/*/*/*"
    }
  }
}
```

### Example with Existing IAM Role

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name   = "my-lambda-function"
  handler         = "index.handler"
  runtime         = "python3.9"
  filename        = "lambda_function.zip"

  create_role     = false
  lambda_role_arn = "arn:aws:iam::123456789012:role/existing-lambda-role"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| function_name | Unique name for the Lambda Function | `string` | n/a | yes |
| handler | Function entrypoint in your code | `string` | `"index.handler"` | no |
| runtime | Runtime environment for the Lambda function | `string` | `"python3.9"` | no |
| timeout | Amount of time your Lambda Function has to run in seconds | `number` | `3` | no |
| memory_size | Amount of memory in MB your Lambda Function can use at runtime | `number` | `128` | no |
| filename | Path to the function's deployment package within the local filesystem | `string` | `null` | no |
| s3_bucket | S3 bucket location containing the function's deployment package | `string` | `null` | no |
| s3_key | S3 key of an object containing the function's deployment package | `string` | `null` | no |
| s3_object_version | Object version containing the function's deployment package | `string` | `null` | no |
| description | Description of what your Lambda Function does | `string` | `""` | no |
| layers | List of Lambda Layer Version ARNs to attach to your Lambda Function | `list(string)` | `[]` | no |
| environment_variables | Map of environment variables that are accessible from function code during execution | `map(string)` | `{}` | no |
| vpc_config | VPC configuration for the Lambda function | `object` | `null` | no |
| dead_letter_config | Dead letter queue configuration for the Lambda function | `object` | `null` | no |
| tracing_config | X-Ray tracing configuration | `object` | `null` | no |
| reserved_concurrent_executions | Amount of reserved concurrent executions for this lambda function | `number` | `-1` | no |
| publish | Whether to publish creation/change as new Lambda Function Version | `bool` | `false` | no |
| tags | Map of tags to assign to resources | `map(string)` | `{}` | no |
| create_role | Whether to create an IAM role for the Lambda function | `bool` | `true` | no |
| lambda_role_arn | ARN of the IAM role to attach to the Lambda function | `string` | `null` | no |
| attach_cloudwatch_logs_policy | Whether to attach the AWSLambdaBasicExecutionRole policy | `bool` | `true` | no |
| attach_vpc_policy | Whether to attach the AWSLambdaVPCAccessExecutionRole policy | `bool` | `false` | no |
| custom_policy_arns | Map of custom policy ARNs to attach to the Lambda role | `map(string)` | `{}` | no |
| lambda_permissions | Map of Lambda permission configurations | `map(object)` | `{}` | no |
| create_log_group | Whether to create a CloudWatch Log Group for the Lambda function | `bool` | `true` | no |
| log_retention_in_days | Number of days to retain CloudWatch logs | `number` | `14` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda_function_arn | ARN of the Lambda Function |
| lambda_function_name | Name of the Lambda Function |
| lambda_function_invoke_arn | Invoke ARN of the Lambda Function |
| lambda_function_qualified_arn | Qualified ARN of the Lambda Function |
| lambda_function_version | Latest published version of the Lambda Function |
| lambda_function_last_modified | Date this resource was last modified |
| lambda_role_arn | ARN of the IAM role created for the Lambda Function |
| lambda_role_name | Name of the IAM role created for the Lambda Function |
| lambda_cloudwatch_log_group_name | Name of the CloudWatch Log Group |
| lambda_cloudwatch_log_group_arn | ARN of the CloudWatch Log Group |

## Notes

- Either `filename` or `s3_bucket` + `s3_key` must be provided for the deployment package
- When using VPC configuration, ensure `attach_vpc_policy` is set to `true`
- The module automatically creates a CloudWatch Log Group unless `create_log_group` is set to `false`
- Tags are applied to all resources created by the module

## License

This module is provided as-is for testing purposes.
