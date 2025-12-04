# Advanced Lambda Example

This example demonstrates advanced features of the Lambda Terraform module, including:

- VPC configuration
- Dead letter queue configuration
- X-Ray tracing
- Lambda permissions for multiple services
- Custom IAM policies
- Lambda layers
- Concurrent execution limits
- Function versioning

## Usage

1. Create a Lambda deployment package:

```bash
# Create a simple Python Lambda function
cat > index.py << 'EOF'
import json
import os

def handler(event, context):
    environment = os.environ.get('ENVIRONMENT', 'unknown')
    log_level = os.environ.get('LOG_LEVEL', 'INFO')
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Hello from Advanced Lambda!',
            'environment': environment,
            'log_level': log_level
        })
    }
EOF

# Package it into a zip file
zip lambda_function.zip index.py
```

2. Customize the variables or create a `terraform.tfvars` file:

```hcl
aws_region = "us-east-1"

subnet_ids = [
  "subnet-12345678",
  "subnet-87654321"
]

security_group_ids = [
  "sg-12345678"
]

dlq_arn = "arn:aws:sqs:us-east-1:123456789012:lambda-dlq"

api_gateway_source_arn = "arn:aws:execute-api:us-east-1:123456789012:abcdefg/*/*/*"

eventbridge_rule_arn = "arn:aws:events:us-east-1:123456789012:rule/my-rule"

lambda_layers = [
  "arn:aws:lambda:us-east-1:123456789012:layer:my-layer:1"
]
```

3. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

## Features Demonstrated

### VPC Integration
Lambda function is deployed within a VPC with specified subnets and security groups.

### Dead Letter Queue
Failed invocations are sent to a configured DLQ for further processing.

### X-Ray Tracing
Active tracing is enabled for monitoring and debugging.

### Multiple Permissions
The function can be invoked by both API Gateway and EventBridge.

### Custom IAM Policies
Read-only access to S3 and DynamoDB is granted through managed policies.

### Concurrent Execution Limits
Reserved concurrent executions are set to prevent resource exhaustion.

### Function Versioning
The function is published with versioning enabled.

## Clean Up

```bash
terraform destroy
```

## Requirements

- AWS credentials configured
- Terraform >= 1.0
- AWS provider >= 4.0
- Existing VPC, subnets, and security groups (if using VPC config)
- DLQ ARN (if using dead letter config)
