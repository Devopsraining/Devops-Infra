terraform {
  backend "gcs" {
    bucket = "devops-tf-state-devops-497707"
    prefix = "main/terraform.tfstate"
  }
}
