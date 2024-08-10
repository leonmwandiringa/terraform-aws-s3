provider "aws" {
  region = "us-east-2"
}

module "s3_bucket" {
  source = "../.."
  bucket_name = "testo1"
  tags   = {
    Name = "example_bucket"
    Author      = "LTM"
    Environment = "dev"
    Provisioner = "terraform"
    Region      = "us-east-2"
  }
}
