provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "dev"
      Owner       = var.owner
    }
  }
}

terraform {
  required_version = "~> 1.3.6"
}
