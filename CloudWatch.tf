resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/madhatter_process_data"
  retention_in_days = 14
}

# CloudWatch Alarm for Lambda Errors
resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "madhatter_lambda_errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alarm if Lambda function has errors"

  dimensions = {
    FunctionName = aws_lambda_function.process_data.function_name
  }

  alarm_actions = [
    "arn:aws:sns:us-west-2:123456789012:notify-me" # Replace with your SNS topic ARN
  ]
}
