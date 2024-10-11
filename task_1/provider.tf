terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = var.backend_s3_bucket_name
    key     = var.backend_s3_state_path
    region  = var.aws_region
    encrypt = true
  }
}