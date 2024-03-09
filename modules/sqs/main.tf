# Create main SQS queue
resource "aws_sqs_queue" "main_queue" {
  name = var.queue_name
  delay_seconds = var.delay_seconds
  max_message_size = var.max_message_size
  message_retention_seconds = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  policy = var.sqs_policy_document
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue[0].arn
    maxReceiveCount     = var.max_receive_count
  })
}

# Create dead letter queue if enabled
resource "aws_sqs_queue" "dead_letter_queue" {
  count = var.create_dlq ? 1 : 0
  name  = var.dead_letter_queue_name
}

# Define the policy for allowing the main queue to send messages to the dead letter queue
resource "aws_sqs_queue_redrive_allow_policy" "main_queue_policy" {
  count = var.create_dlq ? 1 : 0
  queue_url = aws_sqs_queue.main_queue[0].id
  
  redrive_allow_policy = jsondecode({
    redrivePermission = "byQueue",
    sourceQueueArns = [aws_sqs_queue.main_queue.arn]
  })
}
