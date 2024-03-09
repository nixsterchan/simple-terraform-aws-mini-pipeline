variable "the_processing_lambda_name" {
  type = string
}
variable "region" {
  type = string
}
variable "ingestion_bucket_name" {
  type = string
}
variable "processed_output_bucket_name" {
  type = string
}
variable "proc_lambda_sqs_name" {
  type = string
}
variable "proc_lambda_dlq_name" {
  type = string
}