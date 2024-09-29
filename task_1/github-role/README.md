# GitHub Actions Role Terraform Configuration

This directory contains a Terraform configuration to create an IAM role for use with GitHub Actions.

## Overview

This configuration creates an IAM role with broad permissions, including access to EC2, Route53, S3, IAM, VPC, SQS, and EventBridge. This is intended for use in a CI/CD pipeline where the GitHub Actions workflow needs to perform a wide range of operations on AWS resources.

## Requirements

* Terraform >= 1.0
* AWS credentials configured on your machine
* Your GitHub organization and repository and desired AWS provider region name specified in `terraform.tfvars`

## Usage

1. Create a copy of `terraform.tfvars.example` named `terraform.tfvars`
2. Update the values for `github_org`, `github_repo`, and `aws_region` to match your desired configuration
3. Run `terraform init` to initialize the Terraform working directory
4. Run `terraform apply` to create the IAM role and attach policies

## Outputs

The `outputs.tf` file defines a single output value:

* `github_actions_role_arn`: The ARN of the IAM role created by this configuration

You can reference this output value in your Terraform code or CI/CD pipeline.

## Policies

This configuration attaches the following AWS-managed policies to the IAM role:

* AmazonEC2FullAccess
* AmazonRoute53FullAccess
* AmazonS3FullAccess
* IAMFullAccess
* AmazonVPCFullAccess
* AmazonSQSFullAccess
* AmazonEventBridgeFullAccess
