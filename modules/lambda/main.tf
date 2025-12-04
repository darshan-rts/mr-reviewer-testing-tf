resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.create_role ? aws_iam_role.lambda[0].arn : var.lambda_role_arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  filename         = var.filename
  source_code_hash = var.filename != null ? filebase64sha256(var.filename) : null

  s3_bucket         = var.s3_bucket
  s3_key            = var.s3_key
  s3_object_version = var.s3_object_version

  description = var.description
  layers      = var.layers

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [var.environment_variables] : []
    content {
      variables = environment.value
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config != null ? [var.dead_letter_config] : []
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config != null ? [var.tracing_config] : []
    content {
      mode = tracing_config.value.mode
    }
  }

  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                        = var.publish

  tags = var.tags
}

resource "aws_iam_role" "lambda" {
  count = var.create_role ? 1 : 0

  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role[0].json

  tags = var.tags
}

data "aws_iam_policy_document" "lambda_assume_role" {
  count = var.create_role ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  count = var.create_role && var.attach_cloudwatch_logs_policy ? 1 : 0

  role       = aws_iam_role.lambda[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_execution" {
  count = var.create_role && var.attach_vpc_policy ? 1 : 0

  role       = aws_iam_role.lambda[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "custom_policies" {
  for_each = var.create_role ? var.custom_policy_arns : {}

  role       = aws_iam_role.lambda[0].name
  policy_arn = each.value
}

resource "aws_lambda_permission" "this" {
  for_each = var.lambda_permissions

  statement_id  = each.key
  action        = each.value.action
  function_name = aws_lambda_function.this.function_name
  principal     = each.value.principal
  source_arn    = each.value.source_arn
}

resource "aws_cloudwatch_log_group" "lambda" {
  count = var.create_log_group ? 1 : 0

  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_in_days

  tags = var.tags
}
