terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "envisia"

    workspaces {
      name = "KAFKA_INFRASTRUCTURE"
    }
  }
}