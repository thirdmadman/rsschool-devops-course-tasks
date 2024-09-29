# Terraform backend (state) on Amazon S3 bucket

This directory contains a Terraform configuration to create a Terraform backend (state) on Amazon S3 bucket.

## Overview

This Terraform configuration creates an Amazon S3 bucket to store Terraform state files. The bucket is enabled with versioning, which allows Terraform to keep a history of changes made to the infrastructure.

## Requirements

* Terraform version 1.0 or later
* AWS credentials configured on your machine
* Your AWS provider region name and Amazon S3 bucket name to store Terraform state specified in `terraform.tfvars`

## Usage

1. Create a copy of `terraform.tfvars.example` named `terraform.tfvars`
2. Update the values for `aws_region`, `backend_s3_bucket_name` to match your desired configuration
3. Run `terraform init` to initialize the Terraform working directory
4. Run `terraform apply` to create the IAM role and attach policies
