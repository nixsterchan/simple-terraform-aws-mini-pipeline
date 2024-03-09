module "the_processing_lambda" {
  source = "./modules/lambda_function"

  function_name = var.the_processing_lambda_name
  handler = "lambda_function.lambda_handler"
  runtime = "python3.11"
  architectures = ["arm64"]
  memory_size = 1024
  timeout = 180
  lambda_function_code_path = "some-path"
  lambda_policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::example-bucket/*"
    }
  ]
}
EOF
  environment_variables = {
    "CHUNKSIZE" = "60"
    "DESTINATION_BUCKET_NAME" = "processed-output-bucket"
  }
}

module "ingestion_bucket" {
  source            = "./s3_module"
  bucket_name       = "mini-pipe-ingestion"
}

module "processed_output_bucket" {
  source            = "./s3_module"
  bucket_name       = "mini-pipe-processed-outputs"
}
