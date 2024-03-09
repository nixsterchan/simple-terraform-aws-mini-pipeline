variable "the_processing_lambda_name" {
  type = string
  default = "lambda-processing-module"
}
variable "region" {
  type = string
  default = "ap-southeast-1"
}
variable "ingestion_bucket_name" {
  type = string
  default = "mini-pipe-ingestion"
}
variable "processed_output_bucket_name" {
  type = string
  default = "mini-pipe-processed-outputs"
}
variable "proc_lambda_sqs_name" {
  type = string
  default = "queue-lambda-processing-module"
}
variable "proc_lambda_dlq_name" {
  type = string
  default = "dlq-lambda-processing-module"
}