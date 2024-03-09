variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "handler" {
  type        = string
  description = "Lambda function handler"
}

variable "runtime" {
  type        = string
  description = "Runtime environment for the Lambda function (e.g., python3.11)"
}

variable "lambda_function_code_path" {
  type        = string
  description = "Local path to the Lambda function's code directory"
}

variable "architectures" {
  type = list(string)
  description = "Specified architecture to be used for the creation of the lambda function"
}

variable "timeout" {
  type = number
  description = "Specifies the time in seconds, that the Lambda will last before timing out"
}

variable "memory_size" {
  type = number
  description = "Specifies the amount of memory in MB that the Lambda function will run on"
}

variable "role_name" {
  type        = string
  description = "Name of the IAM role for the Lambda function"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the Lambda function"
  default     = {}
}

variable "lambda_policy_document" {
  type        = string
  description = "IAM policy document for the Lambda function"
}
