data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_dir  = var.lambda_function_code_path
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_iam_role" "lambda_role" {
  name               = var.role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-function-policy"
  description = "IAM policy for the Lambda function"
  policy      = var.lambda_policy_document
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_policy.arn
}


resource "aws_lambda_function" "lambda_function" {
  filename         = data.archive_file.lambda_function_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_function_zip.output_path)
  role             = aws_iam_role.lambda_role.arn
  function_name    = var.function_name
  handler          = var.handler
  runtime          = var.runtime
  architectures    = var.architectures
  memory_size      = var.memory_size
  timeout          = var.timeout
  environment {
    variables = var.environment_variables
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
}