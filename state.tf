terraform{
    backend "s3" {
        bucket = "terraform-aws-codepipeline"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}

provider "aws" {
    region = "us-east-1"
}