data "aws_ami" "amazon-linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
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
    inline = ["sudo hostnamectl set-hostname cloudEc2.technix.com"]
    connection {
      host        = self.public_dns
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("terraform.pem")
    }
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "chmod 600 ./terraform.pem"
  }

  provisioner "local-exec" {
    command     = "ansible-playbook -i ${aws_instance.dev_machine.public_ip}, --private-key ./terraform.pem nginx.yaml"
    working_dir = path.module
  }
}

output "public_ip" {
  value = aws_instance.dev_machine.public_ip
}
