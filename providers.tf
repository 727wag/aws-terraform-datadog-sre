terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "5.0"
      }
      datadog = {
        source = "Datadog/datadog"
      }
    }
}

provider "aws" {
    region = "us-east-1"
}

provider "datadog" {
    api_key = var.datadog_api_key
    app_key = var.datadog_app_key
}