terraform {
  backend "s3" {
    bucket         = "your-s3-bucket-name"
    key            = "terraform/state/eks-cluster.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "your-dynamodb-table-name"
  }
}
