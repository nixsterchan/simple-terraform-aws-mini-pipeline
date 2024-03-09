module "the_processing_lambda" {
  source = "./modules/lambda_function"

  function_name = var.the_processing_lambda_name
  handler = "lambda_function.lambda_handler"
  runtime = "python3.11"
  architectures = ["x86_64"]
  memory_size = 1024
  timeout = 180
  lambda_function_code_path = "some-path"
  lambda_policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowLogEvents",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Sid": "AllowGetObject",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "${module.ingestion_bucket.s3_bucket_arn}",
        "${module.ingestion_bucket.s3_bucket_arn}/*"
      ]
    },
    {
      "Sid": "AllowPutObject",
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": [
        "${module.processed_output_bucket.s3_bucket_arn}",
        "${module.processed_output_bucket.s3_bucket_arn}/*"
      ]
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
  source = "./modules/s3"
  bucket_name = var.ingestion_bucket_name
}

module "processed_output_bucket" {
  source = "./modules/s3"
  bucket_name = var.processed_output_bucket_name
}

module "queue_for_processing_lambda" {
  source = "./modules/sqs"
  queue_name = var.proc_lambda_sqs_name
  delay_seconds = 0
  max_message_size = 2048
  message_retention_seconds = 345600
  visibility_timeout_seconds = 300
  max_receive_count = 3
  sqs_policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Id": "SQSPolicy",
  "Statement": [
    {
      "Sid": "AllowReceiveMessageFromS3Bucket",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:${var.region}:*:${var.proc_lambda_sqs_name}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${module.ingestion_bucket.s3_bucket_arn}"
        }
      }
    }
  ]
}
EOF
  create_dlq = true
  dead_letter_queue_name = var.proc_lambda_dlq_name
}

# Setup S3 to send notifications to the queue
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.ingestion_bucket.s3_bucket_id

  queue {
    queue_arn = module.queue_for_processing_lambda.main_queue_arn
    events = ["s3:ObjectCreated:*"]
    filter_prefix = ""
    filter_suffix = ""
  }
}