terraform {
  required_version = "1.4.5"
}

provider "aws" {
  region     = "us-east-1"
  access_key = "{your access key}"
  secret_key = "{your secret key}"
}

resource "aws_instance" "kotlin_app_instance" {
  ami           = "{your ami}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["{your security group id}"]

  key_name = "{your key name}"

  connection {
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("${aws_instance.kotlin_app_instance.key_name}.pem}")
  }

  provisioner "remote-exec" {
    inline = [
      "git clone {your git repo url}",
      "cd {your project name}",
      "./gradlew bootRun"
    ]
  }
}
