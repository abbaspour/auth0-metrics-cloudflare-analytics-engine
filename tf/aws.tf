resource "aws_s3_bucket" "metrics-export" {
  bucket = "cf-analytics-engine-exports"

}

resource "aws_iam_policy" "s3_write_list_policy" {
  name        = "s3_write_list_policy"
  description = "Policy allowing write access to S3 bucket"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.metrics-export.arn,
          "${aws_s3_bucket.metrics-export.arn}/*"
        ]
      },
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*",
        "Effect" : "Allow"
      },
    ]
  } )
}

locals {
  lambda-name = "cf-analytics-engine-exporter"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${local.lambda-name}"
  retention_in_days = 3
}

// Create CloudWatch Events rule for cron trigger
resource "aws_cloudwatch_event_rule" "lambda_cron_trigger" {
  name                = "${local.lambda-name}_cron_trigger"
  schedule_expression = "cron(* * * * ? *)" // Run every minute
}

// Add Lambda function as target to the CloudWatch Events rule
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_cron_trigger.name
  target_id = "target-lambda"
  arn       = aws_lambda_function.my_lambda_function.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_cron_trigger.arn
}

// Create Lambda function
resource "aws_lambda_function" "my_lambda_function" {
  function_name    = local.lambda-name
  handler          = "src/index.handler"
  runtime          = "nodejs20.x"
  memory_size      = 128
  timeout          = 60
  role             = aws_iam_role.lambda_execution_role.arn
  filename         = "../lambda/lambda.zip"
  source_code_hash = filebase64sha256("../lambda/lambda.zip")
  environment {
    variables = {
      bucketName = aws_s3_bucket.metrics-export.bucket
    }
  }
}

// Attach policy to Lambda execution role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.s3_write_list_policy.arn
}

// Create IAM role for Lambda function
resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}