provider "aws" {
  region     = "ap-southeast-2"
  access_key = "AKIARKBBREQN4B6R6CGW"
  secret_key = "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"
}

module "ec2" {
 source="/home/ec2-user/terraform/ec2"

}

module "vpc" {
 source="/home/ec2-user/terraform/vpc"
}

module "ebs" {
 source="/home/ec2-user/terraform/ebs"

}
