# Basic Lambda Example

This example demonstrates how to use the Lambda Terraform module to create a simple AWS Lambda function.

## Usage

1. Create a simple Lambda deployment package:

```bash
# Create a simple Python Lambda function
cat > index.py << 'EOF'
def handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello from Lambda!'
    }
EOF

# Package it into a zip file
zip lambda_function.zip index.py
```

2. Initialize and apply the Terraform configuration:

```bash
terraform init
terraform plan
terraform apply
```

## What This Example Creates

- AWS Lambda function with Python 3.12 runtime
- IAM role with CloudWatch Logs permissions
- CloudWatch Log Group with 7-day retention

## Clean Up

To destroy all resources created by this example:

```bash
terraform destroy
```

## Requirements

- AWS credentials configured
- Terraform >= 1.0
- AWS provider >= 4.0
