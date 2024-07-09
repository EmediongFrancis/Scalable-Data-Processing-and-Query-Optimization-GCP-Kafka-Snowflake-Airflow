resource "aws_iam_role" "lambda_role" {
  name = "madhatter_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_policy" "lambda_policy" {
  name = "madhatter_lambda_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:*",
          "s3:*",
          "kinesis:*",
          "redshift:*",
          "athena:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "process_data" {
  function_name    = "madhatter_process_data"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  source_code_hash = filebase64sha256("lambda_function.zip")
  filename         = "lambda_function.zip"
  timeout          = 30

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.data_lake.bucket
    }
  }

  # Add Kinesis event source
}

resource "aws_lambda_event_source_mapping" "kinesis_lambda" {
  event_source_arn  = aws_kinesis_stream.data_stream.arn
  function_name     = aws_lambda_function.process_data.arn
  starting_position = "LATEST"
}
