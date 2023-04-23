terraform {
  required_version = "1.4.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region     = local.region
  access_key = local.access_key
  secret_key = local.secret_key
}

resource "aws_instance" "dalle" {
  ami           = local.ami
  instance_type = local.instance_type
  tags = {
    Name = local.instance_name
  }
}

resource "null_resource" "dalle" {
  depends_on = [aws_instance.dalle]
  provisioner "local-exec" {
    command = "echo 'EC2 instance is up'"
  }
}

resource "null_resource" "ec2_application_deployed" {
  depends_on = [aws_instance.dalle]
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = local.instance_user
      private_key = file(local.private_key_path)
      host        = local.instance_ip_address
    }
    inline = [
      "sudo apt update",
      "echo \"Y\" | sudo apt-get install openjdk-17-jdk",
      "echo \"Y\" | sudo apt-get install gradle=7.6.1",
      "if [ -d \"${local.project_name}\" ]; then cd \"${local.project_name}\" && git pull; else git clone ${local.git_repo_url}; fi",
      "./gradlew bootRun"
    ]
  }
  provisioner "local-exec" {
    command = "echo 'Kotlin application deployed'"
  }
}
