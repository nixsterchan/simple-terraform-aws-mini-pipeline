output "main_queue_arn" {
  description = "The Amazon Resource Name (ARN) of the main SQS queue."
  value       = aws_sqs_queue.main_queue.arn
}

output "dead_letter_queue_arn" {
  description = "The Amazon Resource Name (ARN) of the dead letter queue, if created."
  value       = var.create_dlq ? aws_sqs_queue.dead_letter_queue[0].arn : null
}