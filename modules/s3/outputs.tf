output "s3_bucket_arn" {
  description = "The Amazon Resource Name (ARN) of the created S3 bucket."
  value       = aws_s3_bucket.s3_bucket.arn
}
output "s3_bucket_id" {
  description = "The Amazon Resource Name (ARN) of the created S3 bucket."
  value       = aws_s3_bucket.s3_bucket.id
}