# Overview

This is Terraform configuration to deploy a simple AWS s3 bucket using Terraform with GitHub Actions with IAM role GithubActionsRole via OpenID Connect (OIDC).

This configuration contains two subdirectories to setup the AWS resources:

* github-role
* s3-bucket-backend

To deploy this example, you need to first configure use contents of s3-bucket-backend, then github-role, and only then you can setup github secrets to successfully deploy this example.

Each subdirectory contains a README.md file with instructions to deploy the resources.

## Github Actions Workflow: terraform-check-plan-apply.yaml

This YAML file defines a Github Actions workflow that automates the Terraform deployment process for our project. The workflow consists of three jobs: `terraform-check`, `terraform-plan`, and `terraform-apply`.

### Prerequisites

Before running this workflow, you need to set up the following secrets in your repository:

1. **`AWS_REGION`**: Your AWS region where the resources will be created.
2. **`BACKEND_S3_BUCKET_NAME`**: The name of the S3 bucket used as a backend for Terraform state.
3. **`BACKEND_S3_STATE_PATH`**: The path within the S3 bucket to store the Terraform state.
4. **`AWS_ROLE_TO_ASSUME`**: The ARN of an IAM role that will be assumed by the Github Actions workflow to access AWS resources.

To set up these secrets, follow these steps:

### Set up Github Secrets

1. Log in to your Github account and navigate to your repository.
2. Click on the "Settings" icon (looks like a gear) next to your repository name.
3. Select "Actions" from the left-hand menu.
4. Scroll down to the "Secrets" section.
5. Click on the "New secret" button.
6. Enter the following secrets and their corresponding values for `AWS_REGION`, `BACKEND_S3_BUCKET_NAME`, `BACKEND_S3_STATE_PATH`, `AWS_ROLE_TO_ASSUME`

## Deploy

To deploy the code you create pull request to the default branch or just push changes to the default branch.

This will trigger the workflow and use configuration you are provided in ./task_1/. By default it will create just simple s3 bucket with name `some-s3-bucket-thirdmadman-rs-school-task1`, and store Terraform state in s3 bucket in AWS, witch you are provided in GitHub Secrets.
