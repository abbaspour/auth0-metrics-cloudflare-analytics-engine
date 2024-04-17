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
      }
    ]
  } )
}

// Create CloudWatch Events rule for cron trigger
resource "aws_cloudwatch_event_rule" "lambda_cron_trigger" {
  name                = "lambda_cron_trigger"
  schedule_expression = "cron(* * * * ? *)" // Run every minute
}

// Add Lambda function as target to the CloudWatch Events rule
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_cron_trigger.name
  target_id = "target-lambda"
  arn       = aws_lambda_function.my_lambda_function.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../lambda.js"
  output_path = "lambda_function_payload.zip"
}

// Create Lambda function
resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my_lambda_function"
  handler       = "lambda.handler"
  runtime       = "nodejs20.x"
  memory_size   = 128
  timeout       = 60
  role          = aws_iam_role.lambda_execution_role.arn
  filename      = "lambda_function_payload.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256
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