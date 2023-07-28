terraform {
  required_version = "~> 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Terraform = "True"
      Repo      = "practice-svelte-fargate"
    }
  }
}