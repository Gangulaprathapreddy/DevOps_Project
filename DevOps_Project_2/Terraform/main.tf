data "aws_ami" "amazon-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ssh_user = "ec2-user"
}

resource "aws_instance" "dev_machine" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = "t2.micro"
  key_name      = "terraform"

  tags = {
    Environment = "dev"
    Name        = "${var.name}-server"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = aws_instance.dev_machine.key_name != "" ? null : ""
      host        = aws_instance.dev_machine.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.dev_machine.public_ip}, nginx.yaml"
  }
}
