variable "queue_name" {
  type = string
  description = "The name of the main SQS queue."
}
variable "delay_seconds" {
  type = number
  description = "The time in seconds that the delivery of all messages in the queue will be delayed."
}
variable "max_message_size" {
  type = number
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it."
}
variable "message_retention_seconds" {
  type = number
  description = "The number of seconds Amazon SQS retains a message."
}
variable "visibility_timeout_seconds" {
  type = number
  description = "The visibility timeout for the queue, in seconds."
}
variable "max_receive_count" {
  type = number
  description = "The number of times a message is delivered to the source queue before being moved to the dead letter queue."
}
variable "sqs_policy_document" {
  type = string
  description = "IAM policy document for the SQS queue"
}
variable "create_dlq" {
  type = bool
  description = "Determines whether a DLQ will be created and attached to the queue currently being created"
  default = false
}
variable "dead_letter_queue_name" {
  type = string
  description = "The name of the dead letter queue."
  default = ""
}