terraform {
  backend "gcs" {
    bucket = "devops-tf-state-devops-513617"
    prefix = "main/terraform.tfstate"
  }
}
