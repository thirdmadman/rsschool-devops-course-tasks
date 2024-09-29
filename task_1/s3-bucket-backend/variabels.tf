variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "backend_s3_bucket_name" {
  description = "Terraform backend (state) bucket name"
  type        = string
}