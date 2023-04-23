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
      "docker stop $(docker ps -a -q)",
      "docker pull ${local.docker_user_name}/${local.project_name}:${local.docker_version}",
      "docker run  ${local.docker_user_name}/${local.project_name}:${local.docker_version}",
    ]
  }
  provisioner "local-exec" {
    command = "echo 'Kotlin application deployed'"
  }
}
