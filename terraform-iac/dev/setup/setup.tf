terraform {
  required_version = "1.3.2"
  backend "s3" {
    bucket         = "terraform-state-storage-267223774717"
    dynamodb_table = "terraform-state-lock-267223774717"
    key            = "fargate-test/dev/setup.tfstate"
    region         = "us-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

locals {
  env = "dev"
}

provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      repo                   = "https://github.com/byu-oit/fargate-test"
      data-sensitivity       = "public"
      env                    = local.env
      resource-creator-email = "GitHub-Actions"
    }
  }
}

variable "some_secret" {
  type        = string
  description = "Some secret string that will be stored in SSM and mounted into the Fargate Tasks as an environment variable"
}

module "setup" {
  source      = "../../modules/setup/"
  env         = local.env
  some_secret = var.some_secret
}
