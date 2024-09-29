# Load all configuration files
terraform {
  required_version = ">= 1.0"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.backend_s3_bucket_name
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}