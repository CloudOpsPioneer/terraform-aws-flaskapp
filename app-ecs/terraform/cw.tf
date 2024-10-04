resource "aws_cloudwatch_log_group" "app" {
  name              = "flask-ui"
  retention_in_days = 1
}

