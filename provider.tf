terraform {
  required_version = ">= 0.13.2"
}

provider "aws" {
  version                 = ">= 3.5.0, <= 3.5.0"
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}
